import unittest
import os
import shutil
import time
import sys
sys.path.append("..")
from FileProcessor import FileProcessor
import pandas as pd
from sqlalchemy import create_engine


class TestFileProcessor(unittest.TestCase):


    def test_move_file(self):

        self.assertFalse(os.path.isfile('InterfaceAndExtractFiles/ZACKS-MT.csv'))
        fp = FileProcessor()
        dir_src = '/'.join([os.getcwd(), 'TestFiles/'])
        dir_dst = 'InterfaceAndExtractFiles'

        shutil.copy(dir_src + 'ZACKS-MT.csv', dir_dst)
        self.assertTrue(os.path.isfile('InterfaceAndExtractFiles/ZACKS-MT.csv'))

        fp.move_file('ZACKS-MT.csv', 'InterfaceAndExtractFiles', 'Archive')

        self.assertFalse(os.path.isfile('InterfaceAndExtractFiles/ZACKS-MT.csv'))
        self.assertTrue(os.path.isfile('Archive/ZACKS-MT' + '_' + time.strftime("%Y-%m-%d") + '.csv'))


        for f in os.listdir('Archive/'):
            os.remove(os.path.join('Archive/', f))



    def test_timestamp(self):

        fp = FileProcessor()
        stamp = time.strftime("%Y-%m-%d")
        self.assertTrue(fp.add_timestamp('ZACKS-MT.csv', stamp), 'ZACKS-MT_' + stamp + '.csv')





    def test_stage_data(self):
        df = pd.read_csv('TestFiles/ZACKS-MT.csv')
        engine = create_engine('mssql+pyodbc://Test')

        with engine.connect() as conn, conn.begin():
            df.to_sql(name='test', con=engine, if_exists='replace', index=False)
            df2 = pd.read_sql_query('SELECT * FROM Test', conn)
            self.assertTrue(df.equals(df2))

if __name__ == '__main__':
    unittest.main()