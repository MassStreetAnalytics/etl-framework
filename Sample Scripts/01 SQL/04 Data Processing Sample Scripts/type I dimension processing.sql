-- =============================================
-- Author:
-- Create date:
-- Description:
-- =============================================

USE ODS

GO

DROP PROCEDURE IF EXISTS dbo.usp_ProcessDimYourDimensionName
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE usp_ProcessDimYourDimensionName
AS
BEGIN

DECLARE @LowDate AS DATETIME
DECLARE @HighDate AS DATETIME

SELECT @HighDate = CAST(MAX(DateCK) AS NCHAR(8))
FROM DimDate
WHERE DateCK NOT IN (00000000,11111111)

SELECT @LowDate = CAST(MIN(DateCK) AS NCHAR(8))
FROM DimDate
WHERE DateCK NOT IN (00000000,11111111)

TRUNCATE TABLE [cm].[DimYourDimensionName]

BEGIN TRANSACTION

BEGIN TRANSACTION

INSERT INTO cm.DimYourDimensionName(
--your columns here
[SourceSystem],
[SourceSystemKey]
)
SELECT DISTINCT
--your columns here
FROM YourStageTable




MERGE DimYourDimensionName AS target
USING (
SELECT
--your columns here
[SourceSystem],
[SourceSystemKey]
FROM cm.DimYourDimensionName
) AS source
ON (target.SourceSystemKey COLLATE DATABASE_DEFAULT  = source.SourceSystemKey COLLATE DATABASE_DEFAULT)

WHEN NOT MATCHED THEN
INSERT (
--your columns here
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn
)
VALUES (
--your columns here
[SourceSystem],
[SourceSystemKey],
@LowDate,
@HighDate,
1,
SYSTEM_USER,
CURRENT_TIMESTAMP
)

WHEN MATCHED

THEN
UPDATE
SET
--your columns here
target.[YourColumn] = source.[YourColumn],
CreatedBy = SYSTEM_USER,
CreatedOn = CURRENT_TIMESTAMP
;

TRUNCATE TABLE cm.DimYourDimensionName

INSERT INTO cm.DimYourDimensionName(
YourDimensionNameCK,
SourceSystemKey
)
SELECT
YourDimensionNameCK,
SourceSystemKey
FROM DimYourDimensionName




COMMIT TRANSACTION

END
