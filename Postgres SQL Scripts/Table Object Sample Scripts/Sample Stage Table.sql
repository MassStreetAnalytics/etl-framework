/****** Object:  Table YourSchemaName.YourStageTableName    Script Date: 11/20/2017 11:54:22 PM ******/
DROP TABLE IF EXISTS YourSchemaName.YourStageTableName
GO

/****** Object:  Table YourSchemaName.YourStageTableName    Script Date: 11/20/2017 11:54:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'YourSchemaName.YourStageTableName') AND type in (N'U'))
BEGIN
CREATE TABLE YourSchemaName.YourStageTableName(
	[ETLKey] [uniqueidentifier] NOT NULL,
	[UniqueDims] [varbinary](35) NULL,
	[UniqueRows] [varbinary](16) NULL,
	[SourceSystem] [nvarchar](255) NULL,
	[ErrorRecord] [bit] NULL,
	[Processed] [bit] NULL,
	[RunDate] [datetime] NULL,
 CONSTRAINT [PK_YourStageTableName] PRIMARY KEY CLUSTERED 
(
	[ETLKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[eod].[DF_YourStageTableName_ETLKey]') AND type = 'D')
BEGIN
ALTER TABLE YourSchemaName.YourStageTableName ADD  CONSTRAINT [DF_YourStageTableName_ETLKey]  DEFAULT (newid()) FOR [ETLKey]
END

GO


