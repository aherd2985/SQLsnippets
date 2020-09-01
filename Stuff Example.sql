


SELECT 
 STUFF((
            SELECT '; ' + SomeColumn
			FROM SomeTable B
			WHERE A.[FK_Column] = B.[PK_Column]
            FOR XML PATH('')
            ), 1, 2, '') AS StuffExample

FROM [someTable] A




SELECT STRING_AGG ( ISNULL(FirstName,'N/A'), ',') AS csv 
FROM People;