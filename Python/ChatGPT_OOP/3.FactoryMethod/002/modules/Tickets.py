from modules.Interface import Ticket
from modules.Providers import DetailProvider, PriceProvider

class ConcertTicket(Ticket):
    def __init__(self, detail_provider: DetailProvider, price_provider: PriceProvider):
        self.detail_provider = detail_provider
        self.price_provider = price_provider
    
    def get_detail(self):
        return self.detail_provider.get_detail('concert')

    def get_price(self):
        return self.price_provider.get_price('concert')

class SportsTicket(Ticket):
    def __init__(self, detail_provider: DetailProvider, price_provider: PriceProvider):
        self.detail_provider = detail_provider
        self.price_provider = price_provider

    def get_detail(self):
        return self.detail_provider.get_detail('sports')

    def get_price(self):
        return self.price_provider.get_price('sports')

class MovieTicket(Ticket):
    def __init__(self, detail_provider: DetailProvider, price_provider: PriceProvider):
        self.detail_provider = detail_provider
        self.price_provider = price_provider

    def get_detail(self):
        return self.detail_provider.get_detail('movie')

    def get_price(self):
        return self.price_provider.get_price('movie')
