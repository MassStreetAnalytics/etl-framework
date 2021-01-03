# SSIS Is Not Very Performant

The slowly changing dimension task in SSIS is not performant. Also, the standard method to load data warehouse fact tables is also not performant compared to an equivalent process with T-SQL. But those statements are only true for experienced T-SQL software engineers.

A better argument is that SSIS by its very nature is not performant. There is a paper floating around that talks about how SSIS holds the record for ETL. However, if you read this paper, you will see that the speed of processing was largely due to network configuration and not much to do with SSIS.

When you create an SSIS package, what you are doing is creating an XML file. The XML file is what gets published and consumed by SQL Server agent or whatever orchestration tool you are using when you push a package to prod. That XML file contains all the information that you “programmed” when you clicked and dragged task around the design surface.

When you deploy an SSIS package, it goes into something called the SSIS catalogue. To be honest, the file goes down a black hole and I am not 100% certain what happens after that. I know how to set it up in SQL Server Agent so it executes, but I do not know the mechanics. I have never bothered to look under the hood because I could never get past the fact that, no matter what was going on, it was an unnecessary step in the warehouse load process.

Python is an interpreted scripting language. It is not compiled like T-SQL stored procedures. However, the amount of Python in your ETL processes should be relatively low. You should be relying mostly on T-SQL. You do that by getting data into a table as quick as you can so you can rely on the database engine. Relational databases are built to join data, so if you are using Python to join datasets in a medium data use case, you are writing inefficient ETL.

It does require some skill, but even the most junior software engineer can develop ETL processes with T-SQL and Python that will outperform SSIS.

Why does performance matter? When writing overnight batch processes, you might think that performance is no big deal. However, you always want to write the fastest performing ETL processes you can for a couple of reasons.

When things break, having a fast ETL process gets you back on track faster. If you have to run the process intraday, you do not want executives waiting for their data any longer than they have to. If you write a package that takes an hour to run, then getting back on track will be defined by:

$$
y = a + b
$$

Where:  
y = total data warehouse unavailability in hours  
a = the amount of time it takes to fix issues in the load in hours  
b = the amount of time it takes to process unprocessed data in hours

Obviously, you want to minimize b in this equation which is why you want to have the highest performing ETL processes that you can.

The other reason you want fast ETL is because historical data can pile up quick. While the nightly load may add to the total data in a linear fashion, the performance of your code over that data degrades in an exponential fashion. In other words, and this is a simplified example, over time, your data may double, but the performance of your ETL may be four times worse than what you started with.

Always work from the assumption that eventually you will have a ton of data to deal with and write code accordingly. That way, if you have a process that runs really fast over relatively small amounts of data, then, when you have large amounts, the processing degradation will not be as severe.

