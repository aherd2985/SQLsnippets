

SELECT DISTINCT s.name Schema_Name,
       o.name AS Object_Name,
       o.type_desc
  FROM sys.sql_modules m
       INNER JOIN
       sys.objects o
         ON m.object_id = o.object_id
		 inner join
		 sys.schemas s on o.schema_id = s.schema_id
 WHERE m.definition Like '%SearchText%';