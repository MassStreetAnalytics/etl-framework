USE [FSA]
GO

/****** Object:  Table [dbo].[FactAssetPrices]    Script Date: 11/20/2017 11:49:12 PM ******/
DROP TABLE IF EXISTS [dbo].[FactAssetPrices]
GO

/****** Object:  Table [dbo].[FactAssetPrices]    Script Date: 11/20/2017 11:49:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ARITHABORT ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FactAssetPrices]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FactAssetPrices](
	[RowID] [bigint] IDENTITY(1,1) NOT NULL,
	[AssetsCK] [bigint] NOT NULL,
	[AsOfDate] [bigint] NOT NULL,
	[PriceOpen] [money] NULL,
	[PriceHigh] [money] NULL,
	[PriceLow] [money] NULL,
	[PriceClose] [money] NULL,
	[Volume] [bigint] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[SourceSystem] [nvarchar](50) NULL,
	[UniqueDims]  AS (CONVERT([varbinary](35),hashbytes('SHA1',concat(
	CONVERT([nvarchar](35),[AssetsCK],(0)),
	CONVERT([nvarchar](35),[AsOfDate],(0))
	)),(0))) PERSISTED,
	[UniqueRows]  AS (CONVERT([binary](16),hashbytes('MD5',concat(
	[PriceOpen],
	[PriceHigh],
	[PriceLow],
	[PriceClose],
	[Volume]
	)),(0))) PERSISTED,
 CONSTRAINT [PK_prices] PRIMARY KEY CLUSTERED 
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_FactAssetPrices] UNIQUE NONCLUSTERED 
(
	[UniqueDims] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

