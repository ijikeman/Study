import unittest
import sys
import os

# モジュール検索パスに 'modules' ディレクトリを追加
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../modules')))

from TicketFactory import ConcertTicketFactory, MovieTicketFactory, SportsTicketFactory, ExhibitTicketFactory

class TicketFactory_Test(unittest.TestCase):
    def test_concert_ticket_factory(self):
        factory = ConcertTicketFactory()
        ticket = factory.create_ticket()
        self.assertTrue(ticket.get_detail())
        self.assertEqual(ticket.get_price(), 99.99)

    def test_movie_ticket_factory(self):
        factory = MovieTicketFactory()
        ticket = factory.create_ticket()
        self.assertTrue(ticket.get_detail())
        self.assertEqual(ticket.get_price(), 12.99)

    def test_sports_ticket_factory(self):
        factory = SportsTicketFactory()
        ticket = factory.create_ticket()
        self.assertTrue(ticket.get_detail())
        self.assertEqual(ticket.get_price(), 149.99)

    def test_exhibit_ticket_factory(self):
        factory = ExhibitTicketFactory()
        ticket = factory.create_ticket()
        self.assertTrue(ticket.get_detail())
        self.assertEqual(ticket.get_price(), 30.99)
