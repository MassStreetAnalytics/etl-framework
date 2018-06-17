**ETL Environment Set Up**

This process needs to be set up on every server that is involved in your ELT architecture.

**Create Databases**

There are three databases that need to be created. 

**Caution: The default collation on SQL server is to create databases that are NOT case sensitive. When you create a database, make sure to chose a collation that is case sensitive like Latin1_General_CS_AS. If you do not remember to do this, all is not lost. If you have yet to create any objects, it is possible to change the collation. Look in the helper scripts folder for the utils.sql file for a script on how to do that. If you HAVE already created some database objects, and those objects depend on the collation, you will need to manage the collocation on a per column basis.**

EDW - You warehouse database. It should NOT be named EDW. It should be named something creative that everybody throughout the entire organization will remember and recognize. A good idea is to ask the Marketing department to name it.

ODS - Operational Data Store. This is the place where you make the sausage. No muggles are allowed in ODS. It is STRICTLY for data professionals and anything that goes in there should in no way shape or form be something that non-IT users will access.

Reporting - This is one of the many windows in the data warehouse. It is a place of pre-aggregated datasets and de-normalized versions of models.

**Create the SSIS Catalogue**

If the SSIS catalog hasn't been created, instructions on how to do that can be found [here](https://technet.microsoft.com/en-us/library/gg471509%28v=sql.110%29.aspx?f=255&MSPPError=-2147217396 "SSIS Catalog").       

**Create File I/O directory structure**

When you have to process import files or output files back to users, there is a
directory structure for you to do that. The structure looks like:

[Drive letter]:\\InterfaceAndExtractFiles\\[Business Unit]\\[ETL Process
Name]\\[In \| Out]

You will need to replicate this structure by creating the root
InterfaceAndExtractFiles directory.

ETL process names should not be cryptic. They should be as descriptive as
possible. When you create a new project in SSDT your project name should match
the name of the directory.

Inside of each process directory you create should be an In and Out folder. The
In folder should be where you import files from other processes. The Out folder
is the result of any processing done in ETL processes where the output is a flat
file. You can create whatever file structure necessary to facilitate your
process inside of the In/Out folders as long as the base structure mentioned
above exist.

**Create Global Environment in the Integration Services Catalog**

Packages are deployed to the SSIS catalogue using the project deployment model.
There are some common variables used across all packages. These variables are
stored in an environment named Global. The name value pairs of those variables
are as follows:

Variable name: FileExchangeRootDirectory

Value: \\\\[Server Name]\\FileExchange\\

Variable name: RootFileDirectory

Value: [Drive Letter]:\\InterfaceAndExtractFiles\\

***Create SQL Server Aliases***

Create an alias with the following settings:

Name: [Data Warehouse Name]

IP: [Server Name]

This setting makes the assumption that server names are relatively set in stone.
If server names change, then it is preferable to use actual IP addresses. Create
both 32 and 64bit aliases and make sure TCP/IP is enabled.

***Create Server Objects***

Create a database called SSISManagement and run the following scripts in order. These scripts can be found in the SQLScripts/Framework Objects Folder

1.  Create ETL Framework Tables.sql

2.  CREATE TABLE TableLoadReport.sql

3.  Create ETL Framework Stored Procs.sql

4.  CREATE PROC ErrorLogByPackage.sql

5.  CREATE PROC BatchRunTime.sql

6.  CREATE PROC ErrorLogByBatch.sql

7.  CREATE PROC GetVariableValues.sql

8.  CREATE PROC PackageRunTime.sql

9.  CREATE TABLE SSISConfigurations.sql

10. CREATE VIEW v_RowCountLog.sql

11. CREATE VIEW v_ShowAdverseTableLoads.sql

12. CREATE VIEW v_SSISErrorLogByPackage.sql

13. CREATE VIEW v_SSISPackageBatchRunTime.sql

14. CREATE VIEW v_SSISPackageRunTime.sql

15. CREATE FUNCTION udf_CleanDates.sql
