-- =============================================
-- Author:
-- Create date:
-- Description:
-- =============================================

USE ODS

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ProcessFactYourFactTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProcessFactYourFactTable]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE usp_ProcessFactYourFactTable
AS
BEGIN


IF OBJECT_ID('tempdb..#DimYourDimensionTable') IS NOT NULL DROP TABLE #DimYourDimensionTable
IF OBJECT_ID('tempdb..#DimYourJunkDimension') IS NOT NULL DROP TABLE #DimYourJunkDimension

CREATE TABLE #DimYourDimensionTable(DimCK BIGINT, SourceSystemKey NVARCHAR(50), ETLKey UNIQUEIDENTIFIER)
CREATE TABLE #DimYourJunkDimension(DimCK BIGINT, RowHash BINARY(16), ETLKey UNIQUEIDENTIFIER)


CREATE CLUSTERED INDEX CIDX_1 ON #DimYourDimensionTable(ETLKey)
CREATE CLUSTERED INDEX CIDX_2 ON #DimYourJunkDimension(ETLKey)


CREATE NONCLUSTERED INDEX NCIDX_1 ON #DimYourDimensionTable(SourceSystemKey)
CREATE NONCLUSTERED INDEX NCIDX_2 ON #DimYourJunkDimension(RowHash)


BEGIN TRANSACTION
----

INSERT INTO #DimYourDimensionTable(SourceSystemKey, ETLKey)
SELECT KeyColumn, ETLKey
FROM StageTable
WHERE Processed = 0
AND [ErrorRecord] = 0


UPDATE tt
SET tt.DimCK = cmt.YourDimensionTableCK
FROM #DimYourDimensionTable tt
JOIN [cm].DimYourDimensionTable cmt
ON tt.SourceSystemKey  = cmt.SourceSystemKey 


---
INSERT INTO #DimYourJunkDimension(RowHash, etl_key)
SELECT HASHBYTES('MD5',ColumnName), ETLKey
FROM StageTable
WHERE processed = 0
AND error_record = 0

UPDATE tt
SET tt.DimCK = cmt.YourJunkDimensionCK
FROM #DimYourJunkDimension tt
JOIN cm.DimYourJunkDimension cmt
ON tt.RowHash = cmt.RowHash

----


TRUNCATE TABLE [cm].[FactYourFactTable]



INSERT INTO [cm].[FactYourFactTable](
[ETLKey],
YourDimensionTableCK,
YourJunkDimensionCK,
--your columns
[SourceSystem]
)
SELECT
p.[ETLKey],
a.DimCK,
b.DimCK,
--your coulumns
p.SourceSystem
FROM YourStageTable p
JOIN #DimYourDimensionTable a
ON a.ETLKey = p.ETLKey
JOIN #DimYourJunkDimension b
ON b.ETLKey = p.ETLKey
WHERE p.Processed = 0
AND p.[ErrorRecord] = 0

--Update staging so you can match to production later.
UPDATE st
SET st.[UniqueDims] = cmt.[UniqueDims]
FROM YourStageTable st
JOIN YourFactTable cmt
ON st.ETLKey = cmt.ETLKey


MERGE [FactYourFactTable] AS target
USING(
SELECT
YourDimensionTableCK,
YourJunkDimensionCK,
--your columns
[SourceSystem],
[UniqueDims],
FROM [cm].[FactYourFactTable]
) AS source
ON target.[UniqueDims] = source.[UniqueDims]

WHEN NOT MATCHED THEN

INSERT(
YourDimensionTableCK,
YourJunkDimensionCK,
--your columns
[SourceSystem],
[CreatedOn],
[CreatedBy]
)
VALUES(
source.YourDimensionTableCK,
source.YourJunkDimensionCK,
--your columns
source.[Volume],
source.[SourceSystem],
CURRENT_TIMESTAMP,
SYSTEM_USER
)

WHEN MATCHED
THEN
UPDATE
SET
YourColumns = source.YourColumns,
[SourceSystem] = source.SourceSystem,
[UpdatedBy] = SYSTEM_USER,
[UpdatedOn] = CURRENT_TIMESTAMP
;






COMMIT TRANSACTION


DROP TABLE #DimYourDimensionTable


END