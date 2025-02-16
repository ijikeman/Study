import unittest
import sys
import os

# モジュール検索パスに 'modules' ディレクトリを追加
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../modules')))

from Providers import DetailProvider, PriceProvider, MovieDetailProvider, MoviePriceProvider, SportsDetailProvider, SportsPriceProvider, ConcertDetailProvider, ConcertPriceProvider, ExhibitDetailProvider, ExhibitPriceProvider

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
        for event_type in ['movie', 'sports', 'concert', 'exhibit']:
            price = self.price_provider.get_price(event_type)
            self.assertIsNotNone(price)
            print(price)

    def test_get_price_unknown(self):
        price = self.price_provider.get_price('invalid')
        self.assertEqual(price, 0.0)

    def test_movie_detail_provider(self):
        detail_provider = MovieDetailProvider()
        self.assertTrue(detail_provider.get_detail())

    def test_movie_price_provider(self):
        price_provider = MoviePriceProvider()
        self.assertEqual(price_provider.get_price(), 12.99)

    def test_sports_detail_provider(self):
        detail_provider = SportsDetailProvider()
        self.assertTrue(detail_provider.get_detail())

    def test_sports_price_provider(self):
        price_provider = SportsPriceProvider()
        self.assertEqual(price_provider.get_price(), 149.99)

    def test_concert_detail_provider(self):
        detail_provider = ConcertDetailProvider()
        self.assertTrue(detail_provider.get_detail())

    def test_concert_price_provider(self):
        price_provider = ConcertPriceProvider()
        self.assertEqual(price_provider.get_price(), 99.99)

    def test_exhibit_detail_provider(self):
        detail_provider = ExhibitDetailProvider()
        self.assertTrue(detail_provider.get_detail())

    def test_exhibit_price_provider(self):
        price_provider = ExhibitPriceProvider()
        self.assertEqual(price_provider.get_price(), 30.99)
