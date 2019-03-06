/****** Object:  Table [dbo].[YourFactTableName]    Script Date: 11/20/2017 11:49:12 PM ******/
DROP TABLE IF EXISTS [dbo].[YourFactTableName]
GO

/****** Object:  Table [dbo].[YourFactTableName]    Script Date: 11/20/2017 11:49:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ARITHABORT ON
GO

CREATE TABLE [dbo].[YourFactTableName](
	[RowID] [bigint] IDENTITY(1,1) NOT NULL,
	--dimension keys
	[TransactionID] NVARCHAR(100) NULL,
	--facts
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[SourceSystem] [nvarchar](50) NULL,
	[UniqueDims]  AS (CONVERT([varbinary](35),hashbytes('SHA1',concat(
	CONVERT([nvarchar](35),[DimKey1CK],(0)),
	CONVERT([nvarchar](35),[DimKey2CK],(0))
	)),(0))) PERSISTED,
 CONSTRAINT [PK_prices] PRIMARY KEY CLUSTERED 
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_YourFactTableName] UNIQUE NONCLUSTERED 
(
	[UniqueDims] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END


