# ConvertExcelToCSV

Excel files are messy. Let's go ahead and convert those messy Excel files to nice clean pipe delimited CSVs.

```text
import os
import pandas as pd


sourcePath = #as specified
destinationPath = #as specified

for path, directories, files in os.walk(sourcePath):
    for fn in files:
        print("Reading Excel file: {}".format(fn))

        df = pd.read_excel(os.path.join(sourcePath, fn), sheet_name="DATASET")

        FullPath = destinationPath + "/" + os.path.splitext(fn)[0] + ".csv"

        print("Writing txt file to: {}".format(FullPath))

        df.to_csv(FullPath, sep="|", index=False)
```

