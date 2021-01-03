# sample indexed view

Description: This is a sample indexed view. Indexed views go in the dbo schema, so there is no need to specify the schema.

Necessary Modification: 

1. Replace YourEDW with the name of your EDW. 
2. Drop in your select statement from your dimension devoid of audit columns.
3. Replace YourDimensionName with your dimension. 
4. Replace RenameCK with your renamed contrived key.

```text
USE YourEDW

GO
DROP VIEW IF EXISTS DimYourDimensionName 
GO

CREATE VIEW DimYourDimensionName
 
WITH SCHEMABINDING  
AS  
SELECT
YourDimensionNameCK AS RenamedCK,
Column1,
Column2,
ColumnN,
IsMostRecentRow
FROM [dw].[DimYourDimensionName]
GO  
--Create an index on the view.  
CREATE UNIQUE CLUSTERED INDEX CIDX_DimYourDimensionName_YourDimensionNameCK ON DimYourDimensionName(RenamedCK);  
GO  
```



