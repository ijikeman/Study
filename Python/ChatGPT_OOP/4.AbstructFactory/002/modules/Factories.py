from modules.Factory import TicketFactory, SeatFactory
from modules.Tickets import MovieTicket, ConcertTicket
from modules.Seats import MovieSeat, ConcertSeat

# ConcertTicketFactory, MovieTicketFactoryを複数のcreate_*()を持つFactoryへ変更
class ConcertFactory(TicketFactory, SeatFactory):
    def create_ticket(self, event_name, date, price):
        return ConcertTicket(event_name, date, price)

    def create_seat(self, section, number):
        return ConcertSeat(section, number)

class MovieFactory(TicketFactory, SeatFactory):
    def create_ticket(self, event_name, date, price):
        return MovieTicket(event_name, date, price)

    def create_seat(self, section, number):
        return MovieSeat(section, number)
