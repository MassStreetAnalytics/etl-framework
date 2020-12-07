-- =============================================
-- Author: Bob Wakefield
-- Create date: 20Oct20
-- Description: SSIS Errors By Package
-- Directions for use:
-- =============================================

USE [ODS]
GO


DROP VIEW IF EXISTS [dbo].[SSISErrorLogByPackage]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[SSISErrorLogByPackage] AS

SELECT BL.BatchLogID AS [Batch Log ID], 
P.PackageName AS [Package Name], 
PEL.SourceName AS [Task Name], 
PEL.ErrorDescription AS [Error Description], 
PEL.LogDateTime AS [Log Date Time]
FROM [SSISManagement]..PackageErrorLog PEL
JOIN [SSISManagement]..PackageLog PL
ON PEL.PackageLogID = PL.PackageLogID 
JOIN [SSISManagement]..PackageVersion PV
ON PL.PackageVersionID = PV.PackageVersionID 
JOIN [SSISManagement]..Package P
ON PV.PackageID = P.PackageID
JOIN [SSISManagement]..BatchLog BL
ON PL.BatchLogID = BL.BatchLogID

GO


