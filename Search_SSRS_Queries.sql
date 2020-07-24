USE [dB Name]
GO



declare @txtSearch char(50) = 'SOMETHING';

WITH XMLNAMESPACES 
( DEFAULT 
  'http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition'
, 'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS ReportDefinition )
SELECT  
CATDATA.Name AS ReportName
,CATDATA.Path AS ReportPathLocation
,xmlcolumn.value('(@Name)[1]', 'VARCHAR(250)') AS DataSetName  
,xmlcolumn.value('(Query/DataSourceName)[1]','VARCHAR(250)') AS DataSoureName 
,xmlcolumn.value('(Query/CommandText)[1]','VARCHAR(2500)') AS CommandText
FROM (  
	SELECT C.Name
	,c.Path
	,CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
	FROM  ReportServer.dbo.Catalog C
	WHERE  C.Content is not null
	AND  C.Type = 2
	) CATDATA
CROSS APPLY reportXML.nodes('/Report/DataSets/DataSet') xmltable ( xmlcolumn )
WHERE 
upper(xmlcolumn.value('(Query/CommandText)[1]','VARCHAR(250)')) LIKE '%' + rtrim(upper(@txtSearch)) + '%'
ORDER BY CATDATA.Name





