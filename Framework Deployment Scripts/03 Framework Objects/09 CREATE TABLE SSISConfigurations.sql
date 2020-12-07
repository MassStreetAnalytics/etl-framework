-- =============================================
-- Author: Bob Wakefield
-- Create date: 20Oct20
-- Description: Creates the table that holds the configuration values for SSIS packages. 
-- Directions for use: Simply run the script.
-- =============================================

USE [SSISManagement]
GO



DROP TABLE IF EXISTS [dbo].[SSISConfigurations]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSISConfigurations]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SSISConfigurations](
[ProcessConfigurationID] [int] IDENTITY(1,1) NOT NULL,
[PackageName] [nvarchar](255) NOT NULL,
[VariableName] [nvarchar](255) NOT NULL,
[VariableValue] [nvarchar](255) NOT NULL,
CONSTRAINT [PK_ProcessConfiguration] PRIMARY KEY CLUSTERED 
(
[ProcessConfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


