class DetailProvider:
    def get_detail(self, event_type: str) -> str:
        details = {
            "movie": "Movie Ticket: Avengers - Endgame, Screen 5, Seat 15A",
            "concert": "Concert Ticket: Coldplay, VIP Section, Seat 12B",
            "sports": "Sports Ticket: Lakers vs. Bulls, Court-side, Seat 3C",
        }
        return details.get(event_type, "Unknown event")

class PriceProvider:
    def get_price(self, event_type: str) -> float:
        prices = {
            "movie": 12.99,
            "concert": 99.99,
            "sports": 149.99,
        }
        return prices.get(event_type, 0.0)
