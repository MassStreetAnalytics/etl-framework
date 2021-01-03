# change collation

If you find yourself working in a database without a case sensitive collation, you will frequently need to change the collation on any columns that require hashing. This script changes the collation on the EDW table, the common model table, and the staging table all in one fell swoop. You need to change it in all three places to correctly load the table.

```text
USE ODS

BEGIN TRANSACTION

USE EDW

DROP INDEX IF EXISTS [NCINDEX_YourDimensionName_ROWHASH] ON [dw].[DimYourDimensionName]

ALTER TABLE [dw].[DimYourDimensionName] DROP COLUMN RowHash

ALTER TABLE dw.[DimYourDimensionName] ALTER COLUMN [YourDimensionName] [nvarchar](MAX) COLLATE SQL_Latin1_General_CP1_CS_AS

ALTER TABLE dw.[DimYourDimensionName]  ADD RowHash AS (CONVERT([varbinary](16),hashbytes('MD5',concat(
CONVERT([nvarchar](35),Column1,(0)),
CONVERT([nvarchar](35),Column2,(0)),
CONVERT([nvarchar](35),Column3,(0)),
CONVERT([nvarchar](35),Column4,(0))
)))) PERSISTED

CREATE NONCLUSTERED INDEX [NCINDEX_YourDimensionName_ROWHASH] ON [dw].[DimYourDimensionName](RowHash)

USE ODS

DROP INDEX IF EXISTS [NCINDEX_YourDimensionName_ROWHASH] ON cm.[DimYourDimensionName]

ALTER TABLE cm.[DimYourDimensionName] DROP COLUMN RowHash

ALTER TABLE cm.[DimYourDimensionName] ALTER COLUMN [YourDimensionName] [nvarchar](MAX) COLLATE SQL_Latin1_General_CP1_CS_AS

ALTER TABLE cm.[DimYourDimensionName]  ADD RowHash AS (CONVERT([varbinary](16),hashbytes('MD5',concat(
CONVERT([nvarchar](35),Column1,(0)),
CONVERT([nvarchar](35),Column2,(0)),
CONVERT([nvarchar](35),Column3,(0)),
CONVERT([nvarchar](35),Column4,(0))
)))) PERSISTED


CREATE NONCLUSTERED INDEX [NCINDEX_YourDimensionName_ROWHASH] ON cm.[DimYourDimensionName](RowHash)

ALTER TABLE cp.OrdersData ALTER COLUMN YourDimensionNames [nvarchar](MAX) COLLATE SQL_Latin1_General_CP1_CS_AS


USE EDW
```

