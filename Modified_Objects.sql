DECLARE @filename VARCHAR(255) 
SELECT @FileName = SUBSTRING(path, 0, LEN(path)-CHARINDEX('\', REVERSE(path))+1) + '\Log.trc'  
FROM sys.traces   
WHERE is_default = 1;  

SELECT gt.HostName, 
       gt.ApplicationName, 
       gt.NTUserName, 
       gt.NTDomainName, 
       gt.LoginName, 
       gt.SPID, 
       gt.EventClass, 
       te.Name AS EventName,
       gt.EventSubClass,      
       gt.TEXTData, 
       gt.StartTime, 
       gt.EndTime, 
       gt.ObjectName, 
       gt.DatabaseName, 
       gt.FileName, 
       gt.IsSystem
FROM [fn_trace_gettable](@filename, DEFAULT) gt 
JOIN sys.trace_events te ON gt.EventClass = te.trace_event_id 
WHERE EventClass in (164) --AND gt.EventSubClass = 2
ORDER BY StartTime DESC; 