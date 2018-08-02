USE [ODS]
GO

/****** Object:  View [dbo].[v_ShowAdverseTableLoads]    Script Date: 3/29/2018 12:37:43 PM ******/
DROP VIEW [dbo].[v_ShowAdverseTableLoads]
GO

/****** Object:  View [dbo].[v_ShowAdverseTableLoads]    Script Date: 3/29/2018 12:37:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[v_ShowAdverseTableLoads] AS

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


