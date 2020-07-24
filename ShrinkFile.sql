exec sp_helpfile;
GO
 
/* Shrink the log file */
/* The file size is stated in megabytes*/
DBCC SHRINKFILE ([dB Name]_log, 2048);
GO