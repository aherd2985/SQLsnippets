 SELECT name AS [File Name],
       physical_name AS [Physical Name],
       size/128.0 AS [Total Size in MB],
       size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS [Available Space In MB],
       [growth], [file_id]
       FROM sys.database_files
       WHERE type_desc = 'LOG'



SELECT
percent_complete,
start_time,
status,
command,
estimated_completion_time,
cpu_time,
total_elapsed_time
FROM
sys.dm_exec_requests
WHERE
command = 'BACKUP LOG'