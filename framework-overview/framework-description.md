# Framework Description

The Data Warehouse ETL Framework is open, extensible, and flexible. Pull request are welcome.

This is the system that is used when Mass Street resources are tasked with implementing data warehouses. The framework has been in development since 2011. It is currently powering the analytics for several small to medium sized firms with anywhere from a few hundred GBs to several TBs of historical data and moves hundreds of millions of records nightly across all implementations.

The framework works best in organizations that do not have a lot of tooling built up around their data warehouse. Typically, clients that do greenfield EDW projects do not have things like master data management software, or data governance policies on day one. The ETL framework fills in these standard EDW project requirements with no additional IT spend.

The framework can also be implemented in existing EDW deployments although it might take some work to shoehorn in all the elements. The framework is flexiable enough that you can take a cafeteria approach to implementation; take what you want and leave the rest. 

The framework was built with SQL Server in mind. All of the SQL code examples are written for SQL Server.  However, the concepts discussed in this document can be generalized to any data warehouse that lives in a relational database. Theoretically, this framework could be used in Azure SQL Database, but no testing on that has been done.

SSIS has been deprecated in the framework and is no longer being developed. The template package and all of the infrastructure still exist for those environments that require SSIS. 

Currently the framework is designed for [Medium Data®](../appendices/appendix-c.-what-is-medium-data.md) use cases using relational database technology. 

