SELECT
c.Name AS ReportName,
'Next Run Date' = CASE next_run_date
WHEN 0 THEN null
ELSE
substring(convert(varchar(15),next_run_date),1,4) + '/' +
substring(convert(varchar(15),next_run_date),5,2) + '/' +
substring(convert(varchar(15),next_run_date),7,2)
END,
'Next Run Time' = isnull(CASE len(next_run_time)
WHEN 3 THEN cast('00:0'
+ Left(right(next_run_time,3),1)
+':' + right(next_run_time,2) as char (8))
WHEN 4 THEN cast('00:'
+ Left(right(next_run_time,4),2)
+':' + right(next_run_time,2) as char (8))
WHEN 5 THEN cast('0' + Left(right(next_run_time,5),1)
+':' + Left(right(next_run_time,4),2)
+':' + right(next_run_time,2) as char (8))
WHEN 6 THEN cast(Left(right(next_run_time,6),2)
+':' + Left(right(next_run_time,4),2)
+':' + right(next_run_time,2) as char (8))
END,'NA'),
Convert(XML,[ExtensionSettings]).value('(//ParameterValue/Value[../Name="TO"])[1]','nvarchar(50)') as [To]
,Convert(XML,[ExtensionSettings]).value('(//ParameterValue/Value[../Name="CC"])[1]','nvarchar(50)') as [CC]
,Convert(XML,[ExtensionSettings]).value('(//ParameterValue/Value[../Name="RenderFormat"])[1]','nvarchar(50)') as [Render Format]
,Convert(XML,[ExtensionSettings]).value('(//ParameterValue/Value[../Name="Subject"])[1]','nvarchar(50)') as [Subject]
,[LastStatus]
,[EventType]
,[LastRunTime]
,[DeliveryExtension]
FROM 
 dbo.[Catalog] c
INNER JOIN dbo.[Subscriptions] S ON c.ItemID = S.Report_OID
INNER JOIN dbo.ReportSchedule R ON S.SubscriptionID = R.SubscriptionID
INNER JOIN msdb.dbo.sysjobs J ON Convert(nvarchar(128),R.ScheduleID) = J.name
INNER JOIN msdb.dbo.sysjobschedules JS ON J.job_id = JS.job_id
order by LastRunTime desc