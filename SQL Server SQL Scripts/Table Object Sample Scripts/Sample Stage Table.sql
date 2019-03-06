/****** Object:  Table YourSchemaName.YourStageTableName    Script Date: 11/20/2017 11:54:22 PM ******/
DROP TABLE IF EXISTS YourSchemaName.YourStageTableName
GO

/****** Object:  Table YourSchemaName.YourStageTableName    Script Date: 11/20/2017 11:54:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE YourSchemaName.YourStageTableName(
	[ETLKey] [uniqueidentifier] NOT NULL,
	[UniqueDims] [varbinary](35) NULL,
	[UniqueRows] [varbinary](16) NULL,
	[SourceSystem] [nvarchar](255) NULL,
	[Cleansed] [bit] NULL,
	[ErrorRecord] [bit] NULL,
	[Processed] [bit] NULL,
	[RunDate] [datetime] NULL,
 CONSTRAINT [PK_YourStageTableName] PRIMARY KEY CLUSTERED 
(
       [ETLKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [YourSchemaName].[YourStageTableName] ADD  CONSTRAINT [DF_YourStageTableName_ETLKey]  DEFAULT (newid()) FOR [ETLKey]
GO

ALTER TABLE [YourSchemaName].[YourStageTableName] ADD  CONSTRAINT [DF_YourStageTableName_SourceSystem]  DEFAULT (N'Copia') FOR [SourceSystem]
GO

ALTER TABLE [YourSchemaName].[YourStageTableName] ADD  CONSTRAINT [DF_YourStageTableName_Cleansed]  DEFAULT ((0)) FOR [Cleansed]
GO

ALTER TABLE [YourSchemaName].[YourStageTableName] ADD  CONSTRAINT [DF_YourStageTableName_ErrorRecord]  DEFAULT ((0)) FOR [ErrorRecord]
GO

ALTER TABLE [YourSchemaName].[YourStageTableName] ADD  CONSTRAINT [DF_YourStageTableName_Processed]  DEFAULT ((0)) FOR [Processed]
GO

ALTER TABLE [YourSchemaName].[YourStageTableName] ADD  CONSTRAINT [DF_YourStageTableName_RunDate]  DEFAULT (getdate()) FOR [RunDate]
GO



