SELECT A.*,
LAG(SA_Employee_ID,1) OVER (
PARTITION BY TOR_ID
		ORDER BY TOSA_ID
	) previousApprover,
LEAD(SA_Employee_ID,1) OVER (
PARTITION BY TOR_ID
		ORDER BY TOSA_ID
	) previousApprover
FROM TimeOffSupervisorApproval A