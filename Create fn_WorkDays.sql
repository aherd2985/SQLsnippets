USE [dB NAME]
GO
IF EXISTS
(
    SELECT *
    FROM dbo.SYSOBJECTS
    WHERE ID = OBJECT_ID(N'[dbo].[fn_NbrWorkDays]')
    AND XType IN (N'FN', N'IF', N'TF')
)

DROP FUNCTION [dbo].[fn_NbrWorkDays]
GO
 CREATE FUNCTION [dbo].[fn_NbrWorkDays]
--Presets
(
    @StartDate DATE,
    @EndDate   DATE = NULL --@EndDate replaced by Curent Date when DEFAULTed
)

--Define the output data type.
RETURNS INT

AS
--Calculate the RETURN of the function.
BEGIN

    --If the Start Date is null, return a NULL and exit.
    IF @StartDate IS NULL
        RETURN NULL

    --If the End Date is null, populate with Current Date value so will have two dates (required by DATEDIFF below).
    IF @EndDate IS NULL
        SELECT @EndDate = GetDate()

    RETURN (
			SELECT DATEDIFF(Day, @StartDate, @EndDate) -- Total Days
			  - (DATEDIFF(Day, 0, @EndDate)/7 - DATEDIFF(Day, 0, @StartDate)/7) -- subtract Sundays
			  - (DATEDIFF(Day, -1, @EndDate)/7 - DATEDIFF(Day, -1, @StartDate)/7) -- subtract Saturdays
			  - (Select Count(*) from [KP].[dbo].[Special_Dates] where  [ObservedDate] between @StartDate and @EndDate ) -- subtract Holidays
			  + (CASE WHEN DATEPART(dw, @EndDate) IN (2,3,4,5,6) THEN 1 ELSE 0 END ) -- add last day if weekday
        )
    END  
GO