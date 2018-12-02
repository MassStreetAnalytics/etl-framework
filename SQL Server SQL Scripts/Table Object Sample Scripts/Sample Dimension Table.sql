/****** Object:  Table [dbo].[DimYourDimensionName]    Script Date: 11/20/2017 11:46:19 PM ******/
DROP TABLE IF EXISTS [dbo].[DimYourDimensionName]
GO

/****** Object:  Table [dbo].[DimYourDimensionName]    Script Date: 11/20/2017 11:46:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DimYourDimensionName]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DimYourDimensionName](
	[YourDimensionNameCK] [bigint] IDENTITY(1,1) NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[SourceSystem] [nvarchar](100) NULL,
	[SourceSystemKey] [nvarchar](100) NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL,
	[IsMostRecentRecord] [bit] NULL,
	--for junk dimensions
	[RowHash]  AS (CONVERT([varbinary](16),hashbytes('MD5',concat(
	CONVERT([nvarchar](35),Column1,0),
	CONVERT([nvarchar](35),Column2,0),
	CONVERT([nvarchar](35),Column3,0),
	CONVERT([nvarchar](35),Column4,0),
	CONVERT([nvarchar](35),Column5,0),
	CONVERT([nvarchar](35),Column6,0))),0)) PERSISTED,
 CONSTRAINT [PK_YourDimension] PRIMARY KEY CLUSTERED 
(
	[YourDimensionNameCK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


