from abc import ABC, abstractmethod

class Ticket(ABC):
    @abstractmethod
    def get_detail(self) -> str:
        pass

    @abstractmethod
    def get_price(self) -> float:
        pass
