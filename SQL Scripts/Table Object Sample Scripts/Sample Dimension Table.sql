/****** Object:  Table [dbo].[DimExchanges]    Script Date: 11/20/2017 11:46:19 PM ******/
DROP TABLE IF EXISTS [dbo].[DimExchanges]
GO

/****** Object:  Table [dbo].[DimExchanges]    Script Date: 11/20/2017 11:46:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DimExchanges]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DimExchanges](
	[ExchangesCK] [bigint] IDENTITY(1,1) NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[SourceSystem] [nvarchar](100) NULL,
	[SourceSystemKey] [nvarchar](100) NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL,
	[IsMostRecentRecord] [bit] NULL,
	[RowHash]  AS (CONVERT([varbinary](16),hashbytes('MD5',concat(
	CONVERT([nvarchar](35),[Name],0),
	CONVERT([nvarchar](35),[IsIntraday],0),
	CONVERT([nvarchar](35),[TimeZone],0),
	CONVERT([nvarchar](35),[Suffix],0),
	CONVERT([nvarchar](35),[Currency],0),
	CONVERT([nvarchar](35),[Country],0))),0)) PERSISTED,
 CONSTRAINT [PK_exchanges] PRIMARY KEY CLUSTERED 
(
	[ExchangesCK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


