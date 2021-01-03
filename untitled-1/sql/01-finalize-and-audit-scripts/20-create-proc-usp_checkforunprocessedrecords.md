# 20 CREATE PROC usp\_CheckForUnprocessedRecords

Description: Check Stage Tables for unprocessed records.

Necessary Modification: Every fact table load you build will need code added to the stored procedure so it becomes part of the audit process. Loading dimensions isn't normally problematic so they are not part of this process.

Before each alert, you need to run a select on a staging table checking for unprocessed records. Then alter the message that message that gets sent based on the staging table being checked.

 Below is an example.

```text
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
```

```text
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

```

