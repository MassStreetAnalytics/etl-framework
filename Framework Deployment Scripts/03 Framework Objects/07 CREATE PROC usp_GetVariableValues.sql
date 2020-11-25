-- =============================================
-- Author: Bob Wakefield
-- Create date: 28May14
-- Description: Find the variables and their values 
-- that are currently being used for package configuration.
-- Directions for use: Pass in a package name without the file extension.
-- =============================================

USE SSISManagement
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS usp_GetVariableValues

GO

CREATE PROC usp_GetVariableValues @packageName NVARCHAR(255)
AS
SELECT VariableName, VariableValue
FROM SSISConfigurations
WHERE PackageName = @packageName


