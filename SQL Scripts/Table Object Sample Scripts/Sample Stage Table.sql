/****** Object:  Table [eod].[EODPrices]    Script Date: 11/20/2017 11:54:22 PM ******/
DROP TABLE IF EXISTS [eod].[EODPrices]
GO

/****** Object:  Table [eod].[EODPrices]    Script Date: 11/20/2017 11:54:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[eod].[EODPrices]') AND type in (N'U'))
BEGIN
CREATE TABLE [eod].[EODPrices](
	[ETLKey] [uniqueidentifier] NOT NULL,
	[Symbol] [nvarchar](255) NULL,
	[Exchange] [nvarchar](255) NULL,
	[Date] [nvarchar](255) NULL,
	[Open] [nvarchar](255) NULL,
	[High] [nvarchar](255) NULL,
	[Low] [nvarchar](255) NULL,
	[Close] [nvarchar](255) NULL,
	[Volume] [nvarchar](255) NULL,
	[UniqueDims] [varbinary](35) NULL,
	[UniqueRows] [varbinary](16) NULL,
	[SourceSystem] [nvarchar](255) NULL,
	[ErrorRecord] [bit] NULL,
	[Processed] [bit] NULL,
	[RunDate] [datetime] NULL,
 CONSTRAINT [PK_EODPrices] PRIMARY KEY CLUSTERED 
(
	[ETLKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[eod].[DF_EODPrices_ETLKey]') AND type = 'D')
BEGIN
ALTER TABLE [eod].[EODPrices] ADD  CONSTRAINT [DF_EODPrices_ETLKey]  DEFAULT (newid()) FOR [ETLKey]
END

GO


