SELECT
      ObjectType = o.type_desc
    , ObjectName = o.name
    , GrantStatement = N'DENY VIEW DEFINITION ON ' + QUOTENAME(s.name) + '.' + QUOTENAME(o.name) + N' TO [User];'
	, o.type
FROM sys.objects o
inner join sys.schemas s on o.schema_id = s.schema_id
WHERE o.type = N'U'
-- o.type = N'P'
 --   OR o.type = N'V'
ORDER BY o.type
    , o.name;
