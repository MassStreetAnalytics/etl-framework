--Create dw Schema first!
--Do something about the lower case.
--Spreadsheet calculates leap year dates poorly.

DROP TABLE IF EXISTS dw.DimDate;



CREATE TABLE dw.DimDate
(
 DateCK BIGINT NOT NULL,
 FullDate VARCHAR(10) NOT NULL,
 DateName VARCHAR(10) NOT NULL,
 DayOfWeek INT NOT NULL,
 DayNameOfWeek VARCHAR(9) NOT NULL,
 DayOfMonth INT NOT NULL,
 DayOfYear INT NOT NULL,
 IsWeekday VARCHAR(7) NOT NULL,
 WeekOfYear INT NOT NULL,
 MonthName VARCHAR(9) NOT NULL,
 MonthOfYear INT NOT NULL,
 IsLastDayOfMonth VARCHAR(3) NOT NULL,
 CalendarQuarter INT NOT NULL,
 CalendarYear INT NOT NULL,
 CalendarYearMonth VARCHAR(7) NOT NULL,
 CalendarYearQtr VARCHAR(6) NOT NULL,
 FiscalMonthOfYear INT NOT NULL,
 FiscalQuarter INT NOT NULL,
 FiscalYear INT NOT NULL,
 FiscalYearMonth VARCHAR(9) NOT NULL,
 FiscalYearQtr VARCHAR(8) NOT NULL
 --last_day_of_month DATE NOT NULL,
 --first_day_of_quarter DATE NOT NULL,
 --last_day_of_quarter DATE NOT NULL,
 --first_day_of_year DATE NOT NULL,
 --last_day_of_year DATE NOT NULL,
 --mmyyyy CHAR(6) NOT NULL,
 --mmddyyyy CHAR(10) NOT NULL
);

ALTER TABLE dw.DimDate ADD CONSTRAINT DateCK_PK PRIMARY KEY (DateCK);

