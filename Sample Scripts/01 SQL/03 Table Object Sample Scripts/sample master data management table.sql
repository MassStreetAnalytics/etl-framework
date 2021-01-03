-- =============================================
-- Author:
-- Create date:
-- Description:
-- Directions for use:
-- 1. Replace YourDimensionName with the name of your specific master data management table.
-- 1. Replace the source system key place holder columns with your source system keys.
-- 1. Replace the source system key place holder columns with your source system keys in the row hash. 
-- =============================================

USE ODS
GO

DROP INDEX IF EXISTS [NCIDX_YourDimensionNameMasterData_RowHash] ON [mdm].[YourDimensionNameMasterData]
GO

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

DROP TABLE IF EXISTS [mdm].[YourDimensionNameMasterData]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [mdm].[YourDimensionNameMasterData](
	[YourDimensionNameEK] [bigint] IDENTITY(1000,1) NOT NULL,
	[SourceSystemKey1] [nvarchar](50) NOT NULL,
	[SourceSystemKey2] [nvarchar](50) NOT NULL,
	[RowHash]  AS (CONVERT([binary](35),hashbytes('SHA1',concat(
	CONVERT([nvarchar](35),[SourceSystemKey1],(0)),
	CONVERT([nvarchar](35),[SourceSystemKey2],(0))
	)),(0))) PERSISTED,
 CONSTRAINT [PK_YourDimensionNameMasterData] PRIMARY KEY CLUSTERED 
(
	[YourDimensionNameEK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




CREATE UNIQUE NONCLUSTERED INDEX [NCIDX_YourDimensionNameMasterData_RowHash] ON [mdm].[YourDimensionNameMasterData]
(
	[RowHash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

