from modules.Factory import TicketFactory
from modules.Tickets import ConcertTicket, SportsTicket, MovieTicket, ExhibitTicket

class ConcertTicketFactory(TicketFactory):
    def create_ticket(self):
        return ConcertTicket()

class SportsTicketFactory(TicketFactory):
    def create_ticket(self):
        return SportsTicket()

class MovieTicketFactory(TicketFactory):
    def create_ticket(self):
        return MovieTicket()

class ExhibitTicketFactory(TicketFactory):
    def create_ticket(self):
        return ExhibitTicket()
