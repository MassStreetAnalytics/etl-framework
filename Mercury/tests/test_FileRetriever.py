import unittest
import os
import sys
sys.path.append("..")
from FileRetriever import FileRetriever


class TestFileRetriever(unittest.TestCase):

    def test_download_file(self):
        self.assertFalse(os.path.isfile('FileDepot/In/ufo.csv'))

        f = FileRetriever()
        f.download_file("https://raw.githubusercontent.com/justmarkham/pandas-videos/master/data/ufo.csv")

        self.assertTrue(os.path.isfile('FileDepot/In/ufo.csv'))

        for f in os.listdir('FileDepot/In/'):
            os.remove(os.path.join('FileDepot/In/', f))


if __name__ == '__main__':
    unittest.main()