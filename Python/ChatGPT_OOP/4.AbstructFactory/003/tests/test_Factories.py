import unittest
import sys
import os

# モジュール検索パスに 'modules' ディレクトリを追加
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../modules')))

from Factories import MovieFactory, ConcertFactory, SportsFactory

class TestSeats(unittest.TestCase):
    def setUp(self):
        self.event_name = 'SuperMario'
        self.date = '2023.12.23'
        self.price = 30.99
        self.section = 'B'
        self.number = 7

    def test_movie_factory(self):
        factory = MovieFactory()
        ticket = factory.create_ticket(self.event_name, self.date, self.price)
        pattern = f"Movie Ticket - Name: {self.event_name}, Date: {self.date}, Price: {self.price}"
        self.assertEqual(ticket.get_detail(), pattern)

        seat = factory.create_seat(self.section, self.number)
        pattern = f"Movie Seat - Section: {self.section}, Number: {self.number}"
        self.assertEqual(seat.get_detail(), pattern)

    def test_concert_factory(self):
        factory = ConcertFactory()
        ticket = factory.create_ticket(self.event_name, self.date, self.price)
        pattern = f"Concert Ticket - Name: {self.event_name}, Date: {self.date}, Price: {self.price}"
        self.assertEqual(ticket.get_detail(), pattern)

        seat = factory.create_seat(self.section, self.number)
        pattern = f"Concert Seat - Section: {self.section}, Number: {self.number}"
        self.assertEqual(seat.get_detail(), pattern)

        ticket = factory.create_digital_ticket(self.event_name, self.date, self.price, self.section, self.number)
        pattern = f"Concert Ticket - Name: {self.event_name}, Date: {self.date}, Price: {self.price}"
        self.assertEqual(ticket.get_detail(), pattern)


    def test_sports_factory(self):
        factory = SportsFactory()
        ticket = factory.create_ticket(self.event_name, self.date, self.price)
        pattern = f"Sports Ticket - Name: {self.event_name}, Date: {self.date}, Price: {self.price}"
        self.assertEqual(ticket.get_detail(), pattern)

        seat = factory.create_seat(self.section, self.number)
        pattern = f"Sports Seat - Section: {self.section}, Number: {self.number}"
        self.assertEqual(seat.get_detail(), pattern)
