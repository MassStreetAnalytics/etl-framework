# remove dups

This script contains the code that allows you to identify duplicate records in your data. It is only a stub as the process of deduping records is quite involved. This script contains the key piece of code you need. Once you have the ids of the dups and you've tagged each dup with a unique ID within the set of dups, you're good to go.

For a deeper discussion visit: 

{% embed url="https://tutorials.massstreetuniversity.com/transact-sql/solutions/removing-dups.html" %}

```text
--First we need keep track of the dups
--If you have a large amount of dups, use a
--temp table instead.
DECLARE @DuplicateIDs TABLE(RowNumber INT, ID BIGINT, TextDescription NVARCHAR(50))

INSERT INTO @DuplicateIDs(RowNumber, ID, TextDescription)
SELECT ROW_NUMBER() OVER (PARTITION BY TextDescription ORDER BY TextDescription) AS RowNumber, ID, TextDescription
FROM DimYourDimensionTable
```



