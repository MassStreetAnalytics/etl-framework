USE demo
DROP TABLE IF EXISTS DimDate
GO
/********************************************************************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 

DECLARE @StartDate DATETIME = '01/01/2099' --Starting value of Date Range
DECLARE @EndDate DATETIME = '12/31/2099' --End Value of Date Range

/**********************************************************************************/


CREATE TABLE	DimDate
	(	DateKey INT primary key, 
		Date DATETIME,
		FullDateUK CHAR(10), -- Date in dd-MM-yyyy format
		FullDateUSA CHAR(10),-- Date in MM-dd-yyyy format
		DayOfMonth NVARCHAR(2), -- Field will hold day number of Month
		DaySuffix NVARCHAR(4), -- Apply suffix as 1st, 2nd ,3rd etc
		DayName NVARCHAR(9), -- Contains name of the day, Sunday, Monday 
		DayOfWeekUSA CHAR(1),-- First Day Sunday=1 and Saturday=7
		DayOfWeekUK CHAR(1),-- First Day Monday=1 and Sunday=7
		DayOfWeekInMonth NVARCHAR(2), --1st Monday or 2nd Monday in Month
		DayOfWeekInYear NVARCHAR(2),
		DayOfQuarter NVARCHAR(3),
		DayOfYear NVARCHAR(3),
		WeekOfMonth NVARCHAR(1),-- Week Number of Month 
		WeekOfQuarter NVARCHAR(2), --Week Number of the Quarter
		WeekOfYear NVARCHAR(2),--Week Number of the Year
		Month NVARCHAR(2), --Number of the Month 1 to 12
		MonthName NVARCHAR(9),--January, February etc
		MonthOfQuarter NVARCHAR(2),-- Month Number belongs to Quarter
		Quarter CHAR(1),
		QuarterName NVARCHAR(9),--First,Second..
		Year CHAR(4),-- Year value of Date stored in Row
		YearName CHAR(7), --CY 2012,CY 2013
		MonthYear CHAR(10), --Jan-2013,Feb-2013
		MMYYYY CHAR(6),
		FirstDayOfMonth DATE,
		LastDayOfMonth DATE,
		FirstDayOfQuarter DATE,
		LastDayOfQuarter DATE,
		FirstDayOfYear DATE,
		LastDayOfYear DATE,
		IsHolidayUSA BIT,-- Flag 1=National Holiday, 0-No National Holiday
		IsWeekday BIT,-- 0=Week End ,1=Week Day
		HolidayUSA NVARCHAR(50),--Name of Holiday in US
		IsHolidayUK BIT Null, -- Flag 1=National Holiday, 0-No National Holiday
		HolidayUK NVARCHAR(50) Null --Name of Holiday in UK
	)





--Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE
	@DayOfWeekInMonth INT,
	@DayOfWeekInYear INT,
	@DayOfQuarter INT,
	@WeekOfMonth INT,
	@CurrentYear INT,
	@CurrentMonth INT,
	@CurrentQuarter INT

/*Table Data type to store the day of week count for the month and year*/
DECLARE @DayOfWeek TABLE (DOW INT, MonthCount INT, QuarterCount INT, YearCount INT)

INSERT INTO @DayOfWeek VALUES (1, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (2, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (3, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (4, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (5, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (6, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (7, 0, 0, 0)

--Extract and assign part of Values from Current Date to Variable

DECLARE @CurrentDate AS DATETIME = @StartDate
SET @CurrentMonth = DATEPART(MM, @CurrentDate)
SET @CurrentYear = DATEPART(YY, @CurrentDate)
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)

/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate < @EndDate
BEGIN
 
/*Begin day of week logic*/

         /*Check for Change in Month of the Current date if Month changed then 
          Change variable value*/
	IF @CurrentMonth != DATEPART(MM, @CurrentDate) 
	BEGIN
		UPDATE @DayOfWeek
		SET MonthCount = 0
		SET @CurrentMonth = DATEPART(MM, @CurrentDate)
	END

        /* Check for Change in Quarter of the Current date if Quarter changed then change 
         Variable value*/

	IF @CurrentQuarter != DATEPART(QQ, @CurrentDate)
	BEGIN
		UPDATE @DayOfWeek
		SET QuarterCount = 0
		SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)
	END
       
        /* Check for Change in Year of the Current date if Year changed then change 
         Variable value*/
	

	IF @CurrentYear != DATEPART(YY, @CurrentDate)
	BEGIN
		UPDATE @DayOfWeek
		SET YearCount = 0
		SET @CurrentYear = DATEPART(YY, @CurrentDate)
	END
	
        -- Set values in table data type created above from variables 

	UPDATE @DayOfWeek
	SET 
		MonthCount = MonthCount + 1,
		QuarterCount = QuarterCount + 1,
		YearCount = YearCount + 1
	WHERE DOW = DATEPART(DW, @CurrentDate)

	SELECT
		@DayOfWeekInMonth = MonthCount,
		@DayOfQuarter = QuarterCount,
		@DayOfWeekInYear = YearCount
	FROM @DayOfWeek
	WHERE DOW = DATEPART(DW, @CurrentDate)
	
/*End day of week logic*/


/* Populate Your Dimension Table with values*/
	
	INSERT INTO DimDate
	SELECT
		
		CONVERT (char(8),@CurrentDate,112) as DateKey,
		@CurrentDate AS Date,
		CONVERT (char(10),@CurrentDate,103) as FullDateUK,
		CONVERT (char(10),@CurrentDate,101) as FullDateUSA,
		DATEPART(DD, @CurrentDate) AS DayOfMonth,
		--Apply Suffix values like 1st, 2nd 3rd etc..
		CASE 
			WHEN DATEPART(DD,@CurrentDate) IN (11,12,13) THEN CAST(DATEPART(DD,@CurrentDate) AS NVARCHAR) + 'th'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 1 THEN CAST(DATEPART(DD,@CurrentDate) AS NVARCHAR) + 'st'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 2 THEN CAST(DATEPART(DD,@CurrentDate) AS NVARCHAR) + 'nd'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 3 THEN CAST(DATEPART(DD,@CurrentDate) AS NVARCHAR) + 'rd'
			ELSE CAST(DATEPART(DD,@CurrentDate) AS NVARCHAR) + 'th' 
			END AS DaySuffix,
		
		DATENAME(DW, @CurrentDate) AS DayName,
		DATEPART(DW, @CurrentDate) AS DayOfWeekUSA,
		-- check for day of week as Per US and change it as per UK format 
		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 7
			WHEN 2 THEN 1
			WHEN 3 THEN 2
			WHEN 4 THEN 3
			WHEN 5 THEN 4
			WHEN 6 THEN 5
			WHEN 7 THEN 6
			END 
			AS DayOfWeekUK,
		
		@DayOfWeekInMonth AS DayOfWeekInMonth,
		@DayOfWeekInYear AS DayOfWeekInYear,
		@DayOfQuarter AS DayOfQuarter,
		DATEPART(DY, @CurrentDate) AS DayOfYear,
		DATEPART(WW, @CurrentDate) + 1 - DATEPART(WW, CONVERT(NVARCHAR, DATEPART(MM, @CurrentDate)) + '/1/' + CONVERT(NVARCHAR, DATEPART(YY, @CurrentDate))) AS WeekOfMonth,
		(DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0), @CurrentDate) / 7) + 1 AS WeekOfQuarter,
		DATEPART(WW, @CurrentDate) AS WeekOfYear,
		DATEPART(MM, @CurrentDate) AS Month,
		DATENAME(MM, @CurrentDate) AS MonthName,
		CASE
			WHEN DATEPART(MM, @CurrentDate) IN (1, 4, 7, 10) THEN 1
			WHEN DATEPART(MM, @CurrentDate) IN (2, 5, 8, 11) THEN 2
			WHEN DATEPART(MM, @CurrentDate) IN (3, 6, 9, 12) THEN 3
			END AS MonthOfQuarter,
		DATEPART(QQ, @CurrentDate) AS Quarter,
		CASE DATEPART(QQ, @CurrentDate)
			WHEN 1 THEN 'First'
			WHEN 2 THEN 'Second'
			WHEN 3 THEN 'Third'
			WHEN 4 THEN 'Fourth'
			END AS QuarterName,
		DATEPART(YEAR, @CurrentDate) AS Year,
		'CY ' + CONVERT(NVARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
		LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(NVARCHAR, DATEPART(YY, @CurrentDate)) AS MonthYear,
		RIGHT('0' + CONVERT(NVARCHAR, DATEPART(MM, @CurrentDate)),2) + CONVERT(NVARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
		CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, @CurrentDate) - 1), @CurrentDate))) AS FirstDayOfMonth,
		CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, (DATEADD(MM, 1, @CurrentDate)))), DATEADD(MM, 1, @CurrentDate)))) AS LastDayOfMonth,
		DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0) AS FirstDayOfQuarter,
		DATEADD(QQ, DATEDIFF(QQ, -1, @CurrentDate), -1) AS LastDayOfQuarter,
		CONVERT(DATETIME, '01/01/' + CONVERT(NVARCHAR, DATEPART(YY, @CurrentDate))) AS FirstDayOfYear,
		CONVERT(DATETIME, '12/31/' + CONVERT(NVARCHAR, DATEPART(YY, @CurrentDate))) AS LastDayOfYear,
		NULL AS IsHolidayUSA,
		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 0
			WHEN 2 THEN 1
			WHEN 3 THEN 1
			WHEN 4 THEN 1
			WHEN 5 THEN 1
			WHEN 6 THEN 1
			WHEN 7 THEN 0
			END AS IsWeekday,
		NULL AS HolidayUSA, Null, Null

	SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END






/*Add HOLIDAYS UK*/
	
-- Good Friday  April 18 
	UPDATE DimDate
		SET HolidayUK = 'Good Friday'
	WHERE Month = 4 AND DayOfMonth  = 18
-- Easter Monday  April 21 
	UPDATE DimDate
		SET HolidayUK = 'Easter Monday'
	WHERE Month = 4 AND DayOfMonth  = 21
-- Early May Bank Holiday   May 5 
   UPDATE DimDate
		SET HolidayUK = 'Early May Bank Holiday'
	WHERE Month = 5 AND DayOfMonth  = 5
-- Spring Bank Holiday  May 26 
	UPDATE DimDate
		SET HolidayUK = 'Spring Bank Holiday'
	WHERE Month = 5 AND DayOfMonth  = 26
-- Summer Bank Holiday  August 25 
    UPDATE DimDate
		SET HolidayUK = 'Summer Bank Holiday'
	WHERE Month = 8 AND DayOfMonth  = 25
-- Boxing Day  December 26  	
    UPDATE DimDate
		SET HolidayUK = 'Boxing Day'
	WHERE Month = 12 AND DayOfMonth  = 26	
--CHRISTMAS
	UPDATE DimDate
		SET HolidayUK = 'Christmas Day'
	WHERE Month = 12 AND DayOfMonth  = 25
--New Years Day
	UPDATE DimDate
		SET HolidayUK  = 'New Year''s Day'
	WHERE Month = 1 AND DayOfMonth = 1
	
	UPDATE DimDate 
	SET IsHolidayUK = CASE WHEN HolidayUK IS NULL THEN 0 WHEN HolidayUK IS NOT NULL THEN 1 END 


	/*Add HOLIDAYS USA*/
	/*THANKSGIVING - Fourth THURSDAY in November*/
	UPDATE DimDate
		SET HolidayUSA = 'Thanksgiving Day'
	WHERE
		Month = 11 
		AND DayOfWeekUSA = 'Thursday' 
		AND DayOfWeekInMonth = 4

	/*CHRISTMAS*/
	UPDATE DimDate
		SET HolidayUSA = 'Christmas Day'
		
	WHERE Month = 12 AND DayOfMonth  = 25

	/*4th of July*/
	UPDATE DimDate
		SET HolidayUSA = 'Independance Day'
	WHERE Month = 7 AND DayOfMonth = 4

	/*New Years Day*/
	UPDATE DimDate
		SET HolidayUSA = 'New Year''s Day'
	WHERE Month = 1 AND DayOfMonth = 1

	/*Memorial Day - Last Monday in May*/
	UPDATE DimDate
		SET HolidayUSA = 'Memorial Day'
	FROM DimDate
	WHERE DateKey IN 
		(
		SELECT
			MAX(DateKey)
		FROM DimDate
		WHERE
			MonthName = 'May'
			AND DayOfWeekUSA  = 'Monday'
		GROUP BY
			Year,
			Month
		)

	/*Labor Day - First Monday in September*/
	UPDATE DimDate
		SET HolidayUSA = 'Labor Day'
	FROM DimDate
	WHERE DateKey IN 
		(
		SELECT
			MIN(DateKey)
		FROM DimDate
		WHERE
			MonthName = 'September'
			AND DayOfWeekUSA = 'Monday'
		GROUP BY
			Year,
			Month
		)

	/*Valentine's Day*/
	UPDATE DimDate
		SET HolidayUSA = 'Valentine''s Day'
	WHERE
		Month = 2 
		AND DayOfMonth = 14

	/*Saint Patrick's Day*/
	UPDATE DimDate
		SET HolidayUSA = 'Saint Patrick''s Day'
	WHERE
		Month = 3
		AND DayOfMonth = 17

	/*Martin Luthor King Day - Third Monday in January starting in 1983*/
	UPDATE DimDate
		SET HolidayUSA = 'Martin Luthor King Jr Day'
	WHERE
		Month = 1
		AND DayOfWeekUSA  = 'Monday'
		AND Year >= 1983
		AND DayOfWeekInMonth = 3

	/*President's Day - Third Monday in February*/
	UPDATE DimDate
		SET HolidayUSA = 'President''s Day'
	WHERE
		Month = 2
		AND DayOfWeekUSA = 'Monday'
		AND DayOfWeekInMonth = 3

	/*Mother's Day - Second Sunday of May*/
	UPDATE DimDate
		SET HolidayUSA = 'Mother''s Day'
	WHERE
		Month = 5
		AND DayOfWeekUSA = 'Sunday'
		AND DayOfWeekInMonth = 2

	/*Father's Day - Third Sunday of June*/
	UPDATE DimDate
		SET HolidayUSA = 'Father''s Day'
	WHERE
		Month = 6
		AND DayOfWeekUSA = 'Sunday'
		AND DayOfWeekInMonth = 3

	/*Halloween 10/31*/
	UPDATE DimDate
		SET HolidayUSA = 'Halloween'
	WHERE
		Month = 10
		AND DayOfMonth = 31

	/*Election Day - The first Tuesday after the first Monday in November*/
	BEGIN
		DECLARE @Holidays TABLE (ID INT IDENTITY(1,1), DateID int, Week TINYINT, YEAR CHAR(4), DAY CHAR(2))

		INSERT INTO @Holidays(DateID, Year,Day)
		SELECT
			DateKey,
			Year,
			DayOfMonth 
		FROM DimDate
		WHERE
			Month = 11
			AND DayOfWeekUSA = 'Monday'
		ORDER BY
			Year,
			DayOfMonth 

		DECLARE @CNTR INT, @POS INT, @STARTYEAR INT, @ENDYEAR INT, @MINDAY INT

		SELECT
			@CURRENTYEAR = MIN(Year)
			, @STARTYEAR = MIN(Year)
			, @ENDYEAR = MAX(Year)
		FROM @Holidays

		WHILE @CURRENTYEAR <= @ENDYEAR
		BEGIN
			SELECT @CNTR = COUNT(Year)
			FROM @Holidays
			WHERE Year = @CURRENTYEAR

			SET @POS = 1

			WHILE @POS <= @CNTR
			BEGIN
				SELECT @MINDAY = MIN(DAY)
				FROM @Holidays
				WHERE
					Year = @CURRENTYEAR
					AND Week IS NULL

				UPDATE @Holidays
					SET Week = @POS
				WHERE
					Year = @CURRENTYEAR
					AND Day = @MINDAY

				SELECT @POS = @POS + 1
			END

			SELECT @CURRENTYEAR = @CURRENTYEAR + 1
		END

		UPDATE DimDate
			SET HolidayUSA  = 'Election Day'				
		FROM DimDate DT
			JOIN @Holidays HL ON (HL.DateID + 1) = DT.DateKey
		WHERE
			Week = 1
	END
	
	UPDATE DimDate
		SET IsHolidayUSA = CASE WHEN HolidayUSA  IS NULL THEN 0 WHEN HolidayUSA  IS NOT NULL THEN 1 END

--###################
--Begin Customization
--###################
GO

sp_rename 'DimDate.DateKey','DateCK','COLUMN'
GO
sp_rename 'DimDate.FullDateUSA','FormattedDate','COLUMN'
GO
sp_rename 'DimDate.DayOfWeekUSA','DayofWeek','COLUMN'
GO
sp_rename 'DimDate.Quarter','QuarterInYear','COLUMN'
GO
sp_rename 'DimDate.IsHolidayUSA','IsHoliday','COLUMN'
GO
sp_rename 'DimDate.HolidayUSA','Holiday','COLUMN'
GO
sp_rename 'DimDate.Month','MonthInYear','COLUMN'

GO

ALTER TABLE DimDate DROP COLUMN FullDateUK
ALTER TABLE DimDate DROP COLUMN DayOfWeekUK
ALTER TABLE DimDate DROP COLUMN IsHolidayUK
ALTER TABLE DimDate DROP COLUMN HolidayUK



ALTER TABLE DimDate ADD IsFirstDayOfMonth NVARCHAR(3)
ALTER TABLE DimDate ADD IsLastDayOfMonth NVARCHAR(3)
ALTER TABLE DimDate ADD IsFirstDayOfQuarter NVARCHAR(3)
ALTER TABLE DimDate ADD IsLastDayOfQuarter NVARCHAR(3)
ALTER TABLE DimDate ADD IsFirstDayOfYear NVARCHAR(3)
ALTER TABLE DimDate ADD IsLastDayOfYear NVARCHAR(3)
ALTER TABLE DimDate ADD ISOWeekNumberOfYear INT
ALTER TABLE DimDate ADD ISODayOfWeek INT
ALTER TABLE DimDate ADD IsWorkDay NVARCHAR(3)

ALTER TABLE DimDate ALTER COLUMN IsHoliday NVARCHAR(3)
ALTER TABLE DimDate ALTER COLUMN IsWeekday NVARCHAR(3)
ALTER TABLE DimDate ALTER COLUMN Date DATE

--Transform MMYYYY
UPDATE DimDate
SET MMYYYY = CONCAT(RIGHT(MMYYYY, 4), LEFT(MMYYYY,2))

GO
sp_rename 'DimDate.MMYYYY','YYYYMM','COLUMN'

GO

ALTER TABLE DimDate ALTER COLUMN YYYYMM INT


UPDATE DimDate
SET IsFirstDayOfMonth = 
CASE
WHEN FirstDayOfMonth = Date THEN 'Yes'
ELSE 'No'
END

UPDATE DimDate
SET IsLastDayOfMonth = 
CASE
WHEN LastDayOfMonth = Date THEN 'Yes'
ELSE 'No'
END

UPDATE DimDate
SET IsFirstDayOfQuarter = 
CASE
WHEN FirstDayOfQuarter = Date THEN 'Yes'
ELSE 'No'
END

UPDATE DimDate
SET IsLastDayOfQuarter = 
CASE
WHEN LastDayOfQuarter = Date THEN 'Yes'
ELSE 'No'
END

UPDATE DimDate
SET IsFirstDayOfYear = 
CASE
WHEN FirstDayOfYear = Date THEN 'Yes'
ELSE 'No'
END

UPDATE DimDate
SET IsLastDayOfYear = 
CASE
WHEN LastDayOfYear = Date THEN 'Yes'
ELSE 'No'
END


UPDATE DimDate
SET IsHoliday = 
CASE
WHEN IsHoliday = '1' THEN 'Yes'
ELSE 'No'
END

UPDATE DimDate
SET IsWeekday = 
CASE
WHEN IsWeekday = '1' THEN 'Yes'
ELSE 'No'
END

UPDATE DimDate
SET IsHoliday = 'Yes'
WHERE Holiday IS NOT NULL

UPDATE DimDate
SET IsHoliday = 'No'
WHERE IsHoliday = ''

--Alter to your needs
UPDATE DimDate
SET IsWorkday =
CASE
WHEN DayName <> 'Sunday' AND DayName <> 'Saturday' THEN 'Yes'
ELSE 'No'
END

UPDATE DimDate
SET ISOWeekNumberOfYear = (DATEPART(dy,DATEDIFF(dd,0,Date)/7*7+3)+6)/7

UPDATE DimDate
SET ISODayOfWeek = 
CASE
WHEN DayName = 'Monday' THEN 1
WHEN DayName = 'Tuesday' THEN 2
WHEN DayName = 'Wednesday' THEN 3
WHEN DayName = 'Thursday' THEN 4
WHEN DayName = 'Friday' THEN 5
WHEN DayName = 'Saturday' THEN 6
WHEN DayName = 'Sunday' THEN 7
END

--Calculate Thanksgiving
UPDATE DimDate
SET Holiday = 'Thanksgiving Day'
WHERE Date IN(
SELECT DATEADD(WEEK, 3, DateAdd(day, (7+5 -DatePart(weekday, Date))%7, Date) ) AS Thanksgiving
FROM DimDate
WHERE MonthInYear = 11
AND DayOfMonth = 1
)

-- Calculate Memorial Day Holiday
-- last Monday of May
UPDATE DimDate 
SET Holiday = 'Memorial Day'
WHERE Date IN(
SELECT MAX(Date) 
FROM DimDate 
WHERE MonthInYear = 5
AND DayOfWeek = 2
GROUP BY Year
)

-- Calculate Labor Day Holiday
-- 1st Monday of September
UPDATE DimDate 
SET Holiday = 'Memorial Day'
WHERE Date IN(
SELECT MIN(Date) 
FROM DimDate 
WHERE MonthInYear = 9
AND DayOfWeek = 2
GROUP BY Year
)


SELECT *
FROM DimDate