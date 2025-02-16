from abc import ABC, abstractmethod
from modules.Interface import Ticket

class TicketFactory(ABC):
    @abstractmethod
    def create_ticket(self) -> Ticket:
        pass
