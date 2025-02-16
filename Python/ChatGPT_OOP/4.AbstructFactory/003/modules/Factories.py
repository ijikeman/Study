from modules.Factory import TicketFactory, SeatFactory
from modules.Tickets import MovieTicket, ConcertTicket, SportsTicket
from modules.Seats import MovieSeat, ConcertSeat, SportsSeat
from modules.QR_Code import QR_Code

class ConcertFactory(TicketFactory, SeatFactory):
    def create_ticket(self, event_name, date, price):
        return ConcertTicket(event_name, date, price)

    def create_digital_ticket(self, event_name, date, price, section, number):
        qr_code = QR_Code.create_qr(event_name, date, price, section, number)
        return ConcertDigiatalTicket(event_name, date, price, qr_code)

    def create_seat(self, section, number):
        return ConcertSeat(section, number)

class MovieFactory(TicketFactory, SeatFactory):
    def create_ticket(self, event_name, date, price):
        return MovieTicket(event_name, date, price)

    def create_seat(self, section, number):
        return MovieSeat(section, number)

class SportsFactory(TicketFactory, SeatFactory):
    def create_ticket(self, event_name, date, price):
        return SportsTicket(event_name, date, price)

    def create_seat(self, section, number):
        return SportsSeat(section, number)
