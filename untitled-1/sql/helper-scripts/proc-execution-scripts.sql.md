# proc execution scripts

When you are building your ETL processes, it is good to have a place where you can quickly execute procs without having to run SQL Server Agent. This is where I do that. I have every proc that I managed organized by model.

```text
USE ODS

--Your Model
--Start Over
TRUNCATE TABLE YourFactTable
DELETE FROM DimYourDimTable

--Pull Data
EXEC usp_YourPullProcess

--Clean Data
EXEC usp_YourCleanProcess

--Process Dims
EXEC sp_ProcessDimExchanges

--Process Facts
EXEC sp_ProcessYourFactTable

--Finalize and Audit
EXEC sp_RecordRowCounts
EXEC sp_MarkRecordsAsProcessed
EXEC sp_CheckForUnprocessedRecords

--Monitoring
EXEC sp_TableLoadMonitoring
EXEC sp_LoadTableLoadReportingTable
```

