USE ODS

BEGIN TRANSACTION

USE EDW

DROP INDEX IF EXISTS [NCINDEX_YourComment_ROWHASH] ON [dw].[DimYourDimension]

ALTER TABLE [dw].[DimYourDimension] DROP COLUMN RowHash

ALTER TABLE dw.[DimYourDimension] ALTER COLUMN [YourComment] [nvarchar](MAX) COLLATE SQL_Latin1_General_CP1_CS_AS

ALTER TABLE dw.[DimYourDimension]  ADD RowHash AS CONVERT(varbinary(16),HASHBYTES('MD5', [YourComment])) PERSISTED

CREATE NONCLUSTERED INDEX [NCINDEX_YourComment_ROWHASH] ON [dw].[DimYourDimension](RowHash)

USE ODS

DROP INDEX IF EXISTS [NCINDEX_YourComment_ROWHASH] ON cm.[DimYourDimension]

ALTER TABLE cm.[DimYourDimension] DROP COLUMN RowHash

ALTER TABLE cm.[DimYourDimension] ALTER COLUMN [YourComment] [nvarchar](MAX) COLLATE SQL_Latin1_General_CP1_CS_AS

ALTER TABLE cm.[DimYourDimension]  ADD RowHash AS CONVERT(varbinary(16),HASHBYTES('MD5', [YourComment])) PERSISTED


CREATE NONCLUSTERED INDEX [NCINDEX_YourComment_ROWHASH] ON cm.[DimYourDimension](RowHash)

ALTER TABLE cp.OrdersData ALTER COLUMN YourComments [nvarchar](MAX) COLLATE SQL_Latin1_General_CP1_CS_AS




USE EDW




COMMIT TRANSACTION

ALTER TABLE [table name] ADD [RowHash]  AS (CONVERT([varbinary](16),hashbytes('MD5',concat(
CONVERT([nvarchar](35),Column1,(0)),
CONVERT([nvarchar](35),Column2,(0)),
CONVERT([nvarchar](35),Column3,(0)),
CONVERT([nvarchar](35),Column4,(0))
)))) PERSISTED


