-- =============================================
-- Author: Bob Wakefield
-- Create date: 13Oct17
-- Description: Fact Asset Prices processing
-- Change Log
-- =============================================

USE ODS

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ProcessFactAssetPrices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ProcessFactAssetPrices]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_ProcessFactAssetPrices
AS
BEGIN


IF OBJECT_ID('tempdb..#DimAssets') IS NOT NULL DROP TABLE #DimAssets

CREATE TABLE #DimAssets(DimCK BIGINT, SourceSystemKey NVARCHAR(50), ETLKey UNIQUEIDENTIFIER)
CREATE CLUSTERED INDEX CIDX_CURRENCY_ETLKEY ON #DimAssets(ETLKey)
CREATE NONCLUSTERED INDEX NCIDX_DIM10_ETLKEY ON #DimAssets(SourceSystemKey)


--BEGIN TRANSACTION
----

INSERT INTO #DimAssets(SourceSystemKey, ETLKey)
SELECT CONCAT(Symbol,'|',Exchange) COLLATE DATABASE_DEFAULT, ETLKey
FROM [eod].[EODPrices]
WHERE Processed = 0
AND [ErrorRecord] = 0


UPDATE tt
SET tt.DimCK = cmt.AssetsCK
FROM #DimAssets tt
JOIN [cm].DimAssets cmt
ON tt.SourceSystemKey COLLATE DATABASE_DEFAULT = cmt.SourceSystemKey COLLATE DATABASE_DEFAULT

--find price records with no DimAsset record and mark as error
UPDATE eod.EODPrices
SET ErrorRecord = 1
WHERE ETLKey IN (
SELECT tt.ETLKey
FROM #DimAssets tt
LEFT OUTER JOIN [cm].DimAssets cmt
ON tt.SourceSystemKey COLLATE DATABASE_DEFAULT = cmt.SourceSystemKey COLLATE DATABASE_DEFAULT
WHERE tt.DimCK IS NULL
)

--Remove that error record from the temp table.
DELETE tt
FROM #DimAssets tt
LEFT OUTER JOIN [cm].DimAssets cmt
ON tt.SourceSystemKey COLLATE DATABASE_DEFAULT = cmt.SourceSystemKey COLLATE DATABASE_DEFAULT
WHERE tt.DimCK IS NULL

----


TRUNCATE TABLE [cm].[FactAssetPrices]



INSERT INTO [cm].[FactAssetPrices](
[ETLKey],
AssetsCK,
AsOfDate,
PriceOpen,
PriceHigh,
PriceLow,
PriceClose,
Volume,
[SourceSystem]
)
SELECT
p.[ETLKey],
a.DimCK,
p.[Date],
p.[Open],
p.High,
p.Low,
p.[Close],
p.Volume,
p.SourceSystem
FROM eod.EODPrices p
JOIN #DimAssets a
ON p.ETLKey = a.ETLKey
WHERE p.Processed = 0
AND p.[ErrorRecord] = 0

UPDATE st
SET st.[UniqueDims] = cmt.[UniqueDims]
FROM [eod].[EODPrices] st
JOIN [cm].[FactAssetPrices] cmt
ON st.ETLKey = cmt.ETLKey

--For now, we're going to error out records that duplicate within the day.
--The duplicatation is based on UniqueDims not UniqueRows.
--The problem is we really don't know which is the correct record at this point
--so it's better to just error the record then impute the missing value.
UPDATE eod.EODPrices
SET ErrorRecord = 1
WHERE UniqueDims IN(
SELECT UniqueDims
FROM eod.EODPrices
WHERE UniqueDims IS NOT NULL
GROUP BY [UniqueDims]
HAVING COUNT(*) > 1
)

DELETE cm.FactAssetPrices
WHERE UniqueDims IN(
SELECT UniqueDims
FROM eod.EODPrices
WHERE UniqueDims IS NOT NULL
GROUP BY [UniqueDims]
HAVING COUNT(*) > 1
)


MERGE FSA..[FactAssetPrices] AS target
USING(
SELECT
[AssetsCK],
[AsOfDate],
[PriceOpen],
[PriceHigh],
[PriceLow],
[PriceClose],
[Volume],
[SourceSystem],
[UniqueDims],
UniqueRows
FROM [cm].[FactAssetPrices]
) AS source
ON target.[UniqueDims] = source.[UniqueDims]

WHEN NOT MATCHED THEN

INSERT(
[AssetsCK],
[AsOfDate],
[PriceOpen],
[PriceHigh],
[PriceLow],
[PriceClose],
[Volume],
[SourceSystem],
[CreatedOn],
[CreatedBy]
)
VALUES(
source.[AssetsCK],
source.[AsOfDate],
source.[PriceOpen],
source.[PriceHigh],
source.[PriceLow],
source.[PriceClose],
source.[Volume],
source.[SourceSystem],
CURRENT_TIMESTAMP,
SYSTEM_USER
)

WHEN MATCHED
AND source.UniqueRows <> target.UniqueRows
THEN
UPDATE
SET
[PriceOpen] = source.PriceOpen,
[PriceHigh] = source.PriceHigh,
[PriceLow] = source.PriceLow,
[PriceClose] = source.PriceClose,
[Volume] = source.Volume,
[SourceSystem] = source.SourceSystem,
[UpdatedBy] = SYSTEM_USER,
[UpdatedOn] = CURRENT_TIMESTAMP
;






COMMIT TRANSACTION


DROP TABLE #DimAssets


END