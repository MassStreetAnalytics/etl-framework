import unittest
import os
import shutil
import sys
sys.path.append("..")
import FileConverter


class TestFileRetriever(unittest.TestCase):

    def test_CSV(self):
        if not os.path.exists('InterfaceAndExtractFiles'):
            os.makedirs('InterfaceAndExtractFiles')
        dir_src = '/'.join([os.getcwd(), 'TestFiles/'])
        dir_dst = 'FileDepot/In'

        shutil.copy(dir_src + 'ZACKS-MT.csv', dir_dst)
        csv = FileConverter.CSV('ZACKS-MT.csv')
        csv.move_file()

        self.assertTrue(os.path.isfile('InterfaceAndExtractFiles/ZACKS-MT.csv'))

        for f in os.listdir('InterfaceAndExtractFiles/'):
            os.remove(os.path.join('InterfaceAndExtractFiles/', f))


if __name__ == '__main__':
    unittest.main()
