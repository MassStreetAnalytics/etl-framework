--Create Schema
CREATE SCHEMA SchemaName

GO

--Change collation to something case sensative
USE master;  

ALTER DATABASE [your database name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

ALTER DATABASE [your database name] COLLATE Latin1_General_CS_AS ;  
 

ALTER DATABASE [your database name] SET MULTI_USER WITH ROLLBACK IMMEDIATE


--Verify the collation setting.  
SELECT name, collation_name  
FROM sys.databases  
WHERE name = N'[your database name]';  
GO  

--Alter collation at the column level
ALTER TABLE [table name] ALTER COLUMN [column name] [your data type] COLLATE Latin1_General_CS_AS
