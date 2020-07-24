USE master;  

ALTER DATABASE [dB Name]    
   SET RECOVERY FULL;  


-- Back up the full database to the container that you created in section 1  
BACKUP DATABASE [dB Name]   
   TO URL = 'https://[AZURE].blob.core.windows.net/[AZURE CONTAINER]/[dB Name].bak' 