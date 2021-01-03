# add rowhash

Sometimes you need to add or update a RowHash on a table. In the case of updating the hash, you have to tear down the existing hash and add it back.

```text
BEGIN TRANSACTION

DROP INDEX IF EXISTS [Index Name] ON YourSchema.DimYourDimension

ALTER TABLE YourSchema.DimYourDimension DROP COLUMN IF EXISTS RowHash

ALTER TABLE YourSchema.DimYourDimension  ADD [RowHash]  AS (CONVERT([varbinary](16),hashbytes('MD5',concat(
CONVERT([nvarchar](35),Column1,0),
CONVERT([nvarchar](35),Column2,0),
CONVERT([nvarchar](35),Column3,0),
CONVERT([nvarchar](35),Column4,0),
CONVERT([nvarchar](35),Column5,0),
CONVERT([nvarchar](35),Column6,0)
)),0)) PERSISTED

CREATE NONCLUSTERED INDEX [Index Name] ON YourSchema.DimYourDimension(RowHash)

COMMIT TRANSACTION
```



