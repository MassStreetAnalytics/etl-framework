/*
Author: Bob Wakefield
Create date: 28May14
Description: Lets you know how long a batch ran for
*/

USE SSISManagement


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'BatchRunTime') AND type in (N'P', N'PC'))
DROP PROCEDURE BatchRunTime
GO

CREATE PROCEDURE BatchRunTime (@BatchID INT)
AS
BEGIN
SET NOCOUNT ON


SELECT 
BL.BatchLogID AS [Batch ID],
CONVERT(TIME,BL.EndDateTime - BL.StartDateTime) AS [Run Time],
[BL].[Status]
FROM BatchLog BL

WHERE BL.BatchLogID = @BatchID

END