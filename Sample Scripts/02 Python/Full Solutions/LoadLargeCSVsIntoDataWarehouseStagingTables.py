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