**ETL Developers Guide**

**Overview**

The ETL environment exist in a well-defined framework. That framework
will be spelled out in this document.

The environment is designed to accept data from many sources and combine
that data into a single dataflow that terminates in the data warehouse.
The data moves through in stages. Each stage will be described below.

![ETL Diagram](http://www.massstreet.net/documentation-images/etl-framework/ETLDiagram.png)
Figure 1. Warehouse load process.

Figure 1 represents the load process. Each stage is only loosely coupled
to the downstream stage. That is to say that if a particular piece
fails, it does not fail the entire process.

*Acquire*

Each ETL process that pulls data into the system is entirely independent
of any other process. Each dataset is pulled from its source system and
placed in a staging table.

*Consolidate*

All data that is collected in staging tables is moved to common model
tables together. The common model is a unified representation of all
data across systems.

*Integrate*

Moving data from consolidate to integrate is accomplished in the same
step as moving from acquire to consolidate. Integrate is where we move
the data from the common model into the warehouse tables.

*Deliver*

At this time, there are no OLAP cubes in the data architecture. Data is
delivered through various vectors. Most of those vectors pass through
the warehouse. A few bypass the warehouse and go straight to
de-normalized reporting tables.

***Relevant SQL02 Databases***

There are three databases used to deliver data.

**The data warehouse database** – It is important that you spend time
coming up with a good name for your data warehouse database. That
database will be used by the entire organization, so you need to come up
with an easy to remember and recognizable name. A good idea is to go to
the marketing department and get their input.

**ODS** – Operational data store. This is where all ETL functions take
place. It is where staging tables and the tables that support the common
model live. The stored procedures that perform ETL live here as well as
any views that support monitoring of the ETL processes. This database is
not accessible to business users.

**Reporting** – The database consists of de-normalized reporting tables
and views that are built from tables in the data warehouse. This
database allows rapid access to data without having to build complex
reports. Every model in production, is represented here as a
de-normalized view.

**ETL Order of Processes**

![ETL Flow](http://www.massstreet.net/documentation-images/etl-framework/ETLFlow.png)

Figure 2. Actual ETL Job Sequence

*Pull Data*

In general, all processes that acquire data from outside systems pull
and clean data in the same step.

*Load Warehouse*

The actual warehouse load processes is a combination of loading tables
and auditing processes that are used to check and make sure everything
loaded ok. As you build ETL processes, you will need to make sure to add
code that takes these processes into account. All dimensions are
processed first; then all fact tables are processed. Fact table loads
communicate back to staging to take note of what exactly was loaded to
the warehouse. The Finalize and Audit processes checks staging records
and reports discrepancies. **Every fact table load you build will need
code added to the usp\_MarkRecordsAsProcesses stored procedure.** Record
Row Counts is fully automated and documents how many records were loaded
to each fact table and compares that to historical loads to determine if
there is an anomaly in the load process.

*Load Reporting Tables*

This job is for those processes that load de-normalized reporting tables
that reside in the Reporting database only. The reporting tables that
live in ODS are only for data professionals and are loaded by different
processes.

*Monitor DW Table Loads*

Check Tables Loads will report on unusual record load amounts. Either
more than usual or none at all over a three day period are the trigger
events. In the final step, volumetric data is dumped into a
de-normalized reporting table for easy digest.

***Data Cleansing***

As with any ETL process, some of the data that comes in to the system
needs to be cleaned and standardized before it is loaded. Cleaning dates
is a common task and is outlined below. Date cleansing requires several
steps. It should be turned into a function, but the function has not
been written yet.

1.  Set empty dates to some arbitrary date.

2.  Set error dates to some arbitrary date.

3.  Convert remaining dates to YYYYMMDD format

***Loading Dimensions***

Figure three shows the generalized process for loading warehouse
dimensions. Most dimension load processes follow this design pattern.
The general process is explained as follows:

1.  Load the common model table from the warehouse.

2.  Merge existing data with new data.

3.  Determine which records are new and load those to the warehouse.
    This may also be a merge process if you are updating old records.

4.  Truncate the common model table.

5.  Load the common model table with key fields necessary to populate
    fact tables.

![Loading A Dimension](http://www.massstreet.net/documentation-images/etl-framework/DimensionLoadSequenceDiagram.png)

Figure 3. Dimension loading sequence diagram.

***Warehouse Load Commandments***

1.  **Thou shalt not put stand-alone codes in the database.** Always
    import code values along with their English explanations if
    possible.

2.  **Thou shalt not put data into generically named columns like Value1
    and Value2.** Every single column should have a clear and
    understandable name such that the meaning of the values in that
    column are entirely unambiguous even without having to consult the
    data dictionary.

3.  **Thou shalt not use 1 or 0 to represent Boolean values.** Use only
    “Yes” and “No”.

4.  **Thou shalt not place textual filter data into fact tables.**

5.  **Thou shalt not place dates into fact tables without an appropriate
    connection to a date dimension.**

6.  **Thou shalt not allow flags and acronyms into the database if
    possible.** Systems are usually filled with all kinds of flags and
    other acronyms that require expertise to decipher. Usually a front
    end will decode these flags for a user. These values do not belong
    in the data warehouse and need to be translated as part of the
    cleansing process.

***Conventions***

When developing ETL processes there are a number of conventions that
must be adhered to. Those conventions are largely based on common sense,
but they do change depending on what you are doing and where you are
doing it.

*Should I Use SSIS?*

Nine times out of ten, the answer to this question is going to be no. As
a general rule of thumb, only use SSIS to develop ETL processes if you
need to move an actual physical file or you have some reason to do
something that T-SQL cannot do like interact with the file system or OS
in some manner.

Most ETL processes move data from one database to another even if a flat
file was created in an intermediate process. In the case when you have
to cross servers, use a linked server.

*Conventions for SSIS*

There is a standard template package. Use that as the starting point for
any ETL that requires SSIS as lined out in the section above. Most of
the standards are already built in to that package. As you continue to
build out your process, keep the following in mind:

1.  Attempt to reduce the number of hard coded values to zero in your
    package. Place any configurations in the configuration table.

2.  Attempt to name variables following the example conventions in the
    package.

3.  The package has two parameters currently for moving files. Be sure
    to use them and connect them to the Global environment.

4.  Do not put non-arbitrary SQL statements in your packages. If your
    code is longer than three lines, turn it into a stored procedure and
    call that instead.

5.  Script task need to be developed using C\#.

*Conventions for T-SQL*

Every stored procedure needs to have a documentation block. The block
needs to include the name of the developer, the date the script was
created, a description of what the script does, and a log of the changes
to the script. All T-SQL scripts need to conform to the following
conventions:

1.  All scripts need to be left justified.

2.  All SQL reserve words need to be capitalized.

*Conventions for C\#*

Attempt to conform to Microsoft standards but this isn’t a hard rule as
there should not be a preponderance of C\# development in the
environment.

*Conventions for ODS*

Naming conventions in ODS appear to follow no pattern. This is because a
primary rule of naming objects in this database is that they should
conform to the source system. The conventions for ODS are as follows:

1.  NO table in ODS should use the dbo schema. Every table needs a
    schema that CLEARLY identifies the function of that table. If it is
    a staging table, the schema needs to identify the source system of
    the data. Some examples:

    a.  cm = common model

    b.  boa = Bank of America

    c.  ss = Smart Soft

2.  Staging table naming conventions **FOR COLUMNS** need to conform to
    the naming conventions of the source system. As a matter of fact,
    the column names should be identical to the source system.

3.  Staging table naming conventions **FOR TABLE NAMES** should follow
    the pattern of capitalizing every first word.

4.  Common model tables should be nearly identical to the warehouse
    tables they mimic but stripped of all indexes, keys, and most
    constraints.

5.  Every stage table needs to have the following columns regardless if
    you use them or not:

    a.  Unique dims. This column is used to help determine what records
        actually got transferred to the warehouse.

    b.  Error Record. Binary value to indicate that there is something
        wrong with that record.

    c.  Processed. Binary record used to identify records that were
        actually moved to the warehouse.

    d.  Run date. Timestamp of when the load was completed.

*Conventions for Reporting*

The reporting database does not follow any standard database naming
conventions. The reporting database is mostly views exposed to users. As
such, objects are named in a manner so that they are easily readable by
users.

***Wrapping Up***

This document attempts to address the major issues involved with
developing ETL against the data warehouse. Of course, we cannot address
every single possible issue you might run into. Fortunately, there is a
repository of examples and templates for future work. If you want to
know how to do something, check for any existing processes that do
something similar.
