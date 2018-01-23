USE ODS

--Start over
TRUNCATE TABLE [eod].[EODPrices]
TRUNCATE TABLE [eod].[Assets]
TRUNCATE TABLE [eod].[Exchanges]
TRUNCATE TABLE err.EODPrices
TRUNCATE TABLE FSA..[FactAssetPrices]
TRUNCATE TABLE FSA..FactExchangeCloseData
DELETE FROM FSA..DimAssets
DELETE FROM FSA..DimExchanges
TRUNCATE TABLE vol.LoadObservations
DELETE FROM vol.[Tables]
TRUNCATE TABLE [eod].[EODPricesPreStaging]


DBCC CHECKIDENT ('FSA..DimAssets', RESEED, 0)
DBCC CHECKIDENT ('FSA..DimExchanges', RESEED, 0)
DBCC CHECKIDENT ('FSA..FactAssetPrices', RESEED, 0)
DBCC CHECKIDENT ('FSA..FactExchangeCloseData', RESEED, 0)

