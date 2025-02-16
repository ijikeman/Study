from abc import ABC, abstractmethod
from .Interface import Ticket

class TicketFactory(ABC):
    @abstractmethod
    def create_ticket(self) -> Ticket:
        pass
