SELECT 
 t.name AS TableName,
 tr.name AS TriggerName  
FROM sys.triggers tr
INNER JOIN sys.tables t ON t.object_id = tr.parent_id
WHERE 
    tr.type = 'TR';