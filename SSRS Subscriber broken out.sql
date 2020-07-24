--Create and populate a Numbers table 
  CREATE TABLE dbo.Numbers (Number int PRIMARY KEY) 
 
  INSERT INTO dbo.Numbers (Number) 
  SELECT TOP 5000  
  ROW_NUMBER() OVER (ORDER BY c1.object_id) 
  FROM 
    sys.columns c1 
    JOIN sys.columns c2 ON 1=1     
GO 
 
--Create a user-defined function to parse delimited strings into rows 
CREATE FUNCTION dbo.udftGetParsedValues( 
  @InputString varchar(MAX), 
  @Delimiter char(1) 
) 
RETURNS @tvValues TABLE ( 
  [Value] varchar(MAX), 
  [Index] int) 
AS  
BEGIN 
  IF @Delimiter <> ' ' BEGIN 
    SET @Delimiter = NULLIF(@Delimiter, '') 
  END 
   
  --Remove trailng delimiters 
  WHILE RIGHT(@InputString,1) = @Delimiter BEGIN 
    SET @InputString = LEFT(@InputString, LEN(@InputString + 'x') - 1 - 1) 
  END 
 
  INSERT INTO @tvValues ([Value], [Index]) 
  SELECT SUBSTRING( @Delimiter + @InputString + @Delimiter, N.Number + 1,  
         CHARINDEX( @Delimiter, @Delimiter + @InputString + @Delimiter, N.Number + 1 ) - N.Number - 1 ), 
    ROW_NUMBER() OVER (ORDER BY N.Number) 
  FROM dbo.Numbers N 
  WHERE 
    SUBSTRING( @Delimiter + @InputString + @Delimiter, N.Number, 1 ) = @Delimiter AND 
    N.Number < (LEN( @Delimiter + @InputString + @Delimiter + 'x' ) - 1) 
  RETURN 
END 
GO 
 
--Query to retrieve all subscribers to all SSRS report, listing each subscriber 
--on a separate row 
SELECT 
  LTRIM(RTRIM(pv.Value)) AS Subscriber, 
  y.ReportPath 
FROM (   
  SELECT  
    PseudoTable.TheseNodes.value('(./Value)[1]', 'varchar(MAX)') AS SubscriberList, 
    x.ReportPath 
     
    FROM (    
      SELECT  
        sub.Description AS Recipients, 
        CAST(sub.ExtensionSettings AS xml) AS Subscribers, 
        cat.[Path] AS ReportPath 
      FROM 
        dbo.Subscriptions sub 
        JOIN dbo.[Catalog] AS cat ON 
          sub.Report_OID = cat.ItemID 
    ) x 
      CROSS APPLY Subscribers.nodes('/ParameterValues/ParameterValue') AS PseudoTable(TheseNodes) 
  WHERE 
    PseudoTable.TheseNodes.value('(./Name)[1]', 'varchar(100)') = 'TO' 
  ) y 
  CROSS APPLY dbo.udftGetParsedValues(y.SubscriberList, ';') pv 
ORDER BY 
  Subscriber, 
  ReportPath