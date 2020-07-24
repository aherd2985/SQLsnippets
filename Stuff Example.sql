


SELECT 
 STUFF((
            SELECT '; ' + SomeColumn
			from Calendar B
			WHERE A.[FK Column] = B.[PK Column]
            FOR XML PATH('')
            ), 1, 2, '') AS StuffExample

FROM [someTable] A




SELECT STRING_AGG ( ISNULL(Employee_FName,'N/A'), ',') AS csv 
FROM Employees;