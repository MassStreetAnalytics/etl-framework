--Full instructions can be found at: https://tutorials.massstreetuniversity.com/transact-sql/solutions/removing-dups.html

--First we need keep track of the dups
--If you have a large amount of dups, use a
--temp table instead.
DECLARE @DuplicateIDs TABLE(RowNumber INT, ID BIGINT, TextDescription NVARCHAR(50))

INSERT INTO @DuplicateIDs(RowNumber, ID, TextDescription)
SELECT ROW_NUMBER() OVER (PARTITION BY TextDescription ORDER BY TextDescription) AS RowNumber, ID, TextDescription
FROM DimYourDimensionTable