# LoopingOverFilesInADirectory

Looping over files in a directory is a basic ETL task. This script offers three different methods depending on your use case.

```text
import os

#Loop Over Everything In Folder
script_dir = os.getcwd()
data_directory = 'data\\'
example_directory = 'FileLoopExample\\'
path = os.path.join(script_dir,data_directory,example_directory)

for filename in os.listdir(path):
    print(filename)


#Loop Over Files With A Specific File Extention
script_dir = os.getcwd()
data_directory = 'data\\'
example_directory = 'FileLoopExample\\'
path = os.path.join(script_dir,data_directory,example_directory)

for filename in os.listdir(path):
    if filename.endswith('.csv'):
        print(filename)

#Loop Over Files In Subdirectories Recursively
import os

script_dir = os.getcwd()
data_directory = 'data\\'
example_directory = 'FileLoopExample\\'
path = os.path.join(script_dir,data_directory,example_directory)

for subdir, dirs, files in os.walk(path):
     for filename in files:
            print(filename)
```



