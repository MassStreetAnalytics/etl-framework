USE [ODS]
GO

/****** Object:  View [dbo].[v_SSISPackageBatchRunTime]    Script Date: 3/29/2018 12:38:34 PM ******/
DROP VIEW [dbo].[v_SSISPackageBatchRunTime]
GO

/****** Object:  View [dbo].[v_SSISPackageBatchRunTime]    Script Date: 3/29/2018 12:38:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[v_SSISPackageBatchRunTime] AS

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


