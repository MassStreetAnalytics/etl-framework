##Author: Bob Wakefield
##Date Created: 4Oct19
##Description: Converts Angela's files to csv
##Modification log:



import os
import sys
import datetime
import pandas as pd
import pyodbc as db
import zipfile as zf

sourcePath = 'E:/Opt/TNPReasonDataHistoricalLoad/Data/Excel'
destinationPath = 'E:/Opt/TNPReasonDataHistoricalLoad/Data/CSV'

for path, directories, files in os.walk(sourcePath):
    for fn in files:
        print("Reading Excel file: {}".format(fn))

        df = pd.read_excel(os.path.join(sourcePath, fn), sheet_name="DATASET")

        FullPath = destinationPath + "/" + os.path.splitext(fn)[0] + ".csv"

        print("Writing txt file to: {}".format(FullPath))

        df.to_csv(FullPath, sep="|", index=False)





