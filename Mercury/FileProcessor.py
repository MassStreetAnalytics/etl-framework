import os
import time
import yaml
import pandas as pd
from sqlalchemy import create_engine
import sys
sys.path.append(".")
from Email import Email

with open(os.getcwd() + '/config/config.yaml') as settings:
    cfg = yaml.load(settings)

connection_string = cfg['dns']


class FileProcessor:

    # move data in .csv files into staging tables

    def move_file(self, file, source, target, timestamp_file=''):
        """Move File from processing folder to archive folder"""

        # Moves the file even if timestamp is not given
        if timestamp_file == '':
            timestamp_file = self.add_timestamp(file)

        try:
            os.rename(os.getcwd() + '\\' + source + '\\' + file, os.getcwd() + '\\' + target + '\\' + timestamp_file)
        except Exception as e:
            subject = 'Error moving file'
            message = ' '.join(['Error moving file', file, 'to from processing folder to archive folder'])
            email = Email(subject, message)
            email.send_email()

    def add_timestamp(self, file, stamp=''):
        """Adds timestamp to processed files"""
        try:
            f = file.split('.')[0]
            if '_' in f:
                f = f.split('_')[0]

            if stamp != '':
                timestamp_file = f + '_' + stamp + '.csv'
            else:
                timestamp_file = f + '_' + time.strftime("%Y-%m-%d") + ".csv"
            return timestamp_file

        except Exception as e:
            subject = 'Timestamp Error'
            message = ' '.join(['There was an error adding a timestamp to file:', file])
            email = Email(subject, message)
            email.send_email()

    def stage_data(self, file, source, schema='qdl'):
        """Moves data in CSV to staging tables"""

        try:
            name = file.split('.')[0]

            df = pd.read_csv('/'.join([source, file]))
            engine = create_engine('mssql+pyodbc://' + connection_string)

            with engine.connect() as conn, conn.begin():
                df.to_sql(name=name, con=engine, schema=schema, if_exists='replace', index=False)

        except Exception as e:
            subject = 'Error staging data'
            message = ' '.join(['There was an error staging data in file:', file])
            email = Email(subject, message)
            email.send_email()

    def process_files(self, source='InterfaceAndExtractFiles', target='Archive'):
        for file in os.listdir(source):
            try:
                self.stage_data(file)
                self.move_file(file, source, target)
            except Exception as e:
                subject = 'Error processing file'
                message = ' '.join(['Unknown error processing file:', file])
                email = Email(subject, message)
                email.send_email()
