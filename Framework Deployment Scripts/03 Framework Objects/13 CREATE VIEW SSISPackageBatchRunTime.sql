-- =============================================
-- Author: Bob Wakefield
-- Create date: 20Oct20
-- Description: SSIS Run times by batch.
-- Directions for use:
-- =============================================

USE [ODS]
GO


DROP VIEW IF EXISTS [dbo].[SSISPackageBatchRunTime]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[SSISPackageBatchRunTime] AS

SELECT 
BL.BatchLogID AS [Batch ID],
CONVERT(TIME,BL.EndDateTime - BL.StartDateTime) AS [Run Time],
CASE [BL].[Status]
WHEN 'S' THEN 'Success'
WHEN 'F' THEN 'Fail'
WHEN 'R' THEN 'Running'
END AS [Batch Status]
FROM [SSISManagement]..BatchLog BL

GO


