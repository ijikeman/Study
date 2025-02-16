import unittest
import sys
import os

# モジュール検索パスに 'modules' ディレクトリを追加
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../modules')))

from Tickets import MovieTicket, SportsTicket, ConcertTicket

class TestTickets(unittest.TestCase):
    def setUp(self):
        self.event_name = 'SuperMario'
        self.date = '2023.12.23'
        self.price = 30.99

    def test_movie_ticket(self):
        ticket = MovieTicket(self.event_name, self.date, self.price)
        pattern = f"Movie Ticket - Name: {self.event_name}, Date: {self.date}, Price: {self.price}"
        self.assertEqual(ticket.get_detail(), pattern)

    def test_concert_ticket(self):
        ticket = ConcertTicket(self.event_name, self.date, self.price)
        pattern = f"Concert Ticket - Name: {self.event_name}, Date: {self.date}, Price: {self.price}"
        self.assertEqual(ticket.get_detail(), pattern)

    def test_sports_ticket(self):
        ticket = SportsTicket(self.event_name, self.date, self.price)
        pattern = f"Sports Ticket - Name: {self.event_name}, Date: {self.date}, Price: {self.price}"
        self.assertEqual(ticket.get_detail(), pattern)
