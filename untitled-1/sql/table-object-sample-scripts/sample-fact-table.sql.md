# sample fact table

Description: This is a sample fact table. The sample fact table DOES NOT come with the code necessary to build the relationships between dims and facts. That code is generated in the [Data Model Creation Template](../../../data-model-creation-template/).

Necessary Modification:

1. Add the PK columns of the dimensions that are attached to the fact table on line 16.
2. Add your measures and degenerate dimensions on line 18. 
3. Add the dimension keys to the UniqueDims hash. Ensure that the parameter for the datatype is large enough to fit the column.
4. Add unique rows if necessary. Again, ensure that the parameter for the datatype is large enough to fit the column.

```text
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
 CONSTRAINT [PK_prices] PRIMARY KEY CLUSTERED 
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
```

