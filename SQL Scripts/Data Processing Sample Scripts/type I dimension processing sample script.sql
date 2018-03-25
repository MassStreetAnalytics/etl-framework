-- =============================================
-- Author: Bob Wakefield
-- Create date: 30May17
-- Description: DimAssets Dimension Processing
-- 7Oct17 Updated to properly process Type II SCDs
-- 10Oct17 Updated source system key load to reflect the fact that
-- Symbol and Exchange are required for uniqueness.
-- =============================================

USE ODS

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.sp_ProcessDimAssets') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.sp_ProcessDimAssets
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_ProcessDimAssets
AS
BEGIN

DECLARE @LowDate AS DATETIME
DECLARE @HighDate AS DATETIME = '99991231'

SELECT @LowDate = CAST(CAST(MIN(DateCK) AS NVARCHAR) AS DATETIME)
FROM FSA.dbo.DimDate

IF OBJECT_ID('tempdb..#DimAssets') IS NOT NULL DROP TABLE #DimAssets

CREATE TABLE #DimAssets(
[AssetsCK] [bigint] NULL,
[Symbol] [nvarchar](50) NULL,
[AssetName] [nvarchar](100) NULL,
[AssetType] [nvarchar](20) NULL,
[AssetExchange] [nvarchar](100) NULL,
[CreatedBy] [nvarchar](50) NULL,
[CreatedOn] [datetime] NULL,
[UpdatedBy] [nvarchar](50) NULL,
[UpdatedOn] [datetime] NULL,
[SourceSystem] [nvarchar](100) NULL,
[SourceSystemKey] [nvarchar](100) NULL,
[EffectiveFrom] [datetime] NULL,
[EffectiveTo] [datetime] NULL,
[IsMostRecentRecord] [bit] NULL
)



TRUNCATE TABLE cm.DimAssets

BEGIN TRANSACTION

INSERT INTO cm.DimAssets(
[Symbol],
[AssetName],
[AssetType],
[AssetExchange],
[SourceSystem],
[SourceSystemKey]
)
SELECT
DISTINCT
[Symbol],
[AssetName],
[AssetType],
[AssetExchange],
[SourceSystem],
CONCAT([Symbol],'|',[AssetExchange]) COLLATE DATABASE_DEFAULT
FROM [eod].[Assets]
WHERE Processed = 0
AND ErrorRecord = 0


--Handle New Records
MERGE FSA..DimAssets AS target
USING (
SELECT
[Symbol],
[AssetName],
[AssetType],
[AssetExchange],
[SourceSystem],
[SourceSystemKey],
RowHash
FROM cm.DimAssets
) AS source
ON target.[SourceSystemKey] COLLATE DATABASE_DEFAULT = source.[SourceSystemKey] COLLATE DATABASE_DEFAULT
AND target.AssetExchange COLLATE DATABASE_DEFAULT = source.AssetExchange COLLATE DATABASE_DEFAULT

WHEN NOT MATCHED THEN
INSERT (
[Symbol],
[AssetName],
[AssetType],
[AssetExchange],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn
)
VALUES (
[Symbol],
[AssetName],
[AssetType],
[AssetExchange],
[SourceSystem],
[SourceSystemKey],
@LowDate,
@HighDate,
1,
SYSTEM_USER,
CURRENT_TIMESTAMP
);



--Handle changed records
INSERT INTO #DimAssets(
[Symbol],
[AssetName],
[AssetType],
[AssetExchange],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn
)
SELECT
[Symbol],
[AssetName],
[AssetType],
[AssetExchange],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn 
FROM(
MERGE FSA..DimAssets AS target
USING (
SELECT
[Symbol],
[AssetName],
[AssetType],
[AssetExchange],
[SourceSystem],
[SourceSystemKey],
RowHash
FROM cm.DimAssets
) AS source
ON target.[SourceSystemKey] COLLATE DATABASE_DEFAULT = source.[SourceSystemKey] COLLATE DATABASE_DEFAULT
AND target.AssetExchange COLLATE DATABASE_DEFAULT = source.AssetExchange COLLATE DATABASE_DEFAULT
WHEN MATCHED
AND source.RowHash <> target.RowHash
AND target.IsMostRecentRecord = 1
THEN
UPDATE
SET
[UpdatedBy] = SYSTEM_USER,
[UpdatedOn] = CURRENT_TIMESTAMP,
EffectiveTo = DATEADD(ss,-1,CURRENT_TIMESTAMP),
IsMostRecentRecord = 0
OUTPUT 
$action Action_Out,
source.[Symbol],
source.[AssetName],
source.[AssetType],
source.[AssetExchange],
source.[SourceSystem],
source.[SourceSystemKey],
CURRENT_TIMESTAMP AS EffectiveFrom,
@HighDate AS EffectiveTo,
1 AS IsMostRecentRecord,
SYSTEM_USER AS CreatedBy,
CURRENT_TIMESTAMP AS CreatedOn
) AS MERGE_OUT
WHERE MERGE_OUT.Action_Out = 'UPDATE'
;


INSERT INTO FSA..DimAssets(
[Symbol],
[AssetName],
[AssetType],
[AssetExchange],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn
)
SELECT
[Symbol],
[AssetName],
[AssetType],
[AssetExchange],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn
FROM #DimAssets 

--Update staging so you know what's been processed
UPDATE st
SET 
st.UniqueRows = cmt.RowHash
FROM eod.Assets st
JOIN cm.DimAssets cmt
ON st.AssetName COLLATE DATABASE_DEFAULT = cmt.AssetName COLLATE DATABASE_DEFAULT
AND st.AssetType COLLATE DATABASE_DEFAULT = cmt.AssetType COLLATE DATABASE_DEFAULT
AND st.AssetExchange COLLATE DATABASE_DEFAULT = cmt.AssetExchange COLLATE DATABASE_DEFAULT
AND st.Symbol COLLATE DATABASE_DEFAULT = cmt.Symbol COLLATE DATABASE_DEFAULT



TRUNCATE TABLE cm.DimAssets

INSERT INTO cm.DimAssets(
[AssetsCK],
SourceSystemKey
)
SELECT
[AssetsCK],
SourceSystemKey
FROM FSA..DimAssets
WHERE IsMostRecentRecord = 1

COMMIT TRANSACTION

DROP TABLE #DimAssets

END