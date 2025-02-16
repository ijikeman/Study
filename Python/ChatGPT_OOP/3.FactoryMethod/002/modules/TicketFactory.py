from modules.Factory import TicketFactory
from modules.Tickets import ConcertTicket, SportsTicket, MovieTicket
from modules.Providers import DetailProvider, PriceProvider

class ConcertTicketFactory(TicketFactory):
    def __init__(self):
        self.detail_provider = DetailProvider()
        self.price_provider = PriceProvider()

    def create_ticket(self):
        return ConcertTicket(self.detail_provider, self.price_provider)

class SportsTicketFactory(TicketFactory):
    def __init__(self):
        self.detail_provider = DetailProvider()
        self.price_provider = PriceProvider()

    def create_ticket(self):
        return SportsTicket(self.detail_provider, self.price_provider)

class MovieTicketFactory(TicketFactory):
    def __init__(self):
        self.detail_provider = DetailProvider()
        self.price_provider = PriceProvider()

    def create_ticket(self):
        return MovieTicket(self.detail_provider, self.price_provider)
