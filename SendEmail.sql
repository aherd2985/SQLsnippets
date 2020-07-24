
DECLARE @Employee_Name NVARCHAR(MAX)
, @HTML  NVARCHAR(MAX) ;  

SET @HTML =  
    N'<H1>'
	 + @Employee_Name
	 + '</H1>, <br />Please click <a href=''https://google.com''>here</a> to go to Google!' 
	;  

EXEC msdb.dbo.sp_send_dbmail @recipients=@Email_Rpt,  
    @subject = 'Test Email',  
    @body = @HTML,  
    @body_format = 'HTML' ;  

