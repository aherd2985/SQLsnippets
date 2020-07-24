CREATE CREDENTIAL [https://{AZURE STORAGE}.blob.core.windows.net/{AZURE CONTAINER}] WITH IDENTITY='Shared Access Signature', SECRET='{SECRET}'




-- Restore [dB NAME] from URL to SQL Server instance using Azure blob storage for database files  
RESTORE DATABASE KP   
   FROM URL = 'https://{AZURE STORAGE}.blob.core.windows.net/sassycontainer/[dB NAME].bak'   
   WITH  
      MOVE '[dB NAME]_data' to 'https://{AZURE STORAGE}.blob.core.windows.net/sassycontainer/[dB NAME].mdf'  
     ,MOVE '[dB NAME]_log' to 'https://{AZURE STORAGE}.blob.core.windows.net/sassycontainer/[dB NAME].ldf'  
, REPLACE  
