class DetailProvider:
    def get_detail(self, event_type: str) -> str:
        details = {
            "movie": "Movie Ticket: Avengers - Endgame, Screen 5, Seat 15A",
            "concert": "Concert Ticket: Coldplay, VIP Section, Seat 12B",
            "sports": "Sports Ticket: Lakers vs. Bulls, Court-side, Seat 3C",
            "exhibit": "Exhibit Ticket: Anime Studio Art Exhibit, Admission Ticket",
        }
        return details.get(event_type, "Unknown event")

class PriceProvider:
    def get_price(self, event_type: str) -> float:
        prices = {
            "movie": 12.99,
            "concert": 99.99,
            "sports": 149.99,
            "exhibit": 30.99,
        }
        return prices.get(event_type, 0.0)

class MovieDetailProvider(DetailProvider):
    def __init__(self):
        self.event_type = 'movie'
    
    def get_detail(self):
        return super().get_detail(self.event_type)

class MoviePriceProvider(PriceProvider):
    def __init__(self):
        self.event_type = 'movie'
    
    def get_price(self):
        return super().get_price(self.event_type)

class SportsDetailProvider(DetailProvider):
    def __init__(self):
        self.event_type = 'sports'
    
    def get_detail(self):
        return super().get_detail(self.event_type)

class SportsPriceProvider(PriceProvider):
    def __init__(self):
        self.event_type = 'sports'
    
    def get_price(self):
        return super().get_price(self.event_type)

class ConcertDetailProvider(DetailProvider):
    def __init__(self):
        self.event_type = 'concert'
    
    def get_detail(self):
        return super().get_detail(self.event_type)

class ConcertPriceProvider(PriceProvider):
    def __init__(self):
        self.event_type = 'concert'
    
    def get_price(self):
        return super().get_price(self.event_type)

class ExhibitDetailProvider(DetailProvider):
    def __init__(self):
        self.event_type = 'exhibit'
    
    def get_detail(self):
        return super().get_detail(self.event_type)

class ExhibitPriceProvider(PriceProvider):
    def __init__(self):
        self.event_type = 'exhibit'
    
    def get_price(self):
        return super().get_price(self.event_type)
