##Author: Reece Colbus
##Contact: rcolbus@mac.com as of 2Oct18
##Date Created: 16Sept18
##Description:
##Modification log:
##20190220 - Script generalized. - Bob Wakefield
## 1. Unzip zip file
## 2. Delete zip file

import os
import sys
import zipfile as zf

# Constants used to process data files
kFileZIP = ''
kFileCSV = ''
kFileTXT = ''
fileTimeStampedTXT = ''

kIAEFDestination = ''
kArchiveDestination = ''

kFileURL = ''
kSiteURL = ''

# unzipping file
try:
    print("Unzipping file:", kFileZIP)
    zip_ref = zf.ZipFile(kFileZIP, 'r')
    zip_ref.extractall(kIAEFDestination)
    zip_ref.close()
except:
    sys.exit("ERROR: Unable to unzip file {}".format(kFileZIP))

# delete zip file
try:
    print("Deleting  zip file: {}".format(kFileZIP))
    if os.path.isfile(kFileZIP):
        os.remove(kFileZIP)
except:
    sys.exit("ERROR: Unable  to delete file: {}".format(kFileZIP))