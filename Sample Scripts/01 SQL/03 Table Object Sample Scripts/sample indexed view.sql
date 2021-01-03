-- =============================================
-- Author:
-- Create date:
-- Description:
-- Directions for use: Replace YourEDW with the name
-- of your EDW. Drop in your select statement from your
-- dimension devoid of audit columns.
-- Replace YourDimensionName with your dimension
-- Replace RenameCK with your renamed contrived key.
-- =============================================

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
