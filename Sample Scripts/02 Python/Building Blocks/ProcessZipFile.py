import urllib.request
import os
from pyunpack import Archive

url = 'https://query.data.world/s/vb53nuuux6umwmccbwlajvlzttmz3q'
script_dir = os.getcwd()
file_name = 'Eurostat.zip'
data_directory = 'data\\'
example_directory = 'ZipFileExample\\'
abs_file_path = os.path.join(script_dir, data_directory, example_directory, file_name)
abs_directory_path = os.path.join(script_dir, data_directory, example_directory)

with urllib.request.urlopen(url) as dl_file:
    with open(abs_file_path, 'wb') as out_file:
        out_file.write(dl_file.read())

Archive(abs_file_path).extractall(abs_directory_path)
os.remove(abs_file_path)