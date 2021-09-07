-- =============================================
-- Author:
-- Create date:
-- Description:
-- Directions for use: Add the PK columns of the dimensions
-- that are attached to the fact table, then add your measures
-- and degenerate dimensions. Add the dimension keys to the UniqueDims hash.
-- Add unique rows if necessary.
-- =============================================

USE YourEDW

DROP TABLE IF EXISTS [dw].[FactYourFactTableName]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ARITHABORT ON
GO

CREATE TABLE [dw].[FactYourFactTableName](
	[RowID] [bigint] IDENTITY(1,1) NOT NULL,
	--dimension keys
	[TransactionID] NVARCHAR(100) NULL,
	--your columns.
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[SourceSystem] [nvarchar](50) NULL,
	[UniqueDims]  AS (CONVERT([varbinary](35),hashbytes('SHA1',concat(
	CONVERT([nvarchar](35),[DimKey1CK],(0)),
	CONVERT([nvarchar](35),[DimKey2CK],(0)),
	CONVERT([nvarchar](35),[TransactionID],(0))
	)),(0))) PERSISTED,
	--unique rows is optional
	[UniqueRows]  AS (CONVERT([varbinary](35),hashbytes('SHA1',concat(
	CONVERT([nvarchar](35),[Column1],(0)),
	CONVERT([nvarchar](35),[Column2],(0))
	)),(0))) PERSISTED,
 CONSTRAINT [PK_FactYourFactTableName] PRIMARY KEY CLUSTERED 
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_FactYourFactTableName] UNIQUE NONCLUSTERED 
(
	[UniqueDims] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--index is optional
DROP INDEX IF EXISTS [NCIDX_FactYourFactTableName_UniqueDims] ON [dw].[FactYourFactTableName]
GO


CREATE NONCLUSTERED INDEX [NCIDX_FactYourFactTableName_UniqueDims] ON [dw].[FactYourFactTableName]
(
	[UniqueDims] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

--index is optional
DROP INDEX IF EXISTS [NCIDX_FactYourFactTableName_UniqueRows] ON [dw].[FactYourFactTableName]
GO


CREATE NONCLUSTERED INDEX [NCIDX_FactYourFactTableName_UniqueRows] ON [dw].[FactYourFactTableName]
(
	[UniqueRows] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO