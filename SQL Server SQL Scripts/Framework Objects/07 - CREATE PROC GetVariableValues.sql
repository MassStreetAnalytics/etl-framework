USE SSISManagement
GO

/****** Object:  StoredProcedure [dbo].[spGetVariableValues]    Script Date: 1/28/2016 2:25:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[GetVariableValues] @packageName NVARCHAR(255)
AS
SELECT VariableName, VariableValue
FROM SSISConfigurations
WHERE PackageName = @packageName


