from .Interface import Ticket

class ConcertTicket(Ticket):
    def __init__(self):
        self.client_code = 1

    def get_event_details(self):
        return "concert show"

    def get_client_code(self):
        return self.client_code

class SportsTicket(Ticket):
    def __init__(self):
        self.client_code = 10

    def get_event_details(self):
        return "sports game"

    def get_client_code(self):
        return self.client_code

class MovieTicket(Ticket):
    def __init__(self):
        self.client_code = 100

    def get_event_details(self):
        return "movie show"

    def get_client_code(self):
        return self.client_code
