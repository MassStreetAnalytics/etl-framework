# Using The Built-In Stored Procs

There are four stored procedures that you can use to trouble shoot your SSIS packages and one that can be used to monitor the system that is agnostic to the method by which the load happens.

| Procedure Name | Parameter | Parameter Data Type | Description |
| :--- | :--- | :--- | :--- |
| usp\_PackageRunTime | @PackageName | VARCHAR\(MAX\) | Pass in the name of the package. Tells you how long an individual package ran. |
| usp\_ErrorLogByBatch | @BatchID | INT | Pass in the batch ID. Tells you all the errors in a particular batch. |
| usp\_BatchRunTime | @BatchID | INT | Pass in the batch ID. Tells you how long a particular batch ran. |
| usp\_ErrorLogByPackage | @PackageName | VARCHAR\(MAX\) | Pass in the name of the package. Tells you errors for a particular package. |
| usp\_DisplayTablesNotLoading | none | none | Displays tables that are not loading. |



