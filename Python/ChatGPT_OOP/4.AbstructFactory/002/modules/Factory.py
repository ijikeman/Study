from abc import ABC, abstractmethod

class TicketFactory(ABC):
    @abstractmethod
    def create_ticket(self, event_name, date, price):
        pass

class SeatFactory(ABC):
    @abstractmethod
    def create_seat(self, section, number):
        pass
