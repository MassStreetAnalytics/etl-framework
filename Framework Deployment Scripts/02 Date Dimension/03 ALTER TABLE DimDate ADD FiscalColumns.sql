-- =============================================
-- Author: Bob Wakefield
-- Create date: 20Oct20
-- Description: Adds fiscal year columns and data to the date dimension.
-- Directions for use: Work with your CFO to build out this part of your date dimension. 
-- Fiscal years are often offset from calendar years. You will need to find out when the first day of the fiscal year starts. 
-- Before you run this script, you need to review it thoroughly. You need to discuss with your CFO to determine if you are 
-- on a 5-4-5 calendar or a 4-4-5 and make the necessary changes to the set fiscal month section.
-- The following variables need to be assigned values.
-- @dtFiscalYearStart – The first month and day of the fiscal year along with the first year that the date dimension has data.
-- @FiscalYear – The first year the date dimension has data.
-- @LastYear – The last year the date dimension has data.
-- @FirstLeapYearInPeriod – The first leap year after the first year of data in the date dimension.
-- Once you have those values, replace [YourDataWarehouseName] with the specific name of your EDW and run the script.
-- =============================================

USE [YourDataWarehouseName]


--Add Fiscal date columns to DimDate
ALTER TABLE [dw].[DimDate] ADD
[FiscalDayOfYear] VARCHAR(3) NULL,
[FiscalWeekOfYear] VARCHAR(3) NULL,
[FiscalMonth] VARCHAR(2) NULL, 
[FiscalQuarter] CHAR(1) NULL,
[FiscalQuarterName] VARCHAR(9) NULL,
[FiscalYear] CHAR(4) NULL,
[FiscalYearName] CHAR(7) NULL,
[FiscalMonthYear] CHAR(10) NULL,
[FiscalMMYYYY] CHAR(6) NULL,
[FiscalFirstDayOfMonth] DATE NULL,
[FiscalLastDayOfMonth] DATE NULL,
[FiscalFirstDayOfQuarter] DATE NULL,
[FiscalLastDayOfQuarter] DATE NULL,
[FiscalFirstDayOfYear] DATE NULL,
[FiscalLastDayOfYear] DATE NULL
GO

--The following section needs to be populated for defining the fiscal calendar
DECLARE
@dtFiscalYearStart SMALLDATETIME = 'January 01, 1900',
@FiscalYear INT = 1900,
@LastYear INT = 2099,
@FirstLeapYearInPeriod INT = 1904


DECLARE
@iTemp INT,
@LeapWeek INT,
@CurrentDate DATE,
@FiscalDayOfYear INT,
@FiscalWeekOfYear INT,
@FiscalMonth INT,
@FiscalQuarter INT,
@FiscalQuarterName VARCHAR(10),
@FiscalYearName VARCHAR(7),
@LeapYear INT,
@FiscalFirstDayOfYear DATE,
@FiscalFirstDayOfQuarter DATE,
@FiscalFirstDayOfMonth DATE,
@FiscalLastDayOfYear DATE,
@FiscalLastDayOfQuarter DATE,
@FiscalLastDayOfMonth DATE

--Holds the years that have 455 in last quarter
DECLARE @LeapTable TABLE (leapyear INT)

--TABLE to contain the fiscal year calendar
DECLARE @tb TABLE(
[PeriodDate] DATETIME,
[FiscalDayOfYear] VARCHAR(3),
[FiscalWeekOfYear] VARCHAR(3),
[FiscalMonth] VARCHAR(2), 
[FiscalQuarter] VARCHAR(1),
[FiscalQuarterName] VARCHAR(9),
[FiscalYear] VARCHAR(4),
[FiscalYearName] VARCHAR(7),
[FiscalMonthYear] VARCHAR(10),
[FiscalMMYYYY] VARCHAR(6),
[FiscalFirstDayOfMonth] DATE,
[FiscalLastDayOfMonth] DATE,
[FiscalFirstDayOfQuarter] DATE,
[FiscalLastDayOfQuarter] DATE,
[FiscalFirstDayOfYear] DATE,
[FiscalLastDayOfYear] DATE)

--Populate the table with all leap years
SET @LeapYear = @FirstLeapYearInPeriod
WHILE (@LeapYear < @LastYear)
BEGIN
INSERT INTO @leapTable VALUES (@LeapYear)
SET @LeapYear = @LeapYear + 5
END

--Initiate parameters before loop
SET @CurrentDate = @dtFiscalYearStart
SET @FiscalDayOfYear = 1
SET @FiscalWeekOfYear = 1
SET @FiscalMonth = 1
SET @FiscalQuarter = 1
SET @FiscalWeekOfYear = 1

IF (EXISTS (SELECT * FROM @LeapTable WHERE @FiscalYear = leapyear))
BEGIN
SET @LeapWeek = 1
END
ELSE
BEGIN
SET @LeapWeek = 0
END



--Loop on days in interval
WHILE (DATEPART(yy,@CurrentDate) <= @LastYear)
BEGIN
	
--set fiscal month
SELECT @FiscalMonth = CASE 
--Use this section for a 4-5-4 calendar.  Every leap year the result will be a 4-5-5
WHEN @FiscalWeekOfYear BETWEEN 1 AND 4 THEN 1 --4 weeks
WHEN @FiscalWeekOfYear BETWEEN 5 AND 9 THEN 2 --5 weeks
WHEN @FiscalWeekOfYear BETWEEN 10 AND 13 THEN 3 --4 weeks
WHEN @FiscalWeekOfYear BETWEEN 14 AND 17 THEN 4 --4 weeks
WHEN @FiscalWeekOfYear BETWEEN 18 AND 22 THEN 5 --5 weeks
WHEN @FiscalWeekOfYear BETWEEN 23 AND 26 THEN 6 --4 weeks
WHEN @FiscalWeekOfYear BETWEEN 27 AND 30 THEN 7 --4 weeks
WHEN @FiscalWeekOfYear BETWEEN 31 AND 35 THEN 8 --5 weeks
WHEN @FiscalWeekOfYear BETWEEN 36 AND 39 THEN 9 --4 weeks
WHEN @FiscalWeekOfYear BETWEEN 40 AND 43 THEN 10 --4 weeks
WHEN @FiscalWeekOfYear BETWEEN 44 AND (48+@LeapWeek) THEN 11 --5 weeks
WHEN @FiscalWeekOfYear BETWEEN (49+@LeapWeek) AND (52+@LeapWeek) THEN 12 --4 weeks (5 weeks on leap year)

--Use this section for a 4-4-5 calendar.  Every leap year the result will be a 4-5-5
--WHEN @FiscalWeekOfYear BETWEEN 1 AND 4 THEN 1 --4 weeks
--WHEN @FiscalWeekOfYear BETWEEN 5 AND 8 THEN 2 --4 weeks
--WHEN @FiscalWeekOfYear BETWEEN 9 AND 13 THEN 3 --5 weeks
--WHEN @FiscalWeekOfYear BETWEEN 14 AND 17 THEN 4 --4 weeks
--WHEN @FiscalWeekOfYear BETWEEN 18 AND 21 THEN 5 --4 weeks
--WHEN @FiscalWeekOfYear BETWEEN 22 AND 26 THEN 6 --5 weeks
--WHEN @FiscalWeekOfYear BETWEEN 27 AND 30 THEN 7 --4 weeks
--WHEN @FiscalWeekOfYear BETWEEN 31 AND 34 THEN 8 --4 weeks
--WHEN @FiscalWeekOfYear BETWEEN 35 AND 39 THEN 9 --5 weeks
--WHEN @FiscalWeekOfYear BETWEEN 40 AND 43 THEN 10 --4 weeks
--WHEN @FiscalWeekOfYear BETWEEN 44 AND (47+@leapWeek) THEN 11 --4 weeks (5 weeks on leap year)
--WHEN @FiscalWeekOfYear BETWEEN (48+@leapWeek) AND (52+@leapWeek) THEN 12 --5 weeks
END

--SET Fiscal Quarter
SELECT @FiscalQuarter = 
CASE 
WHEN @FiscalMonth BETWEEN 1 AND 3 THEN 1
WHEN @FiscalMonth BETWEEN 4 AND 6 THEN 2
WHEN @FiscalMonth BETWEEN 7 AND 9 THEN 3
WHEN @FiscalMonth BETWEEN 10 AND 12 THEN 4
END
	
SELECT @FiscalQuarterName = CASE 
WHEN @FiscalMonth BETWEEN 1 AND 3 THEN 'First'
WHEN @FiscalMonth BETWEEN 4 AND 6 THEN 'Second'
WHEN @FiscalMonth BETWEEN 7 AND 9 THEN 'Third'
WHEN @FiscalMonth BETWEEN 10 AND 12 THEN 'Fourth'
END
	
--Set Fiscal Year Name
SELECT @FiscalYearName = 'FY ' + CONVERT(VARCHAR, @FiscalYear)

INSERT INTO @tb (PeriodDate, FiscalDayOfYear, FiscalWeekOfYear, fiscalMonth, FiscalQuarter, FiscalQuarterName, FiscalYear, FiscalYearName) 
VALUES (@CurrentDate, @FiscalDayOfYear, @FiscalWeekOfYear, @FiscalMonth, @FiscalQuarter, @FiscalQuarterName, @FiscalYear, @FiscalYearName)

--SET next day
SET @CurrentDate = DATEADD(dd, 1, @CurrentDate)
SET @FiscalDayOfYear = @FiscalDayOfYear + 1
SET @FiscalWeekOfYear = ((@FiscalDayOfYear-1) / 7) + 1


IF (@FiscalWeekOfYear > (52+@LeapWeek))
BEGIN
--Reset a new year
SET @FiscalDayOfYear = 1
SET @FiscalWeekOfYear = 1
SET @FiscalYear = @FiscalYear + 1
IF ( EXISTS (SELECT * FROM @leapTable WHERE @FiscalYear = leapyear))
BEGIN
SET @LeapWeek = 1
END
ELSE
BEGIN
SET @LeapWeek = 0
END
END
END


--Set first and last days of the fiscal months
UPDATE @tb
SET
FiscalFirstDayOfMonth = minmax.StartDate,
FiscalLastDayOfMonth = minmax.EndDate
FROM
@tb t,
(
SELECT FiscalMonth, FiscalQuarter, FiscalYear, MIN(PeriodDate) AS StartDate, MAX(PeriodDate) AS EndDate
FROM @tb
GROUP BY FiscalMonth, FiscalQuarter, FiscalYear
) minmax
WHERE
t.FiscalMonth = minmax.FiscalMonth 
AND t.FiscalQuarter = minmax.FiscalQuarter 
AND t.FiscalYear = minmax.FiscalYear 

--Set first and last days of the fiscal quarters
UPDATE @tb
SET
FiscalFirstDayOfQuarter = minmax.StartDate,
FiscalLastDayOfQuarter = minmax.EndDate
FROM
@tb t,
(
SELECT FiscalQuarter, FiscalYear, min(PeriodDate) as StartDate, max(PeriodDate) as EndDate
FROM @tb
GROUP BY FiscalQuarter, FiscalYear
) minmax
WHERE t.FiscalQuarter = minmax.FiscalQuarter 
AND t.FiscalYear = minmax.FiscalYear 

--Set first and last days of the fiscal years
UPDATE @tb
SET
FiscalFirstDayOfYear = minmax.StartDate,
FiscalLastDayOfYear = minmax.EndDate
FROM
@tb t,
(
SELECT FiscalYear, min(PeriodDate) as StartDate, max(PeriodDate) as EndDate
FROM @tb
GROUP BY FiscalYear
) minmax
WHERE
t.FiscalYear = minmax.FiscalYear 

--Set FiscalYearMonth
UPDATE @tb
SET
FiscalMonthYear = 
CASE FiscalMonth
WHEN 1 THEN 'Jan'
WHEN 2 THEN 'Feb'
WHEN 3 THEN 'Mar'
WHEN 4 THEN 'Apr'
WHEN 5 THEN 'May'
WHEN 6 THEN 'Jun'
WHEN 7 THEN 'Jul'
WHEN 8 THEN 'Aug'
WHEN 9 THEN 'Sep'
WHEN 10 THEN 'Oct'
WHEN 11 THEN 'Nov'
WHEN 12 THEN 'Dec'
END + '-' + CONVERT(VARCHAR, FiscalYear)

--Set FiscalMMYYYY
UPDATE @tb
SET FiscalMMYYYY = RIGHT('0' + CONVERT(VARCHAR, FiscalMonth),2) + CONVERT(VARCHAR, FiscalYear)

--*****************************************************************************************************************************************************

UPDATE b
SET
FiscalDayOfYear = a.FiscalDayOfYear,
FiscalWeekOfYear = a.FiscalWeekOfYear,
FiscalMonth = a.FiscalMonth,
FiscalQuarter = a.FiscalQuarter,
FiscalQuarterName = a.FiscalQuarterName,
FiscalYear = a.FiscalYear,
FiscalYearName = a.FiscalYearName,
FiscalMonthYear = a.FiscalMonthYear,
FiscalMMYYYY = a.FiscalMMYYYY,
FiscalFirstDayOfMonth = a.FiscalFirstDayOfMonth,
FiscalLastDayOfMonth = a.FiscalLastDayOfMonth,
FiscalFirstDayOfQuarter = a.FiscalFirstDayOfQuarter,
FiscalLastDayOfQuarter = a.FiscalLastDayOfQuarter,
FiscalFirstDayOfYear = a.FiscalFirstDayOfYear,
FiscalLastDayOfYear = a.FiscalLastDayOfYear
FROM @tb a
INNER JOIN [dw].[DimDate] b 
ON a.PeriodDate = b.[Date]


SELECT *
FROM [dw].[DimDate]

