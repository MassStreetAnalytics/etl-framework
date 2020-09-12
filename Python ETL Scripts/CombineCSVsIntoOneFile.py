import shutil


path = r'data/US/market/merged_data'
outputFileName = ''


#import csv files from folder
allFiles = glob.glob(path + "/*.csv")
with open(outputFileName, 'wb') as outf:
    for i, fname in enumerate(allFiles):
        with open(fname, 'rb') as inf:
            if i != 0:
                inf.readline()  # Throw away header on all but first file
            # Block copy rest of file from input to output without parsing
            shutil.copyfileobj(inf, outf)
            print(fname + " has been imported.")