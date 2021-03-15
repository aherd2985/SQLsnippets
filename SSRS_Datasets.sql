-- Provided "as is" with no warranties of any kind. User assumes all risks of use.
/* The XML XQuery statements used below ignore namespace so that information can be retrieved
   from multiple RDL versions. */
use ReportServer
;WITH CatalogWithXml AS (
    -- XMLifyies Catalog's Content column.
    /* For report (Type = 2) and shared data source (Type = 5) objects, the image-typed column
       Content stores the XML RDL defining the object. We convert this column to XML so that SQL's
       XML type's functions can be used on it. */
    SELECT *,
         ContentXml = (CONVERT(XML, CONVERT(VARBINARY(MAX), Content)))
    FROM Catalog
),

SharedDataSources AS (
    -- Details on uses of shared data sources.
    -- * Unused data sources are ignored.
    -- * ItemID identifies the catalog entry (e.g. report) using the shared data source. It is not
    --   the data source's ID!
    /* Table DataSource contains a row for each data source (embedded or shared) used in each report.
       Its column Name stores the data source name, as defined in the report. Shared data sources are
       defined (RDL XML) in the catalog. Inner joining between these two tables limits this CTE's
       resultset to details on shared data sources because embedded data sources don't have Link-ed
       rows in the catalog. */
    SELECT ds.ItemID,
        SharedDataSourceName = c.Name,
        LocalDataSourceName = ds.Name,
        DataProvider = ContentXML.value('(/*:DataSourceDefinition/*:Extension)[1]', 'NVARCHAR(260)'),
        ConnectionString = ContentXML.value('(/*:DataSourceDefinition/*:ConnectString)[1]', 'NVARCHAR(MAX)')
    -- Each DataSource row with a Link value represents a use of a shared data source.
    FROM DataSource ds
        -- Uses the Link value to look up the catalog entry defining the shared data source.
        JOIN CatalogWithXml c ON ds.Link = c.ItemID
),

AllDataSources AS (
    -- Details on both embedded & shared data sources *used* by reports.
    /* Embedded data sources are defined in the hosting report's RDL. Shared data sources are
       referenced (but not defined) in this RDL. We extract the relevant details and then join
       to the SharedDataSources CTE to assemble a resultset with details on each data source
       (embedded and shared) used by each report (identified by ItemID). */
    SELECT r.ItemID,
        r.LocalDataSourceName, -- embedded data source's name or local name given to shared data source
        sds.SharedDataSourceName,
        SharedDataSource = CAST ((CASE WHEN sds.SharedDataSourceName IS NOT NULL THEN 1 ELSE 0 END) AS BIT),
        DataProvider = ISNULL(r.DataProvider, sds.DataProvider),
        ConnectionString = ISNULL(r.ConnectionString, sds.ConnectionString)
    FROM (
        SELECT c.*,
                LocalDataSourceName = DataSourceXml.value('@Name', 'NVARCHAR(260)'),
                DataProvider = DataSourceXml.value('(*:ConnectionProperties/*:DataProvider)[1]', 'NVARCHAR(260)'),
                ConnectionString = DataSourceXml.value('(*:ConnectionProperties/*:ConnectString)[1]', 'NVARCHAR(MAX)')
            FROM CatalogWithXml c
                CROSS APPLY ContentXml.nodes('/*:Report/*:DataSources/*:DataSource') DataSource(DataSourceXml)
            WHERE c.Type = 2 -- limit to reports only
        ) r
        LEFT JOIN SharedDataSources sds ON r.ItemID = sds.ItemID AND r.LocalDataSourceName = sds.LocalDataSourceName
),

DataSets AS (
    -- Details on data sets used in reports.
    /* Outputs one row per data set used in each report. */
    SELECT ItemID,
        DataSetName = QueryXml.value('@Name', 'NVARCHAR(256)'),
        DataSourceName = QueryXml.value('(*:Query/*:DataSourceName)[1]', 'NVARCHAR(260)'),
        CommandType = QueryXml.value('(*:Query/*:CommandType)[1]', 'NVARCHAR(15)'),
        CommandText = QueryXml.value('(*:Query/*:CommandText)[1]', 'NVARCHAR(MAX)')
    FROM CatalogWithXml
        CROSS APPLY ContentXml.nodes('/*:Report/*:DataSets/*:DataSet') QueryData(QueryXml)
),

Data AS (
    -- Combines data set and data source details with additional information from Catalog.
    SELECT ds.ItemID,
        Name,
        Path,  
        LocalDataSourceName,
        SharedDataSource,
        SharedDataSourceName,
        DataProvider,
        ConnectionString,
        DataSetName,
        CommandType = ISNULL(CommandType, 'Text'), -- "Text" = default command type
        CommandText
    FROM DataSets ds
        JOIN AllDataSources src ON src.ItemID = ds.ItemID AND src.LocalDataSourceName = ds.DataSourceName
        JOIN Catalog c ON ds.ItemID = c.ItemID
)

SELECT * FROM Data
