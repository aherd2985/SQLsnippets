DECLARE @rptBeginDt DateTime = DateAdd(yy, -2, GetDate());

SELECT [Customer_ID],
[PRI2PTO],
[PTO2PFI],
[PRI2HRI],
[HRI2HFI],
[PRI2ERI],
[ERI2ETO]

FROM (
SELECT B.Customer_ID
, DATEDIFF(dd, A.Click_Bill_Date, C.Click_Bill_Date) deltaDD
, CASE WHEN A.Service_Type = 'PLUMBING' AND A.Phase_Code = 'RI'
	AND C.Service_Type = 'PLUMBING' AND C.Phase_Code = 'TO' THEN 'PRI2PTO'
	WHEN A.Service_Type = 'PLUMBING' AND A.Phase_Code = 'TO'
	AND C.Service_Type = 'PLUMBING' AND C.Phase_Code = 'FIN' THEN 'PTO2PFI'
	WHEN A.Service_Type = 'PLUMBING' AND A.Phase_Code = 'RI'
	AND C.Service_Type = 'HVAC' AND C.Phase_Code = 'RI' THEN 'PRI2HRI'
	WHEN A.Service_Type = 'HVAC' AND A.Phase_Code = 'RI'
	AND C.Service_Type = 'HVAC' AND C.Phase_Code = 'FIN' THEN 'HRI2HFI'
	WHEN A.Service_Type = 'PLUMBING' AND A.Phase_Code = 'RI'
	AND C.Service_Type = 'ELECTRICAL' AND C.Phase_Code = 'RI' THEN 'PRI2ERI'
	WHEN A.Service_Type = 'ELECTRICAL' AND A.Phase_Code = 'RI'
	AND C.Service_Type = 'ELECTRICAL' AND C.Phase_Code = 'TO' THEN 'ERI2ETO'
	END catNames

FROM BI.JC_S_P_Stats A JOIN
	 dbo.Job_Information B ON A.Job_Code = B.Job_Code JOIN
	 BI.JC_S_P_Stats C ON A.Job_Code = C.Job_Code JOIN
	 Subdivisions D ON B.Subdivision_ID = D.Subdivision_ID JOIN
	 Divisions E ON D.Division_ID = E.Division_ID

WHERE ( B.Crawl_Space <> 'C' OR B.Crawl_Space IS NULL )
AND A.Click_Bill_Date > @rptBeginDt
AND E.Company_Division_ID = 2
	AND A.Click_Bill_Date IS NOT NULL AND C.Click_Bill_Date IS NOT NULL
	AND A.Click_Bill_Date < C.Click_Bill_Date

	AND ( (A.Service_Type = 'PLUMBING' AND A.Phase_Code = 'RI'
	AND C.Service_Type = 'PLUMBING' AND C.Phase_Code = 'TO')
	OR (A.Service_Type = 'PLUMBING' AND A.Phase_Code = 'TO'
	AND C.Service_Type = 'PLUMBING' AND C.Phase_Code = 'FIN')
	OR (A.Service_Type = 'PLUMBING' AND A.Phase_Code = 'RI'
	AND C.Service_Type = 'HVAC' AND C.Phase_Code = 'RI')
	OR (A.Service_Type = 'HVAC' AND A.Phase_Code = 'RI'
	AND C.Service_Type = 'HVAC' AND C.Phase_Code = 'FIN')
	OR (A.Service_Type = 'PLUMBING' AND A.Phase_Code = 'RI'
	AND C.Service_Type = 'ELECTRICAL' AND C.Phase_Code = 'RI')
	OR (A.Service_Type = 'ELECTRICAL' AND A.Phase_Code = 'RI'
	AND C.Service_Type = 'ELECTRICAL' AND C.Phase_Code = 'TO')
	)
) Q
PIVOT ( AVG(deltaDD)
FOR catNames IN (
[PRI2PTO],
[PTO2PFI],
[PRI2HRI],
[HRI2HFI],
[PRI2ERI],
[ERI2ETO]
)
) AS pivot_table

ORDER BY 1