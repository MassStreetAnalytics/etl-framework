-- =============================================
-- Author: Bob Wakefield
-- Create date: 7April16
-- Description: Loads table load reporting table
-- 23Dec16: Updated to take into account larger record counts
-- Int datatype was too small.
-- =============================================

USE [ODS]
GO


DROP PROCEDURE IF EXISTS [dbo].[usp_LoadTableLoadReportingTable]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_LoadTableLoadReportingTable] AS
BEGIN

CREATE TABLE #UnWantedTables(TableID INT)
CREATE CLUSTERED INDEX CIDX_UNWANTEDTABLES_TABLEID ON #UnWantedTables(TableID)

DECLARE @MostRecentDate DATETIME
DECLARE @MostRecentDateInReportingTable DATE


SELECT @MostRecentDate =  MAX(DateOfCurrentObservation) FROM [vol].[LoadObservations]
SELECT @MostRecentDateInReportingTable = MAX(DateOfCurrentObservation) FROM rpt.TableLoadReport

INSERT INTO #UnWantedTables(TableID)
--Get rid of tables with no records
SELECT t.TableID
FROM [vol].[Tables] t
JOIN [vol].[LoadObservations] lo
ON t.TableID = lo.TableID
GROUP BY t.TableID
HAVING AVG(CAST(lo.[RowCount] AS BIGINT)) = 0
UNION
--Get rid of tables with no load variance
SELECT t.TableID
FROM [vol].[Tables] t
JOIN [vol].[LoadObservations] lo
ON t.TableID = lo.TableID
GROUP BY t.TableID
HAVING AVG(CAST(lo.CurrentThreeSDLevel AS BIGINT)) = 0

--Remove Rarely loaded tables from load analysis
--INSERT INTO #UnWantedTables(TableID)
--SELECT 131
--UNION ALL
--SELECT 135
--UNION ALL
--SELECT 118
--UNION ALL
--SELECT 123


IF ISNULL(@MostRecentDateInReportingTable,'19000101') <> CAST(CURRENT_TIMESTAMP AS DATE)
BEGIN
INSERT INTO rpt.TableLoadReport(
TableName, 
DateOfCurrentObservation, 
DateOfLastObservation, 
[RowCount], 
ChangeFromLastObservation, 
CurrentThreeSDLevel,
AsOf
)
SELECT 
t.TableName, 
lo.DateOfCurrentObservation, 
lo.DateOfLastObservation, 
lo.[RowCount], 
lo.ChangeFromLastObservation, 
lo.CurrentThreeSDLevel,
CAST(CURRENT_TIMESTAMP AS DATE)
FROM vol.Tables t
JOIN vol.LoadObservations lo
ON t.TableID = lo.TableID
WHERE lo.CurrentThreeSDLevel IS NOT NULL
AND t.TableID NOT IN (SELECT TableId FROM #UnWantedTables)
ORDER BY t.TableName, lo.DateOfCurrentObservation ASC
END

DROP TABLE #UnWantedTables

END
GO


