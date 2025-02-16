import unittest
import sys
import os

# モジュール検索パスに 'modules' ディレクトリを追加
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../modules')))

from Seats import MovieSeat, SportsSeat, ConcertSeat

class TestSeats(unittest.TestCase):
    def setUp(self):
        self.section = 'B'
        self.number = 7

    def test_movie_seat(self):
        seat = MovieSeat(self.section, self.number)
        pattern = f"Movie Seat - Section: {self.section}, Number: {self.number}"
        self.assertEqual(seat.get_detail(), pattern)

    def test_concert_seat(self):
        seat = ConcertSeat(self.section, self.number)
        pattern = f"Concert Seat - Section: {self.section}, Number: {self.number}"
        self.assertEqual(seat.get_detail(), pattern)

    def test_sports_seat(self):
        seat = SportsSeat(self.section, self.number)
        pattern = f"Sports Seat - Section: {self.section}, Number: {self.number}"
        self.assertEqual(seat.get_detail(), pattern)
