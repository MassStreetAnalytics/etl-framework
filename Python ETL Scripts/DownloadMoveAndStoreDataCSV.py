##Author: Reece Colbus
##Contact: rcolbus@mac.com as of 2Oct18
##Date Created: 16Sept18
##Description: Downloads and processes a CSV
##Modification log:
##20190220: Script generalized. - Bob Wakefield
## 1. Verify site and internet connection
## 2. Download file
## 3. Load csv file
##    Create downloadTimeStamp
##    Update AsOfMonth column with downloadTimeStamp
##    Create | delimitedfile with downloadTimeStamp prefix
## 4. Delete  csv file
## 5. Update SQL Server database
## 6. Create zip file for txt date
## 7. Delete txt file
## 8. Zips and archives files

import os
import sys
import urllib
import datetime
import pandas as pd
import pyodbc as db
import zipfile as zf

#Constants used to process data files
#Exsiting paths are examples only!

kFileInitial = 'C:/FileDepot/../data.csv' #Full path of CSV file in public facing folder
kFileCSV = 'C:/InterfaceAndExtractFiles/../data.csv' #Full path of CSV file in processing folder
kFileTXT = 'C:/InterfaceAndExtractFiles/../data.txt' #Full path of resulting text file in processing folder
fileTimeStampedTXT = ''

kIAEFDestination = 'C:/InterfaceAndExtractFiles/../In/' #path to processing IN folder
kArchiveDestination = 'C:/InterfaceAndExtractFiles/../Archive/' #path to archive folder

kFileURL = 'https://url.com/data.csv' #URL of File
kSiteURL = 'https://url.com' #URL of Site

print("Starting: Processing GetPSD_Data")

# verify that the  site is available and the internet connection is working
try:
    print("Validating status of site and internet connection")
    urllib.request.urlopen(kSiteURL)
except:
    sys.exit("ERROR: The  site {} is unavailable.  Please check your internet connection.".format(kSiteURL))

# download the file
try:
    print("Downloading file to:", kFileInitial)
    urllib.request.urlretrieve(kFileURL, kFileInitial)
except:
    sys.exit("ERROR: Unable to download the file: {}".format(kFileURL))


# Read csv data into pandas and write | delimited txt file
try:
    print("Reading csv file: {}".format(kFileCSV))
    df = pd.read_csv(kFileCSV,index_col=False)
    downloadTimeStamp = datetime.datetime.today().strftime('%Y%m')
    print("Setting download timestamp")
    df['AsOfMonth'] = downloadTimeStamp
    fileTimeStampedTXT = kIAEFDestination + downloadTimeStamp + "data.txt"
    print("Writing txt file to: {}".format(fileTimeStampedTXT))
    df.to_csv(fileTimeStampedTXT, sep="|",index=False)
except:
    sys.exit("ERROR: Unable to read file and create txt file: {}".format(kFileTXT))

# delete csv file
try:
    print("Deleting csv file: {}".format(kFileCSV))
    if os.path.isfile(kFileCSV):
        os.remove(kFileCSV)
except:
    sys.exit("ERROR: Unable to delete file: {}".format(kFileCSV))

#alter the below for your file.
#index table only if necessary
#bulk load txt file to SQL Server
try:
    print("Connecting to SQL Server database")
    connection_string = 'DSN=ETL;'
    conn = db.connect(connection_string)
    print("Preparing database for update")
    csr = conn.cursor()
    csr.execute("DELETE FROM [stage table] WHERE Processed = 1")
    csr.execute("DROP INDEX IF EXISTS [index name] ON [stage table]")
    sql = "BULK INSERT [stage table view] FROM '" + fileTimeStampedTXT + "' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a', FIRSTROW = 2)"
    print("Update database with {} file data.".format(fileTimeStampedTXT))
    csr.execute(sql)
    print("Creating index on SQL table")
    csr.execute("CREATE NONCLUSTERED INDEX [index name] ON [stage table]([column name])")
    print("Completing SQL Server update")
    conn.commit()
    csr.close()
    conn.close()
except:
    sys.exit("ERROR: Unable to update SQL Server stage table.")

# zip txt file to archive
try:
    zipFile = kArchiveDestination + downloadTimeStamp + "data.zip"
    print("Creating zip file for txt file archive")
    archive = zf.ZipFile(zipFile, "w")
    archive.write(fileTimeStampedTXT, os.path.basename(fileTimeStampedTXT))
    archive.close
except:
    sys.exit("ERROR: unable to create zip file for file: {}".format(fileTimeStampedTXT))

# delete txt file
try:
    print("Deleting  txt file: {}".format(fileTimeStampedTXT))
    if os.path.isfile(fileTimeStampedTXT):
        os.remove(fileTimeStampedTXT)
except:
    sys.exit("ERROR: Unable to delete file: {}".format(fileTimeStampedTXT))

# Script Complete
print("Complete: Processing Data")
