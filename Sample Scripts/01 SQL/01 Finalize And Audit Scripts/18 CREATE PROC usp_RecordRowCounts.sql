-- =============================================
-- Author: Bob Wakefield
-- Create date: 15Oct17
-- Description: Records how many records each fact table is getting loaded with.
--Change Log:
--21Aug21 Updated for use with SQL Server 2019 BW
-- =============================================
USE ODS

DROP PROCEDURE IF EXISTS usp_RecordRowCounts

GO

CREATE PROCEDURE usp_RecordRowCounts AS
BEGIN


--
BEGIN TRANSACTION

DROP TABLE IF EXISTS #counts
DROP TABLE IF EXISTS #DateOfLastObservations


CREATE TABLE #counts(TableName nvarchar(255), [RowCount] int)
CREATE TABLE #DateOfLastObservations(TableID INT, [RowCount] INT, DateOfLastObservation DATETIME)

--Change [YourDataWarehouse] to the name of your EDW database.
EXEC [DVDRentalDW]..sp_MSforeachtable @command1='INSERT #counts (TableName, [RowCount]) SELECT REPLACE(SUBSTRING(''?'',8,LEN(''?'')),'']'',''''), COUNT(*) FROM ?'

--SELECT *
--FROM #counts


MERGE vol.Tables as target
USING(
SELECT TableName, CURRENT_TIMESTAMP AS date_measured, [RowCount] 
FROM #counts 
) AS source
ON source.TableName COLLATE DATABASE_DEFAULT = target.TableName COLLATE DATABASE_DEFAULT

WHEN NOT MATCHED THEN
INSERT ([TableName],[DateCreated])
VALUES (source.TableName, CURRENT_TIMESTAMP);


INSERT INTO #DateOfLastObservations(TableID,DateOfLastObservation)
SELECT [TableID], MAX([DateOfCurrentObservation]) AS DateOfLastObservation 
FROM vol.LoadObservations
GROUP BY [TableID]

;
WITH previous_observations(DateOfLastObservation, last_RowCount, TableID)
AS(
SELECT lo.[DateOfCurrentObservation], lo.[RowCount], lo.TableID
FROM vol.LoadObservations lo
JOIN #DateOfLastObservations llo
ON lo.[DateOfCurrentObservation] = llo.DateOfLastObservation
AND lo.[TableID] = llo.TableID
),
current_sd_level(TableID, current_three_sd_level)
AS(
SELECT TableID, STDEV(ChangeFromLastObservation) * 3
FROM vol.LoadObservations
GROUP BY TableID
)
INSERT vol.[LoadObservations](TableID, DateOfCurrentObservation, DateOfLastObservation, [RowCount], ChangeFromLastObservation, [CurrentThreeSDLevel])
SELECT t.TableID, CURRENT_TIMESTAMP AS DateOfCurrentObservation, po.DateOfLastObservation, c.[RowCount], ABS(c.[RowCount] - po.last_RowCount), ABS(sd.current_three_sd_level)
FROM #counts c 
JOIN vol.Tables t
ON c.TableName COLLATE DATABASE_DEFAULT = t.TableName COLLATE DATABASE_DEFAULT
LEFT OUTER JOIN previous_observations po
ON  t.TableID = po.TableID
LEFT OUTER JOIN current_sd_level sd
ON t.TableID = sd.TableID


COMMIT TRANSACTION


DROP TABLE #counts
DROP TABLE #DateOfLastObservations

END
