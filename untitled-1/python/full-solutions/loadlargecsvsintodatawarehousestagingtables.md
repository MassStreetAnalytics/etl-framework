# LoadLargeCSVsIntoDataWarehouseStagingTables

BULK INSERT is a nice SQL statement to load large amounts of data from a flat file into a database table. The problem with BULK INSERT is that the schema of the file and the schema of the table have to be the same. That is problematic when the table you are loading has audit columns.

The solution is to create a view based on the table that only has the columns that you want to load. You name the view and the table the same. The table should be in a schema. The view should be in the dbo schema. That way, you can reference both with the same name, and SQL Server knows when you are referring to the view or the table.

When you write your BULK INSERT statement, you reference the view. That will load the actual table. This script performs that task.

In the code shown below, replace the place holder values with your values.

```text
drop_index_sql = 'ALTER TABLE [YourSchema].[YourStageTable] DROP CONSTRAINT [PK_YourStageTable] WITH ( ONLINE = OFF )'
add_index_sql = 'ALTER TABLE [YourSchema].[YourStageTable] ADD  CONSTRAINT [PK_YourStageTable] PRIMARY KEY CLUSTERED'
sql = "BULK INSERT YourStageTableView FROM '" + FullSourcePath + "' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a', FIRSTROW = 2, TABLOCK, BATCHSIZE = 100000)"
csr.execute('TRUNCATE TABLE [YourSchema].[YourStageTable]')
```

Full script.

```text
import os
import pyodbc as db
import time

#The following four varaibles should be
#populated by configuration
WarehouseProcessingRootDirectory = ''
BusinessDirectory = ''
ProcessDirectory = ''

DataDirectory = 'In\\'
FileName = ''

FullSourcePath = os.path.join(WarehouseProcessingRootDirectory, BusinessDirectory, ProcessDirectory, DataDirectory, FileName)

#Build SQL Statements
drop_index_sql = 'ALTER TABLE [YourSchema].[YourStageTable] DROP CONSTRAINT [PK_YourStageTable] WITH ( ONLINE = OFF )'

add_index_sql = 'ALTER TABLE [YourSchema].[YourStageTable] ADD  CONSTRAINT [PK_YourStageTable] PRIMARY KEY CLUSTERED'
add_index_sql = add_index_sql + '([ETLKey] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,'
add_index_sql = add_index_sql + 'SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON,'
add_index_sql = add_index_sql + 'ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]'

sql = "BULK INSERT YourStageTableView FROM '" + FullSourcePath + "' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a', FIRSTROW = 2, TABLOCK, BATCHSIZE = 100000)"

#Set up the connection.
print('Connecting to SQL Server database' + time.strftime(' %H:%M:%S'))
connection_string = 'DSN=ETL;'
conn = db.connect(connection_string)
print('Preparing database for update' + time.strftime(' %H:%M:%S'))
csr = conn.cursor()

#now let's load the file
print('Begin processing {}.'.format(FileName) + time.strftime(' %H:%M:%S'))
csr.execute('TRUNCATE TABLE [YourSchema].[YourStageTable]')
csr.execute(drop_index_sql)
print('Updating staging')
csr.execute(sql)
csr.execute(add_index_sql)
print('Processing file {} complete.'.format(FileName) + time.strftime(' %H:%M:%S'))
conn.commit()
csr.close()
conn.close()

print('Complete: Processing Data'  + time.strftime(' %H:%M:%S'))
```

