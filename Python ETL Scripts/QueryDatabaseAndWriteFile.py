##Author: Bob Wakefield
##Contact: bob@MassStreet.net
##Date Created: 1May19
##Description: Queries database and writes file
##Modification log:


import os
import sys
import urllib
import datetime
import pandas as pd
import pyodbc as db
import zipfile as zf

#Constants used to process data files
#Exsiting paths are examples only!


kFileDestination = 'C:/InterfaceAndExtractFiles/../Out/data.csv' #full path to processing Out folder


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
except:
    sys.exit("ERROR: Unable to query table or write file")

#Write File
df.to_csv(kFileDestination, sep="|",index=False)


# Script Complete
print("Complete: Processing Data")
