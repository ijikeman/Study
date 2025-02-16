from abc import ABC, abstractmethod
from modules.Interface import Ticket
from modules.Providers import DetailProvider, PriceProvider

class TicketFactory(ABC):
    def __init__(self, detail_provider: DetailProvider, price_provider: PriceProvider) -> Ticket:
        self.detail_provider = detail_provider
        self.price_provider = price_provider

    @abstractmethod
    def create_ticket(self) -> Ticket:
        pass
