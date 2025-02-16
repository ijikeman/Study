class Seat:
    def __init__(self, section, number):
        self.section = section
        self.number = number
    
    def get_detail(self):
        return f"Section: {self.section}, Number: {self.number}"

class MovieSeat(Seat):
    def get_detail(self):
        return f"Movie Seat - {super().get_detail()}"

class ConcertSeat(Seat):
    def get_detail(self):
        return f"Concert Seat - {super().get_detail()}"

class SportsSeat(Seat):
    def get_detail(self):
        return f"Sports Seat - {super().get_detail()}"
