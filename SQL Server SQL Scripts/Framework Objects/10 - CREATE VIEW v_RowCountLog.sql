USE [ODS]
GO

/****** Object:  View [dbo].[v_RowCountLog]    Script Date: 3/29/2018 12:36:51 PM ******/
DROP VIEW [dbo].[v_RowCountLog]
GO

/****** Object:  View [dbo].[v_RowCountLog]    Script Date: 3/29/2018 12:36:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[v_RowCountLog] 
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


