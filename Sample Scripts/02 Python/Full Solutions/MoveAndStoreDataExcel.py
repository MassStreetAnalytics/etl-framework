#See documenatation for use of this script.import osimport sysimport datetimeimport pandas as pdimport pyodbc as dbimport zipfile as zf#The following four varaibles should be#populated by configurationFileExchangeRootDirectory = ''WarehouseProcessingRootDirectory = ''BusinessDirectory = ''ProcessDirectory = ''DataDirectory = 'In\\'ArchiveDirectory = 'Archive\\'FileName = ''fileTimeStampedTXT = ''FullSourcePath = os.path.join(FileExchangeRootDirectory, BusinessDirectory, ProcessDirectory, DataDirectory, FileName)DestinationDirectory = os.path.join(WarehouseProcessingRootDirectory, BusinessDirectory, ProcessDirectory, DataDirectory)ArchiveDestinationDirectory = os.path.join(WarehouseProcessingRootDirectory, BusinessDirectory, ProcessDirectory, ArchiveDirectory)print("Starting: Processing data")# Check if required file existsif not os.path.isfile(FullSourcePath):    sys.exit("ERROR: Unable to find file {}".format(FullSourcePath))# Read excel data into pandas and write | delimited txt filetry:    print("Reading Excel file: {}".format(FullSourcePath))    df = pd.read_excel(FullSourcePath, sheet_name="DATASET")    # set timestamp for file processing    print("Setting process timestamp")    processTimeStamp = datetime.datetime.today().strftime('%Y%m%d')    # Create txt filename wih timestamp    fileTimeStampedTXT = DestinationDirectory + processTimeStamp + "_data.txt"    print("Writing txt file to: {}".format(fileTimeStampedTXT))    df.to_csv(fileTimeStampedTXT, sep="|", index=False)except Exception as e:    print(e)# delete xlsx filetry:    print("Deleting  xlsx file: {}".format(FullSourcePath))    if os.path.isfile(FullSourcePath):        os.remove(FullSourcePath)except Exception as e:    print(e)# bulk load txt file to SQL Servertry:    print("Connecting to SQL Server database")    connection_string = 'DSN=ETL;'    conn = db.connect(connection_string)    print("Preparing database for update")    csr = conn.cursor()    csr.execute("DELETE FROM [stage table] WHERE Processed = 1")    print("Preparing bulk insert update")    sql = "BULK INSERT [stage table view] FROM '" + fileTimeStampedTXT + "' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a', FIRSTROW = 2)"    print("Update database with {} file data.".format(fileTimeStampedTXT))    csr.execute(sql)    conn.commit()    csr.close()    conn.close()except Exception as e:    print(e)# zip txt file to archivetry:    zipFile = ArchiveDestinationDirectory + processTimeStamp + "__data.zip"    print("Creating zip file for txt file archive")    archive = zf.ZipFile(zipFile, "w")    archive.write(fileTimeStampedTXT, os.path.basename(fileTimeStampedTXT))    archive.closeexcept Exception as e:    print(e)# delete txt filetry:    print("Deleting  txt file: {}".format(fileTimeStampedTXT))    if os.path.isfile(fileTimeStampedTXT):        os.remove(fileTimeStampedTXT)except Exception as e:    print(e)# Script Completeprint("Complete: Processing Data")