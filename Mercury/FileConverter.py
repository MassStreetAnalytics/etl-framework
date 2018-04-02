'''
    File name: FileConverter.py
    Author: Drew Huslig
    Date Created: 4/2/2018
    Date Last Modified: 4/2/18
    Python Version: 3.6.3
    Description: Prepare files by converting them to a .csv if necessary and places them in a processing folder
'''

import os
import sys
sys.path.append(".")
from Email import Email


class FileConverter:


    def convert_files(source='FileDepot/In', target='InterfaceAndExtractFiles'):
        """Iterates over a folder and converts the file to a .csv if necessary"""

        if not os.path.exists(target):
            os.makedirs(target)

        for file in os.listdir(source):
            # Creates new instance of an appropriate file type
            if file.endswith(".csv"):
                f = CSV(file, source, target)
                f.move_file()
            # Else detect file type and convert to csv
            #elif file.endswith(".xml"):
                #XML(file, source, target)


class CSV:

    def __init__(self, file, source='FileDepot/In', target='InterfaceAndExtractFiles'):
        """Initializes File Object"""
        self.file = file
        self.source = source
        self.target = target

    def move_file(self):
        """Moves file from landing folder to processing folder"""
        try:
            os.rename('/'.join([os.getcwd(), self.source, self.file]), '/'.join([os.getcwd(), self.target, self.file]))
        except Exception as e:
            subject = 'Error moving file'
            message = ' '.join(['Error moving file from landing folder to processing folder:', self.file])
            email = Email(subject, message)
            email.send_email()