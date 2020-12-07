-- =============================================
-- Author: Bob Wakefield
-- Create date: 7Dec20
-- Description: This script will populate a fact table with
-- a random amount of records so you can test to see that
-- usp_RecordRowCounts works properly.
-- Change Log:
-- =============================================

--set the range for where you want the final number of records to fall.
DECLARE @random INT;
DECLARE @upper INT;
DECLARE @lower INT;
SET @lower = 1 ---- The lowest random number
SET @upper = 20 ---- The highest random number
SELECT @random = ROUND(((@upper - @lower -1) * RAND() + @lower), 0)

--This is an example using adventure works. Create an insert statement for whatever fact table you would like to load.
DECLARE @counter smallint;
SET @counter = 1;
WHILE @counter < @random
   BEGIN
      INSERT INTO [AdventureWorksDW2012].[dbo].[FactFinance]([DateKey], [OrganizationKey], [DepartmentGroupKey], [ScenarioKey], [AccountKey], [Amount], [Date])
      SELECT 20050701, 5, 7, 1, 21, 4358, CURRENT_TIMESTAMP
      SET @counter = @counter + 1
   END;
GO
