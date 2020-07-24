USE KP
GO


ALTER TRIGGER [triggerName] on [tableName]
AFTER UPDATE, INSERT
AS
BEGIN

	SET NOCOUNT ON;

	IF EXISTS(SELECT * FROM INSERTED)
    BEGIN
		DECLARE @emailInstances TABLE
		(
			RowNumber int,
			User  nVarChar(256)
		)

		INSERT INTO @emailInstances
			SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)), A.UserName

			FROM INSERTED C
					LEFT JOIN
				 dbo.aspnet_Users A ON C.UserId = A.UserId

		DECLARE @Rpt_Int int;
		SELECT @Rpt_Int = MAX(RowNumber) FROM @emailInstances;

		WHILE @Rpt_Int >= 1
		BEGIN

		DECLARE @HTML  NVARCHAR(MAX);  

		SET @HTML =  
			N'<H1>' +  @User + ' was inserted.</H1>' 
			;  

		EXEC msdb.dbo.sp_send_dbmail 
			@profile_name = 'Admin',
			@recipients='somebody@email.com',  
			@subject = 'Something Inseted',  
			@body = @HTML,  
			@body_format = 'HTML';  

		SELECT @Rpt_Int = MAX(RowNumber) FROM @emailInstances WHERE RowNumber < @Rpt_Int;
		END
	END

END
GO