-- =============================================
-- Author: Bob Wakefield
-- Create date: 28May14
-- Description: Lets you know how long a package ran for
-- Directions for use:Pass in a package name without the file extension.
-- =============================================

USE SSISManagement


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PackageRunTime') AND type in (N'P', N'PC'))
DROP PROCEDURE IF EXISTS usp_PackageRunTime
GO

CREATE PROCEDURE usp_PackageRunTime (@PackageName VARCHAR(MAX))
AS
BEGIN
SET NOCOUNT ON


SELECT 
pkg.PackageName,
pkglog.StartDateTime AS [Package Start Time],
CONVERT(TIME,pkglog.EndDateTime - pkglog.StartDateTime) AS [Run Time],
CASE pkglog.Status
WHEN 'S' THEN 'Success'
WHEN 'F' THEN 'Fail'
WHEN 'R' THEN 'Running'
END AS [Package Status]
FROM dbo.PackageLog pkglog
JOIN dbo.PackageVersion pkgvers 
ON pkglog.PackageVersionID = pkgvers.PackageVersionID
JOIN dbo.Package pkg 
ON pkgvers.PackageID = pkg.PackageID
WHERE pkg.PackageName = @PackageName
ORDER BY pkglog.StartDateTime DESC

END