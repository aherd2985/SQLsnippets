DECLARE @procedureName varchar(75);

SELECT name, create_date, modify_date 
FROM sys.objects
WHERE type = 'P'
and name = @objectName
ORDER BY modify_date DESC