-- =============================================
-- Author: Bob Wakefield
-- Create date: 5Oct17
-- Description: DimExchanges Dimension Processing
-- =============================================

USE ODS

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.sp_ProcessDimExchanges') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.sp_ProcessDimExchanges
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_ProcessDimExchanges
AS
BEGIN

DECLARE @LowDate AS DATETIME
DECLARE @HighDate AS DATETIME = '99991231'

SELECT @LowDate = CAST(CAST(MIN(DateCK) AS NVARCHAR) AS DATETIME)
FROM FSA.dbo.DimDate

IF OBJECT_ID('tempdb..#DimExchanges') IS NOT NULL DROP TABLE #DimExchanges

CREATE TABLE #DimExchanges(
[ExchangesCK] [bigint] NULL,
[Name] [nvarchar](50) NULL,
[Code] [nvarchar](10) NULL,
[IsIntraday] [nvarchar](10) NULL,
[TimeZone] [nvarchar](50) NULL,
[Suffix] [nvarchar](10) NULL,
[Currency] [nvarchar](10) NULL,
[Country] [nvarchar](2) NULL,
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


TRUNCATE TABLE cm.DimExchanges

BEGIN TRANSACTION

--Handle new records
INSERT INTO cm.DimExchanges(
[Name],
[Code],
[IsIntraday],
[TimeZone],
[Suffix],
[Currency],
[Country],
[SourceSystem],
[SourceSystemKey]
)
SELECT
DISTINCT
[Name],
[Code],
[IsIntraday],
[TimeZone],
[Suffix],
[Currency],
[Country],
[SourceSystem],
[Code]
FROM [eod].[Exchanges]
WHERE Processed = 0

MERGE FSA..DimExchanges AS target
USING (
SELECT
[Name],
[Code],
[IsIntraday],
[TimeZone],
[Suffix],
[Currency],
[Country],
[SourceSystem],
[SourceSystemKey],
RowHash
FROM cm.DimExchanges
) AS source
ON target.[SourceSystemKey] COLLATE DATABASE_DEFAULT = source.[SourceSystemKey] COLLATE DATABASE_DEFAULT

WHEN NOT MATCHED THEN
INSERT (
[Name],
[Code],
[IsIntraday],
[TimeZone],
[Suffix],
[Currency],
[Country],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn
)
VALUES (
[Name],
[Code],
[IsIntraday],
[TimeZone],
[Suffix],
[Currency],
[Country],
[SourceSystem],
[SourceSystemKey],
@LowDate,
@HighDate,
1,
SYSTEM_USER,
CURRENT_TIMESTAMP
)
;


--Handle changed records
INSERT INTO #DimExchanges(
[Name],
[Code],
[IsIntraday],
[TimeZone],
[Suffix],
[Currency],
[Country],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn
)
SELECT
[Name],
[Code],
[IsIntraday],
[TimeZone],
[Suffix],
[Currency],
[Country],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn 
FROM(
MERGE FSA..DimExchanges AS target
USING (
SELECT
[Name],
[Code],
[IsIntraday],
[TimeZone],
[Suffix],
[Currency],
[Country],
[SourceSystem],
[SourceSystemKey],
RowHash
FROM cm.DimExchanges
) AS source
ON target.[SourceSystemKey] COLLATE DATABASE_DEFAULT = source.[SourceSystemKey] COLLATE DATABASE_DEFAULT
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
source.[Name],
source.[Code],
source.[IsIntraday],
source.[TimeZone],
source.[Suffix],
source.[Currency],
source.[Country],
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

INSERT INTO FSA..DimExchanges(
[Name],
[Code],
[IsIntraday],
[TimeZone],
[Suffix],
[Currency],
[Country],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn
)
SELECT
[Name],
[Code],
[IsIntraday],
[TimeZone],
[Suffix],
[Currency],
[Country],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn
FROM #DimExchanges


TRUNCATE TABLE cm.DimExchanges

INSERT INTO cm.DimExchanges(
[ExchangesCK],
[SourceSystemKey]
)
SELECT
[ExchangesCK],
[SourceSystemKey]
FROM FSA..DimExchanges
WHERE IsMostRecentRecord = 1

COMMIT TRANSACTION

DROP TABLE #DimExchanges

END