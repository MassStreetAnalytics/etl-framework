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



END
GO


