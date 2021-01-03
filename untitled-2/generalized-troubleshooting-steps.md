# Generalized Troubleshooting Steps

Any troubleshooting process is part procedural and part detective work. Reading the ETL Developers guide and making sure you have a good understanding of the system will help you fix problems faster than any step by step process. That being said, the following is a good heuristic for finding problems in the warehouse ETL process.

1. Open the step that blew up and determine what the error was.
2. If it was related to a proc, open the sub step and pull out the EXEC statements and run them by hand one by one. The trouble proc will blow up. \(This is where your .sql file of EXEC statements of every proc comes in handy.\)
3. Determine and fix the error. \(This is where you pull out your Sherlock Holmes pipe and go to work. There is no formulaic way to do this.\)
4. Re-run the step that blew up.

The process is designed so that any problems with loading dimensions brings the process to a grinding halt. Loading dimensions is a necessary sufficient condition for loading facts. Facts, on the other hand, can blow up and the rest of the fact tables will be allowed to continue processing.

The processing of dimensions should be really fast so any long run time on dimension processing should be considered a source of suspicion. Below are the top causes for warehouse load problems.

1. Duplicate records in staging as a result of bad logic in the source pull. The SQL MERGE statement cannot process duplicate records from a single source.
2. Data truncation. String data type sizes are determined by profiling existing data and then doubling the existing maximum character value. This does not always work over time. You will have to systematically determine which column is causing the problem.
3. Pulling source data again before processing the prior run. This will result in a duplicate record error.

