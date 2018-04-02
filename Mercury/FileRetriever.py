'''
    File name: FileRetriever.py
    Author: Drew Huslig
    Date Created: 4/2/2018
    Date Last Modified: 4/2/18
    Python Version: 3.6.3
    Description: Retrieve a file from a remote source
'''

import os
import urllib.request
import sys
sys.path.append(".")
from Email import Email


class DuplicateFileError(Exception):
    pass


class FileRetriever:

    def download_file(self, url, target='FileDepot/In'):
        """Gets file from a remote source and places it into a landing folder"""

        try:
            f = url.split('/')
            name = f[-1].replace("_", "-")

            if not os.path.exists(target):
                os.makedirs(target)
            location = '/'.join([os.getcwd(), target, name])
            if(os.path.isfile(target + name)):
                raise DuplicateFileError('The file: ' + name + ' already exists in the file depot')
            else:
                urllib.request.urlretrieve(url, location)

        except DuplicateFileError as e:
            subject = 'Duplicate File in File Depot'
            message = e
            email = Email(subject, message)
            email.send_email()
        except Exception as e:
            subject = 'Error retrieving data'
            message = ' '.join(['There was an error downloading data from:', url])
            email = Email(subject, message)
            email.send_email()


