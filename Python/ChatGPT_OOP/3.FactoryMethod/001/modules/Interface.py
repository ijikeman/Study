from abc import ABC, abstractmethod

class Ticket(ABC):
    def __init__(self):
        self.get_client_code = None
        pass
    
    @abstractmethod
    def get_event_details(self) -> str:
        pass

    @abstractmethod
    def get_client_code(self) -> str:
        pass
