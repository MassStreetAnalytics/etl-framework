'''
    File name: ETL.py
    Author: Drew Huslig
    Date Created: 4/2/2018
    Date Last Modified: 4/2/18
    Python Version: 3.6.3
    Description: Entry point for Mercury Project.
'''

from FileConverter import FileConverter as fc
from FileProcessor import FileProcessor as fp
from FileRetriever import FileRetriever as fr

def FileConverter():
    return fc()

def FileProcessor():
    return fp()

def FileRetriever():
    return fr()