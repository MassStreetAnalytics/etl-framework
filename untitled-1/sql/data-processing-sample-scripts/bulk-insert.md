# bulk insert

Use bulk insert to load large CSVs. This script is fairly straight forward. Just update YourSchema.Your Table and YourFileName.csv. 

For specific usage check out:

{% embed url="https://tutorials.massstreetuniversity.com/transact-sql/advanced/bulk-insert.html" %}

{% embed url="https://tutorials.massstreetuniversity.com/transact-sql/solutions/load-large-files.html" %}

```text
BULK INSERT YourSchema.YourTable
FROM 'E:\YourFileName.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a',
FIRSTROW = 2
);
```



