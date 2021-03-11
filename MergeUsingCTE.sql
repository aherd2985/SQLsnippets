WITH SourceTableCTE AS
(
    SELECT * FROM SourceTable
)
MERGE  
 TargetTable AS target
USING SourceTableCTE AS source  
ON (target.PKID = source.PKID)
WHEN MATCHED THEN     
    UPDATE SET target.ColumnA = source.ColumnA
WHEN NOT MATCHED THEN
    INSERT (ColumnA) VALUES (Source.ColumnA);
