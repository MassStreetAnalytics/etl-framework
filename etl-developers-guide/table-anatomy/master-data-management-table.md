# Sample Master Data Management Table

MDM tables are essentially repurposed junk dimensions. We will talk about the mechanics of how MDM tables work in a later section.

Regardless of what their data type is in the source system, values should be stored as NVARCHAR so they can be hashed without complaint.

You'll notice that the primary key does not start at 1. You do not want an enterprise key that is that simple. Throw some zeros on it and make it a real company.

```sql
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

```

| Column Name | Data Type | Function |
| :--- | :--- | :--- |
| SourceSystemN | NVARCHAR\(N\) | Holds one of the primary keys that make up the set of keys that uniquely define a complete master data record. |
| RowHash | BINARY\(16\) | A computed value of those columns used to compute the uniqueness of a row. This value is used to determine INSERT or UPDATE operations on the table. |

