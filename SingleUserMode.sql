/*

Promotes will be done before promote after checking the databases have been backed up
Remote into Production Server and stop IIS
Put the database into Single User mode
Run the ALTER statements
Promote the Applications
Set the database to Multi-User mode
Start IIS

*/

USE master;
GO
ALTER DATABASE ][dB_Name]
SET SINGLE_USER
WITH ROLLBACK AFTER 60;
GO

USE [dB_Name]
GO

/*
    ALTER HERE
*/

GO

USE master
GO
ALTER DATABASE [dB_Name]
SET MULTI_USER;
GO