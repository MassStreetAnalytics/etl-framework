-- =============================================
-- Author:
-- Create date:
-- Description:
-- Usage: 
-- =============================================

USE [ODS]
GO


DROP PROCEDURE [dbo].[usp_CleanYourStageTableNameData]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_CleanYourStageTableNameData] 
AS
BEGIN

BEGIN TRANSACTION


--Convert the rest of the dates into YYYYMMDD format
UPDATE [YourSchemaName].[YourStageTableNameData]
SET [YourDateColumn] = udf_CleanDate([Date])

--Remove CR from volume data
UPDATE [YourSchemaName].[YourStageTableNameData]
SET YourColumn = REPLACE(YourColumn, CHAR(13) + CHAR(10), '')

UPDATE [YourSchemaName].[YourStageTableNameData]
SET [YourJoinColumn] = ''
WHERE [YourJoinColumn] IS NULL


UPDATE [YourSchemaName].[YourStageTableNameData]
SET Cleansed = 1





COMMIT TRANSACTION

END



GO


