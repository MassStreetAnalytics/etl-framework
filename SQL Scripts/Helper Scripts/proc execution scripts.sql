USE ODS

--Exchanges Model
--Start Over
DELETE FROM FSA..DimExchanges

UPDATE eod.Exchanges
SET TimeZone = 'India Standard Time'
WHERE TimeZone = 'Bad Ass India Standard Time'


UPDATE eod.Exchanges
SET TimeZone = 'Bad Ass India Standard Time'
WHERE TimeZone = 'India Standard Time'

UPDATE eod.Exchanges
SET TimeZone = 'Really Bad Ass India Standard Time'
WHERE TimeZone = 'Bad Ass India Standard Time'


SELECT *
FROM eod.Exchanges
WHERE Code = 'BSE'


--Process Dims
EXEC sp_ProcessDimExchanges

--Process Facts
EXEC sp_ProcessFactExchangeCloseData

--Check
SELECT * FROM FSA..DimExchanges WHERE SourceSystemKey = 'BSE'
SELECT * FROM cm.DimExchanges WHERE SourceSystemKey = 'BSE'

--DimAssets
--Start Over
DELETE FROM FSA..DimAssets
--TRUNCATE TABLE eod.Assets

--UPDATE eod.Assets
--SET AssetName = 'New Asset Name'
--WHERE Symbol = 'IVW'

--UPDATE eod.Assets
--SET AssetName = 'S&P 500 Growth Ishares'
--WHERE Symbol = 'IVW'

--Process Dims
EXEC sp_ProcessDimAssets

--Check
SELECT * FROM FSA..DimAssets
SELECT * FROM eod.Assets
SELECT * FROM cm.DimAssets


--Asset Prices Model
--Start Over
TRUNCATE TABLE [eod].[EODPrices]
--TRUNCATE TABLE eod.Assets
TRUNCATE TABLE FSA..FactAssetPrices
DBCC CHECKIDENT ('FSA..FactAssetPrices', RESEED, 0)
DELETE FROM FSA..DimAssets
DBCC CHECKIDENT ('FSA..DimAssets', RESEED, 0)


--Cleaning
EXEC sp_CleanEODPrices

--Process Dimensions
EXEC sp_ProcessDimAssets

--Process Facts
EXEC sp_ProcessFactAssetPrices

--Check
SELECT * FROM FSA..FactAssetPrices
SELECT * FROM eod.EODPrices
SELECT * FROM FSA..DimAssets

--Finalize and Audit
EXEC sp_RecordRowCounts
EXEC sp_MarkRecordsAsProcessed
EXEC sp_CheckForUnprocessedRecords

--Monitoring
EXEC sp_TableLoadMonitoring
EXEC sp_LoadTableLoadReportingTable


---Check queries
SELECT DISTINCT Exchange, [Date]
FROM eod.EODPrices

SELECT Exchange, [Date], COUNT(*)
FROM ODS.eod.EODPrices
GROUP BY Exchange, [Date]



SELECT COUNT(*) AS DimAssets FROM FSA.[dbo].[DimAssets]
SELECT COUNT (*) AS FactAssetPrices FROM FSA.[dbo].[FactAssetPrices]
SELECT COUNT(*) AS DimExchanges FROM FSA..DimExchanges
SELECT COUNT(*) AS FactExchangeCloseData FROM FSA..FactExchangeCloseData
SELECT COUNT(*) AS ErrorRecords FROM ODS.err.EODPrices
SELECT COUNT(*) AS RecordsInEODPrices FROM [eod].[EODPrices]
SELECT COUNT(*) AS ProcessedRecordsInEODPrices FROM [eod].[EODPrices] WHERE Processed = 1

SELECT COUNT(*) FROM [ODS].[eod].[EODPricesPreStaging]



SELECT TOP 1000 * FROM eod.EODPrices WHERE UniqueDims = 0xC6FC32E4BEA7D3C5EEDE58283A32A247C2F749F1

SELECT TOP 10 UniqueDims,COUNT(*)
FROM eod.EODPrices
GROUP BY UniqueDims
HAVING COUNT(*) > 1


SELECT COUNT (*) AS FactAssetPrices FROM FSA.[dbo].[FactAssetPrices]





Index notes
Symbol, Exchange, Date
UniqueRows
UniqueDims
ErrorRecord
Processed
RunDate

