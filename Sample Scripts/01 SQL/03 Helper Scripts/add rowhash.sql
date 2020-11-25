--Adding a RowHash on a TypeII dimension


BEGIN TRANSACTION

DROP INDEX IF EXISTS [Index Name] ON YourSchema.DimYourDimension

ALTER TABLE YourSchema.DimYourDimension DROP COLUMN RowHash

ALTER TABLE YourSchema.DimYourDimension  ADD RowHash AS CONVERT(binary(16),HASHBYTES('MD5', CONCAT(Column1, Column2, Column3))) PERSISTED

CREATE NONCLUSTERED INDEX [Index Name] ON YourSchema.DimYourDimension(RowHash)

COMMIT TRANSACTION
