-- =============================================
-- Author: Bob Wakefield
-- Create date: 20Oct20
-- Description: See a log of package run times.
-- Directions for use:
-- =============================================

USE [ODS]
GO


DROP VIEW IF EXISTS [dbo].[SSISPackageRunTime]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[SSISPackageRunTime] AS

SELECT 
pkg.PackageName,
pkglog.StartDateTime AS [Package Start Time],
CONVERT(TIME,pkglog.EndDateTime - pkglog.StartDateTime) AS [Run Time],
CASE pkglog.Status
WHEN 'S' THEN 'Success'
WHEN 'F' THEN 'Fail'
WHEN 'R' THEN 'Running'
END AS [Package Status]
FROM SSISManagement..PackageLog pkglog
JOIN SSISManagement..PackageVersion pkgvers 
ON pkglog.PackageVersionID = pkgvers.PackageVersionID
JOIN SSISManagement..Package pkg 
ON pkgvers.PackageID = pkg.PackageID

GO


