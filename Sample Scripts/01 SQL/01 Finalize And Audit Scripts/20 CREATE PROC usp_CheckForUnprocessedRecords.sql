-- =============================================
-- Author: Bob Wakefield
-- Create date: 15Oct17
-- Description: Check Stage Tables for unprocessed records.
-- =============================================


USE ODS
GO

DROP PROCEDURE IF EXISTS dbo.usp_CheckForUnprocessedRecords
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.usp_CheckForUnprocessedRecords
AS
BEGIN

--Update with your operator name.
DECLARE @OperatorName sysname = N'YourOperatorName';

DECLARE @OperatorEmailAddress NVARCHAR(100) = (SELECT email_address FROM msdb.dbo.sysoperators WHERE [name] = @OperatorName);


--Check for unprocessed records
SELECT *
FROM [eod].[Assets]
WHERE Processed = 0


IF @@RowCount > 0
BEGIN
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'Monitoring',
@recipients = @OperatorEmailAddress,
@subject = 'Unprocessed Records Exist',
@body = 'There are unprocessed records in the Assets Staging Table' ;
END

SELECT *
FROM [eod].[EODPrices]
WHERE Processed = 0

IF @@RowCount > 0
BEGIN
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'Monitoring',
@recipients = @OperatorEmailAddress,
@subject = 'Unprocessed Records Exist',
@body = 'There are unprocessed records in the EOD Prices Staging Table' ;
END

SELECT *
FROM [eod].[Exchanges]
WHERE Processed = 0


IF @@RowCount > 0
BEGIN
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'Monitoring',
@recipients = @OperatorEmailAddress,
@subject = 'Unprocessed Records Exist',
@body = 'There are unprocessed records in the Exchanges staging table.' ;
END


END
GO
