import sys
import pandas as pd
import pyodbc as db

#Constants used to process data files
#Exsiting paths are examples only!


kFileDestination = 'C:/InterfaceAndExtractFiles/../Out/data.csv' #full path to processing Out folder

#small amounts of data
print("Starting: Processing Data")

#alter the below for your file.
#bulk load txt file to SQL Server
try:
    print("Connecting to SQL Server database")
    connection_string = 'DSN=ETL;'
    conn = db.connect(connection_string)
    csr = conn.cursor()
    sql = "SELECT * FROM [table or view]"
    df = pd.read_sql(sql,conn)
    conn.commit()
    csr.close()
    conn.close()
except Exception as e:
    print(e)

#Write File
df.to_csv(kFileDestination, sep="|",index=False)


# Script Complete
print("Complete: Processing Data")
