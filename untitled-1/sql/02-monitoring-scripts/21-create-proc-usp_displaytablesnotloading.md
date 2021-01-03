# 21 CREATE PROC usp\_DisplayTablesNotLoading

Description: This proc can be ran to display what tables are not loading. It can be used as part of troubleshooting.

Necessary Modification: There are some tables you do not want to monitor for various reasons. To remove these tables from the results set, get their table ID from vol.Tables and insert them into the UnwantedTables temporary table.

```text
--Manually get rid of unwanted tables.
INSERT INTO #UnWantedTables(TableID)
SELECT 131
```

```text
USE [ODS]
GO


DROP PROCEDURE IF EXISTS [dbo].[usp_DisplayTablesNotLoading]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DisplayTablesNotLoading] AS
BEGIN

CREATE TABLE #UnWantedTables(TableID BIGINT)
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

--Manually get rid of unwanted tables.
--INSERT INTO #UnWantedTables(TableID)
--SELECT 131



SELECT TableID, [TableName]
FROM  [vol].[Tables]
WHERE TableID IN (
SELECT t.TableID
FROM [vol].[Tables] t
JOIN [vol].[LoadObservations] lo
ON t.TableID = lo.TableID
WHERE t.TableID NOT IN (SELECT TableID FROM #UnWantedTables)
AND lo.DateOfCurrentObservation BETWEEN DATEADD(DD,-3,CURRENT_TIMESTAMP) AND CURRENT_TIMESTAMP
GROUP BY t.TableID
HAVING AVG(CAST(lo.ChangeFromLastObservation AS FLOAT)) = 0
)

DROP TABLE #UnWantedTables

END




GO
```

