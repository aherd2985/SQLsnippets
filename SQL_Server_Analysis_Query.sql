SELECT TOP 100
    qs.total_elapsed_time / qs.execution_count / 1000000.0 AS average_seconds,
    qs.total_elapsed_time / 1000000.0 AS total_seconds,
    qs.execution_count,
    SUBSTRING (qt.text,qs.statement_start_offset/2, 
         (CASE WHEN qs.statement_end_offset = -1 
            THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2 
          ELSE qs.statement_end_offset END - qs.statement_start_offset)/2) AS individual_query,
    o.name AS object_name,
    DB_NAME(qt.dbid) AS database_name
  FROM sys.dm_exec_query_stats qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
    LEFT OUTER JOIN sys.objects o ON qt.objectid = o.object_id
WHERE qt.dbid = DB_ID()
  ORDER BY average_seconds DESC;
  SELECT TOP 100
    (total_logical_reads + total_logical_writes) / qs.execution_count AS average_IO,
    (total_logical_reads + total_logical_writes) AS total_IO,
    qs.execution_count AS execution_count,
    SUBSTRING (qt.text,qs.statement_start_offset/2, 
         (CASE WHEN qs.statement_end_offset = -1 
            THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2 
          ELSE qs.statement_end_offset END - qs.statement_start_offset)/2) AS indivudual_query,
    o.name AS object_name,
    DB_NAME(qt.dbid) AS database_name
  FROM sys.dm_exec_query_stats qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
    LEFT OUTER JOIN sys.objects o ON qt.objectid = o.object_id
WHERE qt.dbid = DB_ID()
  ORDER BY average_IO DESC;
  SELECT  st.text,
        qp.query_plan,
        qs.*
FROM    (
    SELECT  TOP 50 *
    FROM    sys.dm_exec_query_stats
    ORDER BY total_worker_time DESC
) AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE qs.max_worker_time > 300
      OR qs.max_elapsed_time > 300


	  order by qs.max_elapsed_time desc 

	  --max_worker_time for cpu time... may be highly parallel queries
	  ;
	  --variables to hold each 'iteration'  
DECLARE @query varchar(100)  
DECLARE @dbname sysname  
DECLARE @vlfs int  
  
--table variable used to 'loop' over databases  
DECLARE @databases table (dbname sysname)  
INSERT INTO @databases  
--only choose online databases  
SELECT name FROM sys.databases WHERE state = 0  
  
--table variable to hold results  
DECLARE @vlfcounts table  
    (dbname sysname,  
    vlfcount int)  
  
 
 
--table variable to capture DBCC loginfo output  
--changes in the output of DBCC loginfo from SQL2012 mean we have to determine the version 
 
DECLARE @MajorVersion tinyint  
SET @MajorVersion = LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))-1) 
 
IF @MajorVersion < 11 -- pre-SQL2012 
BEGIN 
    declare @dbccloginfo table  
    (  
        fileid smallint,  
        file_size bigint,  
        start_offset bigint,  
        fseqno int,  
        [status] tinyint,  
        parity tinyint,  
        create_lsn numeric(25,0)  
    )  
  
    WHILE EXISTS (SELECT TOP 1 dbname FROM @databases)  
    BEGIN  
  
        SET @dbname = (SELECT TOP 1 dbname FROM @databases)  
        SET @query = 'dbcc loginfo (' + '''' + @dbname + ''') '  
  
        INSERT INTO @dbccloginfo  
        EXEC (@query)  
  
        SET @vlfs = @@rowcount  
  
        INSERT @vlfcounts  
        VALUES(@dbname, @vlfs)  
  
        DELETE FROM @databases WHERE dbname = @dbname  
  
    END --while 
END 
ELSE 
BEGIN 
    DECLARE @dbccloginfo2012 table  
    (  
        RecoveryUnitId int, 
        fileid smallint,  
        file_size bigint,  
        start_offset bigint,  
        fseqno int,  
        [status] tinyint,  
        parity tinyint,  
        create_lsn numeric(25,0)  
    )  
  
    WHILE EXISTS (SELECT TOP 1 dbname FROM @databases)  
    BEGIN  
  
        SET @dbname = (SELECT TOP 1 dbname FROM @databases)  
        SET @query = 'dbcc loginfo (' + '''' + @dbname + ''') '  
  
        INSERT INTO @dbccloginfo2012  
        EXEC (@query)  
  
        SET @vlfs = @@rowcount  
  
        INSERT @vlfcounts  
        VALUES (@dbname, @vlfs)  
  
        DELETE FROM @databases WHERE dbname = @dbname  
  
    END --while 
END 
  
--output the full list  
SELECT dbname, vlfcount  
FROM @vlfcounts  
ORDER BY dbname
;
