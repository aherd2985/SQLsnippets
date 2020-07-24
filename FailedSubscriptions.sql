USE ReportServer
GO

SELECT C.Name, S.LastRunTime, S.LastStatus, S.Description, C.Path

FROM [dbo].[Subscriptions] AS S LEFT JOIN 
	 [dbo].[Catalog]       AS C   ON C.ItemID = S.Report_OID

WHERE LEFT (S.LastStatus, 12) != 'Mail sent to'
AND LEFT (S.LastStatus, 12) != 'New Subscrip'
AND LEFT (S.LastStatus, 4) != 'Done'

ORDER BY S.LastRunTime DESC