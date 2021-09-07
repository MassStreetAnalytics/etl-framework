-- =============================================
-- Author: Bob Wakefield
-- Create date:  17Jun18
-- Description: Clean dates to conform with DimDateCK
-- =============================================

USE ODS

GO

DROP FUNCTION IF EXISTS udf_CleanDate

GO

CREATE FUNCTION udf_CleanDate(@DATE NVARCHAR(255))

RETURNS NCHAR(8)

AS

BEGIN

DECLARE @MinDate DATE
DECLARE @MaxDate DATE
DECLARE @EmptyRecordCode BIGINT = 00000000
DECLARE @ErrorDateCode BIGINT = 11111111

--Find and replace YourDatabase.YourSchema.DimDate with the name of your data warehouse
--and the schema that it lives in.

SELECT @MaxDate = CAST(MAX(DateCK) AS NCHAR(8))
FROM YourDataWarehouse.dw.DimDate
WHERE DateCK NOT IN (@EmptyRecordCode,@ErrorDateCode)

SELECT @MinDate = CAST(MIN(DateCK) AS NCHAR(8))
FROM YourDataWarehouse.dw.DimDate
WHERE DateCK NOT IN (@EmptyRecordCode,@ErrorDateCode)


--Set empty dates to the empty field code
--This HAS to be done before you check for
--bad dates. Then Set error dates to the error field code.
--Finally, clean up the dates to conform to DimDateCK format.

RETURN
CASE 
WHEN @Date IS NULL THEN  @EmptyRecordCode
WHEN ISDATE(@Date) = 0 THEN  @ErrorDateCode
WHEN @Date < @MinDate THEN  @ErrorDateCode
WHEN @Date > @MaxDate THEN  @ErrorDateCode
ELSE CONVERT(VARCHAR(10),CAST(@Date AS DATE),112)
END


END