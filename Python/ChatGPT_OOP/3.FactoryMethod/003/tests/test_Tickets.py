import unittest
import sys
import os

# モジュール検索パスに 'modules' ディレクトリを追加
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../modules')))

# sample.pyのSampleクラスをテストする
from Tickets import MovieTicket, ConcertTicket, SportsTicket, ExhibitTicket

class Tickets_Test(unittest.TestCase):
    def test_create_MovieTicket(self):
        self.ticket = MovieTicket()
        self.assertEqual(self.ticket.get_price(), 12.99)
        self.assertTrue(self.ticket.get_detail())

    def test_create_ConcertTicket(self):
        self.ticket = ConcertTicket()
        self.assertEqual(self.ticket.get_price(), 99.99)
        self.assertTrue(self.ticket.get_detail())

    def test_create_SportsTicket(self):
        self.ticket = SportsTicket()
        self.assertEqual(self.ticket.get_price(), 149.99)
        self.assertTrue(self.ticket.get_detail())

    def test_create_ExhibitTicket(self):
        self.ticket = ExhibitTicket()
        self.assertEqual(self.ticket.get_price(), 30.99)
        self.assertTrue(self.ticket.get_detail())
