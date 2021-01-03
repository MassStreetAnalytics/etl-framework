# QueryDatabaseAndWriteLargeFile

Use this process when you want to pull back a large amount of data and the small process was taking forever.

```text
import pyodbc as db
import os
import time
import csv

script_dir = os.getcwd()
data_directory = 'data\\'
example_directory = 'WriteLargeFilesExample\\'
file_name = 'EurostatDataOut.csv'
target_path = os.path.join(script_dir, data_directory, example_directory, file_name)

sql = 'SELECT * FROM EurostatData'

# Set up the connection.
print('Connecting to SQL Server database' + time.strftime(' %H:%M:%S'))
connection_string = 'DSN=ETL;'
conn = db.connect(connection_string)
print('Preparing database for update' + time.strftime(' %H:%M:%S'))
csr = conn.cursor()
csr.execute(sql)

with open(target_path, 'w', newline='') as f:
    writer = csv.writer(f, delimiter='|', quoting=csv.QUOTE_NONE)
    writer.writerow([x[0] for x in csr.description])
    for row in csr:
        writer.writerow(row)

print('Processing file {} complete.'.format(file_name) + time.strftime(' %H:%M:%S'))
conn.commit()
csr.close()
conn.close()
```



