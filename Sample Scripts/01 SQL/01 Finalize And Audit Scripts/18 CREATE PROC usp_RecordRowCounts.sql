-- =============================================
-- Author: Bob Wakefield
-- Create date: 15Oct17
-- Description: Records how many records each fact table is getting loaded with.
-- =============================================
USE ODS

DROP PROCEDURE IF EXISTS usp_RecordRowCounts

GO

CREATE PROCEDURE usp_RecordRowCounts AS
BEGIN


--
BEGIN TRANSACTION

CREATE TABLE #counts(table_name nvarchar(255), row_count int)
CREATE TABLE #date_of_last_observations(table_id INT, row_count INT, date_of_last_observation DATETIME)

--Change [YourDataWarehouse] to the name of your EDW database.
EXEC [YourDataWarehouse]..sp_MSForEachTable @command1='INSERT #counts (table_name, row_count) SELECT REPLACE(SUBSTRING(''?'',8,LEN(''?'')),'']'',''''), COUNT(*) FROM ?'

--SELECT *
--FROM #counts


MERGE vol.Tables as target
USING(
SELECT table_name, CURRENT_TIMESTAMP AS date_measured, row_count 
FROM #counts 
) AS source
ON source.table_name COLLATE DATABASE_DEFAULT = target.table_name COLLATE DATABASE_DEFAULT

WHEN NOT MATCHED THEN
INSERT ([table_name],[date_created])
VALUES (source.table_name, CURRENT_TIMESTAMP);


INSERT INTO #date_of_last_observations(table_id,date_of_last_observation)
SELECT [table_id], MAX([date_of_current_observation]) AS date_of_last_observation 
FROM vol.LoadObservations
GROUP BY [table_id]

;
WITH previous_observations(date_of_last_observation, last_row_count, table_id)
AS(
SELECT lo.[date_of_current_observation], lo.[row_count], lo.table_id
FROM vol.LoadObservations lo
JOIN #date_of_last_observations llo
ON lo.[date_of_current_observation] = llo.date_of_last_observation
AND lo.[table_id] = llo.table_id
),
current_sd_level(table_id, current_three_sd_level)
AS(
SELECT table_id, STDEV(change_from_last_observation) * 3
FROM vol.LoadObservations
GROUP BY table_id
)
INSERT [load_observations](table_id, date_of_current_observation, date_of_last_observation, row_count, change_from_last_observation, current_three_sd_level)
SELECT t.table_id, CURRENT_TIMESTAMP AS date_of_current_observation, po.date_of_last_observation, c.row_count, ABS(c.row_count - po.last_row_count), ABS(sd.current_three_sd_level)
FROM #counts c 
JOIN vol.Tables t
ON c.table_name = t.table_name
LEFT OUTER JOIN previous_observations po
ON  t.table_id = po.table_id
LEFT OUTER JOIN current_sd_level sd
ON t.table_id = sd.table_id


COMMIT TRANSACTION


DROP TABLE #counts
DROP TABLE #date_of_last_observations
