--Kill open transactions
DBCC opentran
KILL 64

--Create Schema
CREATE SCHEMA SchemaName


--Change collation
SELECT name, collation_name 
FROM sys.databases
WHERE name = 'ODS'


ALTER DATABASE ODS SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
ALTER DATABASE ODS -- put your database name here
COLLATE Latin1_General_CS_AS
ALTER DATABASE ODS SET MULTI_USER; 

SELECT * FROM ::fn_helpcollations()
SQL_Latin1_General_CP1_CI_AS

