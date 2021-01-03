# fact table load

Using this script is an incredibly complex process that we are going to save talking about until the section titled [Implementing New Fact Tables](../../../building-out-your-data-warehouse/implementing-new-data-models/implementing-new-fact-tables.md).

At a high level, it works like this:

1. Collect up all the dimension keys from the staging data fact records and store them in temp tables.
2. Join the temp tables to the common model tables on key and retrieve the contrive key from that record.
3. Join your temp tables to staging and populate the common model fact table with the current contrived key.

```text
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
ON p.ETLKey = a.ETLKey
JOIN #DimYourJunkDimension b
ON p.ETLKey = .ETLKey
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
```

