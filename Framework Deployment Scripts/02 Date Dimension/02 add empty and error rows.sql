-- =============================================
-- Author: Bob Wakefield
-- Create date: 19Oct20
-- Description: Add empty and error records to date dimension
-- Directions for use: Replace [YourDataWarehouseName] with the specific name of your EDW and run.
-- =============================================
USE [YourDataWarehouseName]

INSERT INTO dw.DimDate(DateCK, FormattedDate)
SELECT '00000000', 'No Date'
UNION ALL
SELECT '11111111', 'Not A Date'