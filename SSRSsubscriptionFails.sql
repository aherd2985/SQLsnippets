SELECT
   	Cat.[Name],
   	Rep.[ScheduleId],
   	Own.UserName,
   	ISNULL(REPLACE(Sub.[Description],'send e-mail to ',''),' ') AS Recipients,
   	Sub.[LastStatus],
   	Cat.[Path],
   	Sub.[LastRunTime]
FROM
   	dbo.[Subscriptions] Sub with (NOLOCK)
INNER JOIN
   	dbo.[Catalog] Cat with (NOLOCK) on Sub.[Report_OID] = Cat.[ItemID]
INNER JOIN
   	dbo.[ReportSchedule] Rep with (NOLOCK) ON (cat.[ItemID] = Rep.[ReportID] and Sub.[SubscriptionID] =Rep.[SubscriptionID])
INNER JOIN
   	dbo.[Users] Own with (NOLOCK) on Sub.[OwnerID] = Own.[UserID]
WHERE
Sub.[LastStatus] NOT LIKE '%was written%' --File Share subscription
AND Sub.[LastStatus] NOT LIKE '%pending%' --Subscription in progress. No result yet
AND Sub.[LastStatus] NOT LIKE '%mail sent%' --Mail sent successfully.
AND Sub.[LastStatus] NOT LIKE '%New Subscription%' --New Sub. Not been executed yet
AND Sub.[LastStatus] NOT LIKE '%been saved%' --File Share subscription
AND Sub.[LastStatus] NOT LIKE '% 0 errors.' --Data Driven subscription
AND Sub.[LastStatus] NOT LIKE '%succeeded%' --Success! Used in cache refreshes
AND Sub.[LastStatus] NOT LIKE '%successfully saved%' --File Share subscription
AND Sub.[LastStatus] NOT LIKE '%New Cache%' --New cache refresh plan
-- AND Sub.[LastRunTime] > GETDATE()-1

order by 7
 
-- If any failed subscriptions found, proceed to build HTML & send mail.



--          \\kmspws001\d$\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Log

--          \\kmspws001\C$\Program Files\Microsoft SQL Server Reporting Services\SSRS\LogFiles