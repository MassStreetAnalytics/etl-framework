**Python Script Guide**

There are four high performance Python scripts that can be used as guides for ETL work. Each script follows the design pattern of the ETL Framework. You can mix and match the scripts for the desired use case.

**Script Set Up**

The following configurations are necessary for the scripts to work with a minimum of alteration.

1.  Create a DSN called ETL and point it to ODS.

2.  On the C drive, create a folder called opt. Opt is where you'll organize your scripts by application.

3.  Each ETL process should have it's own folder in opt.

4.  The scripts are currently designed for SQL Server and use BULK INSERT. For BULK INSERT to work, the file needs to be a pipe delimited text file.

5.  You cannot bulk insert into a stage table directly. You have to bulk load a view instead. Create a view for each staging table with only the columns that you are inserting.