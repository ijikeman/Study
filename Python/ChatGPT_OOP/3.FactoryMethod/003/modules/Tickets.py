from modules.Interface import Ticket
from modules.Providers import ConcertDetailProvider, ConcertPriceProvider, SportsDetailProvider, SportsPriceProvider, MovieDetailProvider, MoviePriceProvider, ExhibitDetailProvider, ExhibitPriceProvider

class ConcertTicket(Ticket):
    def __init__(self):
        self.detail_provider = ConcertDetailProvider()
        self.price_provider = ConcertPriceProvider()
    
    def get_detail(self):
        return self.detail_provider.get_detail()

    def get_price(self):
        return self.price_provider.get_price()

class SportsTicket(Ticket):
    def __init__(self):
        self.detail_provider = SportsDetailProvider()
        self.price_provider = SportsPriceProvider()

    def get_detail(self):
        return self.detail_provider.get_detail()

    def get_price(self):
        return self.price_provider.get_price()

class MovieTicket(Ticket):
    def __init__(self):
        self.detail_provider = MovieDetailProvider()
        self.price_provider = MoviePriceProvider()

    def get_detail(self):
        return self.detail_provider.get_detail()

    def get_price(self):
        return self.price_provider.get_price()

class ExhibitTicket(Ticket):
    def __init__(self):
        self.detail_provider = ExhibitDetailProvider()
        self.price_provider = ExhibitPriceProvider()

    def get_detail(self):
        return self.detail_provider.get_detail()

    def get_price(self):
        return self.price_provider.get_price()
