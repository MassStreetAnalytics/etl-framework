# SSIS Is Not Forward Compatible

What this means is, if your organization decides to upgrade SQL Server, you will have to upgrade all of your SSIS packages as well. I have done a couple SSIS conversion projects. The upgrade can be as simple as running the package conversion process in Visual Studio. However, if you are using a deprecated feature, you may have to redesign numerous SSIS packages. If you are using a lot of SSIS packages for complex ETL, this conversion process can be quite lengthy. You will also have to regression test everything.

In any scenario, upgrading your SSIS packages is an unnecessary cost. Neither Python nor T-SQL suffer from forward compatibility issues. There is an issue moving from Python 2 to Python 3, but those issues can be obviated by:

1. starting with Python 3
2. not upgrading to Python 3

If you are already running Python 2 in your organization, there is no need to upgrade to Python 3 just to do ETL.

Both Python and T-SQL will continue to work just fine in newer versions of SQL Server. Python because it has no real relationship to Microsoft. T-SQL because that language is relatively stable, and Microsoft usually only adds features while leaving existing functionality alone.

