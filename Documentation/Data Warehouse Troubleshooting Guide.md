**Data Warehouse Troubleshooting Guide**

This guide assumes working knowledge of SQL Server Agent. It gives a detailed
explanation of the load and the proper way to fix issues when they arise. It is
advisable to keep a file of EXEC statements of every proc that runs the load.
This document should be used in conjunction with the ETL Developers Guide.

**Data Flow**

Data flows into the data warehouse though ODS and ODS only. ODS is the front
door to the system and this should always remain true to ensure ease of system
maintenance.

Agent jobs that manage the warehouse load are named in order of execution. This
pattern should also never drift far from its initial state. You can insert extra
items, but the ordinal relationships need to be set in stone. As an example,
fact tables should never process before dimension tables.

All the steps in the warehouse load are loosely coupled meaning you can run all
the steps independently with the proviso that that prior step ran at some point.
In other words, if one step blows up, you do not have to go back and run the
entire process. That said, once you get familiar with the process, the fastest
way to fix things usually is to blow away staging, re-pull specific data, and
rerun everything.

Data flows into the data warehouse in the following manner. In all cases, you
are only processing data flagged as cleaned, unprocessed, and error free.

1.  Data is pulled from source systems into a specific staging table in ODS.

2.  The data is cleaned.

3.  Data from Production dimensions are pulled into the common model in ODS.

4.  Existing dimensional data is compared to incoming dimensional data and
    actions are taken based upon the rules surrounding a particular dimension
    and loaded into Production.

5.  Dimensional fields used to identify records are flushed back to ODS for
    matching with facts.

6.  Fact records are matched up with their dimensions and loaded into the common
    model.

7.  The common model is flushed to production.

**Generalized Troubleshooting Steps**

Any troubleshooting process is part procedural and part detective work. Reading
the ETL Developers guide and making sure you have a good understanding of the
system will help you fix problems faster than any step by step process. That
being said, the following is a good heuristic for finding problems in the
warehouse ETL process.

1. Open the step that blew up and determine what the error was.

2. If it was related to a proc, open the sub step and pull out the EXEC
statements and run them by hand one by one. The trouble proc will blow up. (This
is where your .sql file of EXEC statements of every proc comes in handy.)

3. Determine and fix the error. (This is where you pull out your Sherlock Holmes
pipe and go to work. There is no formulaic way to do this.)

4. Re-run the step that blew up.

The process is designed so that any problems with loading dimensions brings the
process to a grinding halt. Loading dimensions is a necessary sufficient
condition for loading facts. Facts, on the other hand, can blow up and the rest
of the fact tables will be allowed to continue processing.

The processing of dimensions should be really fast so any long run time on
dimension processing should be considered a source of suspicion. Below are the
top causes for warehouse load problems.

1.  Duplicate records in staging as a result of bad logic in the source pull.
    The SQL MERGE statement cannot process duplicate records from a single
    source.

2.  Data truncation. String data type sizes are determined by profiling existing
    data and then doubling the existing maximum character value. This does not
    always work over time. You will have to systematically determine which
    column is causing the problem.

3.  Pulling source data again before processing the prior run. This will result
    in a duplicate record error.

**Audit Column Definitions**

Every table has a standardized set of audit columns that are used for data
provenance. The definitions of these columns and their uses are below.

**Staging Tables**

ETLKey – this is a unique identifier that does more than identify unique records
in staging. It is used in the process as a way to match fact records with their
dimension. During trouble shooting, you can use ETLKey in the common model fact
table, to track the facts back to their original staging record.

UniqueDims – A value that represents the intersection of all the dimensions that
make up a fact. The value is created using the SHA algorithm. This value is
created by a computed column in the common model and production and propagated
back to the stage table. This column can be used to identify duplicate records.
UniqueDims is used to determine what has been processed to production.

UniqueRows – Rarely used, UniqueRows is also created by a computed column in the
same fashion as UniqueDims except it uses the MD5 hash algorithm. UniqueRows is
often used in the case of fact tables that need to be updated where it
represents a hash of the currents facts. It is also used in the case when the
stage table is solely dimension data AND is also a junk dimension in which case
it, again, is a hash of the values in that record.

SourceSystem – A column holding the name of the system the data came from. In
the case where data is developed from more than one source, the value will be
“multi-source”.

Cleansed – A binary value that indicates whether the record has been cleaned or
not. Used in every table regardless, it comes in especially handy when cleaning
involves CASE statements where processing more than once can change the value.

ErrorRecord – Binary value used to indicate a problem with the record. This is a
multi-use file that can be used for any user defined error.

Processed – Binary value that indicates if the record has been moved to
production or not.

RunDate – Date timestamp that the data was pulled. Helpful for determining if
there was more than one run.

For a record to be processed, Cleansed, ErrorRecord, and Processed have to hold
the values of 1, 0, 0 respectively.

**Production Tables**

CreatedOn – Date the record was created. This value ALWAYS should be populated.

CreatedBy – Who created the record. This value ALWAYS should be populated.

UpdatedOn – Date the record was updated. This value ALWAYS should be populated.
When doing manual updates with INSERT or UPDATE, make sure your SQL statement
populates this value or risk really terrible things happening.

UpdatedBy – Who updated the record. This value ALWAYS should be populated. When
doing manual updates with INSERT or UPDATE, make sure your SQL statement
populates this value or risk really terrible things happening.

SourceSystem – Same as in staging.

SourceSystemKey – The uniquely identifying key from the source system. This is
usually a natural key but can be a primary key in certain use cases. Used in
tables that are not junk dimensions.

EffectiveFrom – Used in dimension tables to determine when the record started
being effective.

EffectiveTo - Used in dimension tables to determine when the record expired.

IsMostRecentRecord – Binary flag to determine which record is the current value
of the dimension.

RowHash – Used in junk dimension tables. It is a calculated field using the MD5
hash algorithm that represents the values of that row which is usually a unique
combination of columns. Can also be used in Type II slowly changing dimensions
where you only want to update certain columns.

UniqueDims – Same as in staging.
