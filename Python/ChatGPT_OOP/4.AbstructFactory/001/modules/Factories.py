from modules.Factory import TicketFactory
from modules.Tickets import MovieTicket, ConcertTicket

class ConcertTicketFactory(TicketFactory):
    def create_ticket(self, event_name, date, price):
        return ConcertTicket(event_name, date, price)

class MovieTicketFactory(TicketFactory):
    def create_ticket(self, event_name, date, price):
        return MovieTicket(event_name, date, price)
