-- =============================================
-- Author: Bob Wakefield
-- Create date: 20Oct20
-- Description: A simple log of the amount of records that get processed in each load.
-- Directions for use:
-- =============================================

USE [ODS]
GO


DROP VIEW IF EXISTS [dbo].[RowCountLog]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[RowCountLog] 
AS

SELECT 
[TableName],
[DateOfCurrentObservation],
[DateOfLastObservation],
[RowCount],
[ChangeFromLastObservation],
[CurrentThreeSDLevel]
FROM [vol].[Tables] t
JOIN [vol].[LoadObservations] lo
ON t.TableID = lo.TableID
GO


