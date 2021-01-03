# Implementing SCDs As Temporal Tables

**Authors note: This section is a work in progress. We're still evaluating the value of temporal tables in the framework.**

Microsoft introduced the concept of a temporal table in \[insert year\].

I resisted implementing temporal tables in the data warehouse for a very long time for two reasons.

1. I thought temporal tables were for OLAP systems. I did not see an EDW use case.
2. I did not like the idea of giving up control of marking and retiring records to the system. I do not even like to write triggers so you could imagine how I felt about automagically populated effective to and from dates.

However, I was finally forced to take a look at temporal tables for managing SCDs and now I am a total convert. Of course there is no zealot like a convert.

Implementing your SCDs as temporal tables DRASTICALLY reduces the amount of code you have to write to process a Type II SCD. That being said, it is not all roses. Choosing to implement temporal tables is an engineering decision that should be considered carefully. 

There are some design and policy choices to be made here.

1. How are tables implemented?
   1. Anonymous 
   2. Default 
   3. User Defined 
   4. Period columns visible or not
2. How long do you want to keep data for?

Plusses

Primary key doesn’t change when you make updates. 

Using a non-temporal query will get you the most recent row. No need to set most recent record to 1.  


Two big limitations.

1.       Indexed views are not supported on top of temporal queries \(queries that use FOR SYSTEM\_TIME clause\)

2.       Temporal querying over Linked Server is not supported.

Drawbacks 

Can’t run TRUNCATE Limitations: [https://docs.microsoft.com/en-us/sql/relational-databases/tables/temporal-table-considerations-and-limitations?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/relational-databases/tables/temporal-table-considerations-and-limitations?view=sql-server-ver15)

You can’t just drop a temporal table. [https://docs.microsoft.com/en-us/archive/blogs/sql\_pfe\_blog/sql-2016-temporal-tables-how-do-you-drop-a-temporal-table](https://docs.microsoft.com/en-us/archive/blogs/sql_pfe_blog/sql-2016-temporal-tables-how-do-you-drop-a-temporal-table)



