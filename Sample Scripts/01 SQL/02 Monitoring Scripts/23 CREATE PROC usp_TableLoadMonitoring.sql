-- =============================================
-- Author: Bob Wakefield
-- Create date: 7April16
-- Description: Checks to see if anything weird is 
-- going on with the tables loads and sends an alert
-- when something strange is found.
-- Script looks for unusual load amounts
-- and tables not being loaded.
-- 21Dec16: Updated to take into account larger record counts
-- Int datatype was too small.
-- =============================================

USE [ODS]
GO


DROP PROCEDURE IF EXISTS [dbo].[usp_TableLoadMonitoring]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TableLoadMonitoring] AS
BEGIN

--Update with your operator name.
DECLARE @OperatorName sysname = N'YourOperatorName';

DECLARE @OperatorEmailAddress NVARCHAR(100) = (SELECT email_address FROM msdb.dbo.sysoperators WHERE [name] = @OperatorName);

CREATE TABLE #UnWantedTables(TableID INT)
CREATE CLUSTERED INDEX CIDX_UNWANTEDTABLES_TABLEID ON #UnWantedTables(TableID)

DECLARE @MostRecentDate DATETIME

SELECT @MostRecentDate =  MAX(DateOfCurrentObservation) FROM [vol].[LoadObservations]

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
HAVING AVG(lo.CurrentThreeSDLevel) = 0

--Find Adverse Loads
SELECT t.TableID
FROM [vol].[Tables] t
JOIN [vol].[LoadObservations] lo
ON t.TableID = lo.TableID
WHERE t.TableID NOT IN (SELECT TableID FROM #UnWantedTables)
AND lo.DateOfCurrentObservation = @MostRecentDate
AND lo.ChangeFromLastObservation > lo.CurrentThreeSDLevel
--ORDER BY t.TableName

IF @@RowCount > 0
BEGIN
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'Monitoring',
@recipients = @OperatorEmailAddress,
@subject = 'Adverse Load Event',
@body = 'One or more tables in the warehouse has experienced an anomalous load event. Check v_ShowAdverseTableLoads in the ODS database.' ;
END

--Remove Rarely loaded tables from 0 load analysis
--INSERT INTO #UnWantedTables(TableID)
--SELECT 135
--UNION ALL
--SELECT 131
--UNION ALL
--SELECT 118
--UNION ALL
--SELECT 123



--Find tables not being loaded
SELECT t.TableID
FROM [vol].[Tables] t
JOIN [vol].[LoadObservations] lo
ON t.TableID = lo.TableID
WHERE t.TableID NOT IN (SELECT TableID FROM #UnWantedTables)
AND lo.DateOfCurrentObservation BETWEEN DATEADD(DD,-3,CURRENT_TIMESTAMP) AND CURRENT_TIMESTAMP
GROUP BY t.TableID
HAVING AVG(CAST(lo.ChangeFromLastObservation AS FLOAT)) = 0 


IF @@RowCount > 0
BEGIN
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'Monitoring',
@recipients = @OperatorEmailAddress,
@subject = 'Adverse Load Event',
@body = 'One or more tables in the warehouse have experienced three straight days of loading zero records. Run sp_DisplayTablesNotLoading in ODS database.';
END

DROP TABLE #UnWantedTables

END
GO


