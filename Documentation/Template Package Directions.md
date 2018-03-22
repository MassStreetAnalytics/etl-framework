**Standard SSIS ETL Development Package**

To ease development a standard template has been built so developers can focus
on business logic and not worry about the details of logging. Additionally, the
standard package allows ease of promotion from development to production without
significant changes to the package itself.

**Working with the sample package**

**Package Properties**

When you start a new project follow these steps:

1.  Create a new solution and add the existing template AgspringETLTemplate.dtsx

2.  In package properties click ID and select generate new ID.

3.  Change the CreationDate to today’s date.

4.  Change the CreatorComputerName to your computer.

5.  Change the CreatorName to your name.

6.  Fill in the VersionComments, VersionMajor, and VersionMinor.

<center>
![Change Package ID](http://www.massstreet.net/documentation-images/etl-framework/ChangePackageID.png)<br>
Figure 1. Change package ID.
</center>

**Package Variables**

If you have a variable that you want to track, set that variable’s raise change
event property to true.

It is important that you do NOT delete any of the existing variables with the
exception of intVariable2 and strVariable1. Those variables are place holders
for package configurations. If you have configurations, you can replace them. If
you do not, they need to stay or in the alternative, you can delete the Import
Configurations task which is not advised.

**Task**

You can delete the SEQ Package Logic sequence container BUT your control flow
MUST begin and end with SQL LogPackageStart and SQL LogPackageEnd respectively.

**Querying The Logging Tables**

There are four stored procedures that you can use to trouble shoot your ETL
solution.


| Procedure Name | Parameter | Parameter Data Type | Description|
|--------------------|---------------|-------------------------|--------------------------------------------------------------------------------|
| PackageRunTime     |  @PackageName | VARCHAR(MAX)            | Pass in the name of the package. Tells you how long an individual package ran. |
| ErrorLogByBatch    |  @BatchID     | INT                     | Pass in the batch ID. Tells you all the errors in a particular batch.          |
| BatchRunTime       |  @BatchID     | INT                     | Pass in the batch ID. Tells you how long a particular batch ran.               |
| ErrorLogByPackage  |  @PackageName | VARCHAR(MAX)            | Pass in the name of the package. Tells you errors for a particular package.    |

Developers are encouraged to write their own procedures for their own
troubleshooting needs. The ERD for the logging tables can be found in the file
ETL Management Framework Logging Database ERD.pdf

**Creating new configuration settings**

Developers are encouraged to make packages as flexible as possible by using
package configurations. Package configuration creation is explained in the
script Configuration Insert Sample Script.sql found in the SQL Scripts\\Helper
Scripts Directory.
