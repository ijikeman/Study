class Ticket:
    def __init__(self, event_name, date, price):
        self.event_name = event_name
        self.date = date
        self.price = price
    
    def get_detail(self):
        return f"Name: {self.event_name}, Date: {self.date}, Price: {self.price}"


class ConcertTicket(Ticket):
    def get_detail(self):
        return f"Concert - {super().get_detail()}"

class MovieTicket(Ticket):
    def get_detail(self):
        return f"Movie - {super().get_detail()}"
