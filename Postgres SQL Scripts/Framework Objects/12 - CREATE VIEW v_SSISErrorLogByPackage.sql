USE [ODS]
GO

/****** Object:  View [dbo].[v_SSISErrorLogByPackage]    Script Date: 3/29/2018 12:38:05 PM ******/
DROP VIEW [dbo].[v_SSISErrorLogByPackage]
GO

/****** Object:  View [dbo].[v_SSISErrorLogByPackage]    Script Date: 3/29/2018 12:38:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[v_SSISErrorLogByPackage] AS

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


