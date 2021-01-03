# ETL Environment Databases

There are three databases used to deliver data.

**The data warehouse database** – It is important that you spend time coming up with a good name for your data warehouse database. That database will be used by the entire organization, so you need to come up with an easy to remember and recognizable name. A good idea is to go to the marketing department and get their input.

**Pro Tip: Do NOT name your data warehouse EDW.**

**ODS** – Operational data store. This is where all ETL functions take place. It is where staging tables and the tables that support the common model live. The stored procedures that perform ETL live here as well as any views that support monitoring of the ETL processes. This database is not accessible to business users.

This is the place where you make the sausage. No muggles are allowed in ODS. It is STRICTLY for data professionals and anything that goes in there should in no way shape or form be something that non-IT users will access.

**Reporting** – This is one of the many windows in the data warehouse. The database consists of de-normalized reporting tables and views that are built from tables in the data warehouse. This database allows rapid access to data without having to build complex reports. Every model in production, is represented here as a de-normalized view.

**SSISManagement -** SSISManagment is the database that holds the logging information from the execution of SSIS packages. This database is FAR more useful and user friendly than the execution information provided by SQL Server.

