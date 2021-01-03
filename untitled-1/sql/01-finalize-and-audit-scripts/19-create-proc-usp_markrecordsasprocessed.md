# 19 CREATE PROC usp\_MarkRecordsAsProcessed

Description: Mark records in stage tables as having been processed. 

Necessary Modification: Every fact table load you build will need code added to the stored procedure so it becomes part of the audit process. Loading dimensions isn't normally problematic so they are not part of this process. If a dimension is missing records, the entire process will grind to a halt as designed.

 Below is an example of the code that needs to be added for each load process.

```text
UPDATE st
SET Processed = 1
FROM [eod].[Assets] st
JOIN FSA..FactAssets pt
ON pt.UniqueDims = st.UniqueDims
WHERE st.ErrorRecord = 0
```

```text
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



END
GO
```



