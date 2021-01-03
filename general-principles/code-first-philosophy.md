# Code First Philosophy

You want to write code to provide solutions instead of using point and click tools. The arguments for this are well laid out in the the section titled [Why You Should Not Use SSIS](../etl-developers-guide/should-you-use-ssis/).

What Python for ETL represents is a middle ground compromise between clunky difficult to use point and click tools, and the rare skillsets necessary to pipe stuff around in Linux with grep and cron jobs.

Writing code to solve ETL problems will represent a signification cost reduction to the organization's IT spend. While the framework does have a standard SSIS package, we strongly encourage you to ignore it. We will leave it as part of the framework because organizations still run SSIS and sometimes you may have no choice. However, you will probably have to upgrade the package to work with the current version of SQL Server as I stopped developing the SSIS piece of the framework years ago.

