--SQL Server 2008 and Above:

/* CREATE A NEW ROLE */
CREATE ROLE db_executor

/* GRANT EXECUTE TO THE ROLE */
GRANT EXECUTE TO db_executor

--For just a user (not a role):

USE [dB_Name]
GO
GRANT EXECUTE TO [user]
