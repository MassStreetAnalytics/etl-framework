-- =============================================
-- Author:
-- Create date:
-- Description:
-- Directions for use:
-- Replace YourSchemaName with the schema for your stage table.
-- YourStageTableName with the name of your staging table.
-- Drop your columns in row 16.
-- Replace DatabaseName with the name of the source system.
-- =============================================
USE ODS

DROP TABLE IF EXISTS YourSchemaName.YourStageTableNameData
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE YourSchemaName.YourStageTableNameData(
[ETLKey] [uniqueidentifier] NOT NULL,
--your columns here.
[UniqueDims] [varbinary](35) NULL,
[UniqueRows] [varbinary](16) NULL,
[SourceSystem] [nvarchar](255) NULL,
[Cleansed] [bit] NULL,
[ErrorRecord] [bit] NULL,
[ErrorReason] [nvarchar](255) NULL,
[Processed] [bit] NULL,
[RunDate] [datetime] NULL,
 CONSTRAINT [PK_YourStageTableNameData] PRIMARY KEY CLUSTERED 
(
       [ETLKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_ETLKey]  DEFAULT (newid()) FOR [ETLKey]
GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_SourceSystem]  DEFAULT (N'DatabaseName') FOR [SourceSystem]
GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_Cleansed]  DEFAULT ((0)) FOR [Cleansed]
GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_ErrorRecord]  DEFAULT ((0)) FOR [ErrorRecord]
GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_Processed]  DEFAULT ((0)) FOR [Processed]
GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_RunDate]  DEFAULT (getdate()) FOR [RunDate]
GO



