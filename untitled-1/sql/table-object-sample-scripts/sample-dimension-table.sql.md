# sample dimension table

Description: This is a sample basic dimension table. This is to be used for non-junk dimension dimensions. There is a separate example for junk dimensions.

Necessary Modification: 

1. Replace YourEDW with the name for  your specific data warehouse. 
2. Replace YourDimensionName with the name of your dimension. 
3. Then fill in your columns on line 14.

```text
USE [YourEDW]

DROP TABLE IF EXISTS [dw].[DimYourDimensionName]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dw].[DimYourDimensionName](
	[YourDimensionNameCK] [bigint] IDENTITY(1,1) NOT NULL,
	--your columns here.
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[SourceSystem] [nvarchar](100) NULL,
	[SourceSystemKey] [nvarchar](100) NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL,
	[IsMostRecentRecord] [bit] NULL
 CONSTRAINT [PK_YourDimensionName] PRIMARY KEY CLUSTERED 
(
	[YourDimensionNameCK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
 
 GO


DROP INDEX IF EXISTS [NCIDX_DimYourDimensionName_SourceSystemKey] ON [dw].[DimYourDimensionName]
GO


CREATE NONCLUSTERED INDEX [NCIDX_DimYourDimensionName_SourceSystemKey] ON [dw].[DimYourDimensionName]
(
	[SourceSystemKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

```

