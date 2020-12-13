-- =============================================
-- Author: Bob Wakefield
-- Create date: 15Oct17
-- Description: Mark records in stage tables as 
-- having been processsed.
-- Every fact table load you build will need code
-- added to the usp_MarkRecordsAsProcessed stored 
-- procedure. 
-- =============================================

USE ODS
GO

DROP PROCEDURE IF EXISTS dbo.usp_MarkRecordsAsProcessed
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.usp_MarkRecordsAsProcessed
AS
BEGIN


UPDATE st
SET Processed = 1
FROM [eod].[Assets] st
JOIN FSA..DimAssets pt
ON pt.RowHash = st.UniqueRows 
WHERE st.ErrorRecord = 0

UPDATE st
SET Processed = 1
FROM eod.Exchanges st
JOIN FSA..FactExchangeCloseData pt
ON pt.UniqueDims = st.UniqueDims
WHERE st.ErrorRecord = 0


--Marking price data is a mulit step process.
BEGIN TRANSACTION ProcessedPrices
UPDATE st
SET Processed = 1
FROM eod.EODPrices st
JOIN FSA..FactAssetPrices pt
ON pt.UniqueDims = st.UniqueDims
WHERE st.ErrorRecord = 0

--Mark records that are listed in 
--more than one exchange.
UPDATE st
SET st.Processed = 1
FROM eod.EODPrices st
JOIN FSA..DimAssets pt
ON st.Symbol = pt.Symbol
WHERE st.ErrorRecord = 1
AND st.Processed = 0

--Save records that have no record in DimAsset
INSERT INTO err.EODPrices(
[ETLKey],
[Symbol],
[Exchange],
[Date],
[Open],
[High],
[Low],
[Close],
[Volume],
[UniqueDims],
[UniqueRows],
[SourceSystem],
[ErrorRecord],
[Processed],
[RunDate]
)
SELECT
[ETLKey],
[Symbol],
[Exchange],
[Date],
[Open],
[High],
[Low],
[Close],
[Volume],
[UniqueDims],
[UniqueRows],
[SourceSystem],
[ErrorRecord],
[Processed],
[RunDate]
FROM eod.EODPrices p
WHERE p.ErrorRecord = 1
AND p.Processed = 0

--Mark saved error records as processed
UPDATE p
SET p.Processed = 1
FROM eod.EODPrices p
JOIN err.EODPrices ep
ON p.ETLKey = ep.ETLKey
WHERE p.ErrorRecord = 1
AND p.Processed = 0

COMMIT TRANSACTION ProcessedPrices



END
GO


