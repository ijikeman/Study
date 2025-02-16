from .Factory import TicketFactory
from .Tickets import ConcertTicket, SportsTicket, MovieTicket

class ConcertTicketFactory(TicketFactory):
    def create_ticket(self):
        return ConcertTicket()

class SportsTicketFactory(TicketFactory):
    def create_ticket(self):
        return SportsTicket()

class MovieTicketFactory(TicketFactory):
    def create_ticket(self):
        return MovieTicket()
