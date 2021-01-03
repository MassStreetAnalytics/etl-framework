# Sample Indexed View

Every table in your EDW is mirrored by a view of that table in the dbo schema. That view is a simple select statement on the source table, absent the audit columns excepting the MostRecentRecord column from dimensions. These views are what data analyst use to access the data warehouse. They do not need to be exposed to either the base tables, or the columns used to run and maintain the database.

However, it is not good enough to just create a simple view. We need to create a high speed view. We do that by throwing some stank on it and by stank I mean an index on it.

```sql
USE YourEDW

GO
DROP VIEW IF EXISTS DimYourDimensionName 
GO

CREATE VIEW DimYourDimensionName
 
WITH SCHEMABINDING  
AS  
SELECT
YourDimensionNameCK,
Column1,
Column2,
ColumnN,
IsMostRecentRow
FROM [dw].[DimYourDimensionName]
GO  
--Create an index on the view.  
CREATE UNIQUE CLUSTERED INDEX CIDX_DimYourDimensionName_YourDimensionNameCK ON DimYourDimensionName(YourDimensionNameCK);
GO  
```

