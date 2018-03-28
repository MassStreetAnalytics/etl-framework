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

