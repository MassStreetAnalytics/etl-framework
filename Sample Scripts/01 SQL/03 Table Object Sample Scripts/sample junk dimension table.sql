-- =============================================
-- Author:
-- Create date:
-- Description:
-- Directions for use:
-- Replace YourEDW with the name of your specific EDW.
-- Insert your columns at line 15.
-- Replace YourDimensionName with the name of your dimension.
-- Put your columns in the row hash being careful to change the parameter on the datatype to fit the column.
-- =============================================

USE YourEDW
 
DROP TABLE IF EXISTS [dw].[DimYourDimensionName]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dw].[DimYourDimensionName](
[YourDimensionNameCK] [bigint] IDENTITY(1,1) NOT NULL,
--your columns.
[CreatedBy] [nvarchar](50) NULL,
[CreatedOn] [datetime] NULL,
[UpdatedBy] [nvarchar](50) NULL,
[UpdatedOn] [datetime] NULL,
[SourceSystem] [nvarchar](100) NULL,
[SourceSystemKey] [nvarchar](100) NULL,
[EffectiveFrom] [datetime] NULL,
[EffectiveTo] [datetime] NULL,
[IsMostRecentRecord] [bit] NULL,
[RowHash]  AS (CONVERT([binary](16),hashbytes('MD5',concat(
CONVERT([nvarchar](35),Column1,0),
CONVERT([nvarchar](35),Column2,0),
CONVERT([nvarchar](35),Column3,0),
CONVERT([nvarchar](35),Column4,0),
CONVERT([nvarchar](35),Column5,0),
CONVERT([nvarchar](35),Column6,0))),0)) PERSISTED,
 CONSTRAINT [PK_YourDimensionName] PRIMARY KEY CLUSTERED 
(
[YourDimensionNameCK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END

--index is optional
DROP INDEX IF EXISTS [NCIDX_FactYourFactTableName_RowHash] ON [dw].[FactYourFactTableName]
GO


CREATE NONCLUSTERED INDEX [NCIDX_FactYourFactTableName_RowHash] ON [dw].[FactYourFactTableName]
(
	[RowHash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO



