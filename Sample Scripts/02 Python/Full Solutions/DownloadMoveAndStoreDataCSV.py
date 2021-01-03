import os
import sys
import urllib
import datetime
import pandas as pd
import pyodbc as db
import zipfile as zf

#The following four varaibles should be
#populated by configuration
FileExchangeRootDirectory = ''
WarehouseProcessingRootDirectory = ''
BusinessDirectory = ''
ProcessDirectory = ''

DataDirectory = 'In\\'
ArchiveDirectory = 'Archive\\'
FileName = ''
fileTimeStampedTXT = ''

FileURL = 'https://url.com/data.csv' #URL of File
SiteURL = 'https://url.com' #URL of Site


FullSourcePath = os.path.join(FileExchangeRootDirectory, BusinessDirectory, ProcessDirectory, DataDirectory, FileName)
DestinationDirectory = os.path.join(WarehouseProcessingRootDirectory, BusinessDirectory, ProcessDirectory, DataDirectory)
ArchiveDestinationDirectory = os.path.join(WarehouseProcessingRootDirectory, BusinessDirectory, ProcessDirectory, ArchiveDirectory)


print("Starting: Processing Data")

# verify that the  site is available and the internet connection is working
try:
    print("Validating status of site and internet connection")
    urllib.request.urlopen(SiteURL)
except:
    sys.exit("ERROR: The  site {} is unavailable.  Please check your internet connection.".format(SiteURL))

# download the file
try:
    print("Downloading file to:", FullSourcePath)
    urllib.request.urlretrieve(FileURL, FullSourcePath)
except:
    sys.exit("ERROR: Unable to download the file: {}".format(FileURL))


# Read csv data into pandas and write | delimited txt file
try:
    print("Reading csv file: {}".format(FullSourcePath))
    df = pd.read_csv(FullSourcePath,index_col=False,type=str)
    downloadTimeStamp = datetime.datetime.today().strftime('%Y%m')
    print("Setting download timestamp")
    df['AsOfMonth'] = downloadTimeStamp
    fileTimeStampedTXT = DestinationDirectory + FileName + downloadTimeStamp + "_data.txt"
    print("Writing txt file to: {}".format(fileTimeStampedTXT))
    df.to_csv(fileTimeStampedTXT, sep="|",index=False)
except:
    sys.exit("ERROR: Unable to read file and create txt file: {}".format(FullSourcePath))

# delete csv file
try:
    print("Deleting csv file: {}".format(FullSourcePath))
    if os.path.isfile(FullSourcePath):
        os.remove(FullSourcePath)
except:
    sys.exit("ERROR: Unable to delete file: {}".format(FullSourcePath))

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
    zipFile = ArchiveDestinationDirectory + FileName + downloadTimeStamp + "data.zip"
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
