DECLARE @name VARCHAR(50) -- database name 

DECLARE db_cursor CURSOR FOR 
SELECT name 
FROM MASTER.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb') 

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN  
      PRINT @name 

      FETCH NEXT FROM db_cursor INTO @name 
END

CLOSE db_cursor;

DEALLOCATE db_cursor;
