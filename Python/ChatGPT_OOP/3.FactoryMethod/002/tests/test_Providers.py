import unittest
import sys
import os

# モジュール検索パスに 'modules' ディレクトリを追加
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../modules')))

from Providers import DetailProvider, PriceProvider

class Proviers_Test(unittest.TestCase):
    def setUp(self):
        self.detail_provider = DetailProvider()
        self.price_provider = PriceProvider()
    
    def test_get_detail(self):
        for event_type in ['movie', 'sports', 'concert']:
            detail = self.detail_provider.get_detail(event_type)
            self.assertIsNotNone(detail)
            print(detail)

    def test_get_detail_unknown(self):
        detail = self.detail_provider.get_detail('invalid')
        self.assertEqual(detail, 'Unknown event')

    def test_get_price(self):
        for event_type in ['movie', 'sports', 'concert']:
            price = self.price_provider.get_price(event_type)
            self.assertIsNotNone(price)
            print(price)

    def test_get_price_unknown(self):
        price = self.price_provider.get_price('invalid')
        self.assertEqual(price, 0.0)
