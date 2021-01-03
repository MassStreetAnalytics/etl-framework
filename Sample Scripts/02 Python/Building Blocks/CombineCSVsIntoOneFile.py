import shutil
import glob
import os

root_directory = #populated from configuration
app_directory = #populated from configuration
source_directory = #as specified
target_directory = #as specified
output_file_name = 'YourFileName.csv'

source_path = os.path.join(root_directory, app_directory, source_directory)
target_path = os.path.join(root_directory, app_directory, target_directory, output_file_name)

#change file extention if necessary
source_files = glob.glob(source_path + '*.csv')

with open(target_path, 'wb') as outfile:
    for i, fname in enumerate(source_files):
        with open(fname, 'rb') as infile:
            if i != 0:
                infile.readline()  # Throw away header on all but first file

            shutil.copyfileobj(infile, outfile)  # Block copy rest of file from input to output without parsing

# clean input directory
for i, fname in enumerate(source_files):
    os.remove(fname)