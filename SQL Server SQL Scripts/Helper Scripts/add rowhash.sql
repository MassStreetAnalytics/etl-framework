--Adding a RowHash on a TypeII dimension


BEGIN TRANSACTION

DROP INDEX [Index Name] ON DimYourDimension

ALTER TABLE [dbo].DimYourDimension DROP COLUMN RowHash

ALTER TABLE [dbo].DimYourDimension  ADD RowHash AS CONVERT(binary(16),HASHBYTES('MD5', CONCAT(Column1, Column2, Column3))) PERSISTED

CREATE NONCLUSTERED INDEX [Index Name] ON [dbo].DimYourDimension(RowHash)

COMMIT TRANSACTION
