-- =============================================
-- Author: Bob Wakefield
-- Create date: 20Oct20
-- Description: Show tables with anomalous data loads. 
-- Directions for use:
-- =============================================
USE [ODS]
GO


DROP VIEW IF EXISTS [dbo].[ShowAdverseTableLoads]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[ShowAdverseTableLoads] AS

--Find Adverse Loads
SELECT t.TableID, t.TableName, lo.[RowCount] AS [Records In Table], lo.ChangeFromLastObservation AS [Records Loaded], lo.CurrentThreeSDLevel AS [Current Three Standard Deviation Level]
FROM ODS.[vol].[Tables] t
JOIN ODS.[vol].[LoadObservations] lo
ON t.TableID = lo.TableID
WHERE t.TableID NOT IN(
--Get rid of tables with no records
SELECT t.TableID
FROM ODS.[vol].[Tables] t
JOIN ODS.[vol].[LoadObservations] lo
ON t.TableID = lo.TableID
GROUP BY t.TableID
HAVING AVG(lo.[RowCount]) = 0
UNION
--Get rid of tables with no load variance
SELECT t.TableID
FROM ODS.[vol].[Tables] t
JOIN ODS.[vol].[LoadObservations] lo
ON t.TableID = lo.TableID
GROUP BY t.TableID
HAVING AVG(lo.CurrentThreeSDLevel) = 0
)
AND lo.DateOfCurrentObservation =  (SELECT MAX(DateOfCurrentObservation) FROM ODS.[vol].[LoadObservations])
AND lo.ChangeFromLastObservation > lo.CurrentThreeSDLevel


GO


