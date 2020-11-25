-- =============================================
-- Author: Bob Wakefield
-- Create date: 28May14
-- Description: This allows you to see the performance of a 
-- specific package by passing in the package name as a parameter.
-- Directions for use: Pass in a package name without the extension.
-- =============================================

USE SSISManagement


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ErrorLogByPackage') AND type in (N'P', N'PC'))
DROP PROCEDURE IF EXISTS usp_ErrorLogByPackage
GO

CREATE PROCEDURE usp_ErrorLogByPackage (@PackageName VARCHAR(MAX))
AS
BEGIN
SET NOCOUNT ON


SELECT BL.BatchLogID AS [Batch Log ID], 
P.PackageName AS [Package Name], 
PEL.SourceName AS [Task Name], 
PEL.ErrorDescription AS [Error Description], 
PEL.LogDateTime AS [Log Date Time]
FROM PackageErrorLog PEL
JOIN PackageLog PL
ON PEL.PackageLogID = PL.PackageLogID 
JOIN PackageVersion PV
ON PL.PackageVersionID = PV.PackageVersionID 
JOIN Package P
ON PV.PackageID = P.PackageID
JOIN BatchLog BL
ON PL.BatchLogID = BL.BatchLogID
WHERE P.PackageName = @PackageName
ORDER BY PEL.LogDateTime Desc

END