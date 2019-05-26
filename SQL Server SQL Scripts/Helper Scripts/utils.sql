--View information about current users, sessions, and processes
EXEC sp_who2

--see how long it will take for
--a rollback to complete
KILL [SPID] WITH STATUSONLY
--Example
KILL 59 WITH STATUSONLY

--Kill open transactions
DBCC opentran
KILL [SPID]
--Example
KILL 59

GO
--Create Schema
CREATE SCHEMA SchemaName

GO

--Change collation to something case sensative
USE master;  

ALTER DATABASE [your database name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

ALTER DATABASE [your database name] COLLATE SQL_Latin1_General_CP1_CS_AS ;  
 

ALTER DATABASE [your database name] SET MULTI_USER WITH ROLLBACK IMMEDIATE


--Verify the collation setting.  
SELECT name, collation_name  
FROM sys.databases  
WHERE name = N'[your database name]';  
GO  

--Alter collation at the column level
ALTER TABLE [table name] ALTER COLUMN [column name] [your data type] COLLATE SQL_Latin1_General_CP1_CS_AS
