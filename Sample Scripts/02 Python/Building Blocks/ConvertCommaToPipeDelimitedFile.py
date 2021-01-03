import os
import pandas as pd

url = 'https://query.data.world/s/paxejv4t6pn3el4ttskmx7rhxhz5ho'
script_dir = os.getcwd()
data_directory = 'data\\'
example_directory = 'PipeDelimitedExample\\'
file_name = 'flights.csv'
file_path = os.path.join(script_dir,data_directory,example_directory,file_name)

# Read csv data into pandas and write | delimited txt file
df = pd.read_csv(url,index_col=False, dtype=str)
df.to_csv(file_path, sep="|",index=False)