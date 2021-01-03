--Split a batch up into chunks using a cursor.
--This method can be used for most any large table with some modifications
--It could also be refined further with an @Day variable (for example)
--This is for the case where you already have the data in a table
--and are ready to process it. Obviously, if you have a large flat file,
--you can just use BULK INSERT.


DECLARE @Year INT
DECLARE @Month INT

DECLARE BatchingCursor CURSOR FOR
SELECT DISTINCT YEAR([SomeDateField]),MONTH([SomeDateField])
FROM [Sometable];


OPEN BatchingCursor;
FETCH NEXT FROM BatchingCursor INTO @Year, @Month;
WHILE @@FETCH_STATUS = 0
BEGIN

--the transaction is optional
BEGIN TRANSACTION
--All logic goes in here
--Any select statements from [Sometable] need to be suffixed with:
--WHERE Year([SomeDateField])=@Year AND Month([SomeDateField])=@Month   
COMMIT TRANSACTION

FETCH NEXT FROM BatchingCursor INTO @Year, @Month;
END;
CLOSE BatchingCursor;
DEALLOCATE BatchingCursor;
GO
