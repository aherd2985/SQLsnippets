SELECT [Name],
[schema] = OBJECT_SCHEMA_NAME([object_id])
FROM sys.procedures
WHERE OBJECT_DEFINITION(OBJECT_ID) LIKE '%Employees%'
order by 1

