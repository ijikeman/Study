"""
シナリオ: チケットシステムの拡張
現在のシステムには、コンサートチケットと映画チケット、そしてそれぞれの座席が含まれています。ここに新しい要件が追加されました。
スポーツイベントチケットを追加したい。

各チケットに対してデジタルチケット（QRコード付き）と紙チケット（物理的な座席番号付き）の2種類を提供したい。
この場合、Abstract Factoryパターンを使うとどのように柔軟性が生まれるかを見てみましょう。

ステップ1: 基本クラスの定義
基本的なチケットクラスと具体的なチケットクラスを定義します。

python
コードをコピーする
class Ticket:
    def __init__(self, event_name, date, price):
        self.event_name = event_name
        self.date = date
        self.price = price

    def get_details(self):
        return f"Event: {self.event_name}, Date: {self.date}, Price: {self.price}"

class ConcertTicket(Ticket):
    def get_details(self):
        return f"Concert - {super().get_details()}"

class MovieTicket(Ticket):
    def get_details(self):
        return f"Movie - {super().get_details()}"

class SportsTicket(Ticket):
    def get_details(self):
        return f"Sports - {super().get_details()}"
ステップ2: 座席情報のクラス定義
座席情報のクラスを定義します。

python
コードをコピーする
class Seat:
    def __init__(self, section, number):
        self.section = section
        self.number = number

    def get_details(self):
        return f"Section: {self.section}, Number: {self.number}"

class ConcertSeat(Seat):
    def get_details(self):
        return f"Concert Seat - {super().get_details()}"

class MovieSeat(Seat):
    def get_details(self):
        return f"Movie Seat - {super().get_details()}"

class SportsSeat(Seat):
    def get_details(self):
        return f"Sports Seat - {super().get_details()}"
ステップ3: デジタルチケットと紙チケットのクラス定義
新しい要件に対応するために、デジタルチケットと紙チケットのクラスを定義します。

python
コードをコピーする
class DigitalTicket(Ticket):
    def __init__(self, event_name, date, price, qr_code):
        super().__init__(event_name, date, price)
        self.qr_code = qr_code

    def get_details(self):
        return f"{super().get_details()}, QR Code: {self.qr_code}"

class PaperTicket(Ticket):
    def __init__(self, event_name, date, price, seat):
        super().__init__(event_name, date, price)
        self.seat = seat

    def get_details(self):
        return f"{super().get_details()}, Seat: {self.seat.get_details()}"
ステップ4: Abstract Factoryインターフェースの作成
次に、TicketFactoryインターフェースとSeatFactoryインターフェースを定義します。

python
コードをコピーする
from abc import ABC, abstractmethod

class TicketFactory(ABC):
    @abstractmethod
    def create_digital_ticket(self, event_name, date, price, qr_code):
        pass

    @abstractmethod
    def create_paper_ticket(self, event_name, date, price, seat):
        pass

class SeatFactory(ABC):
    @abstractmethod
    def create_seat(self, section, number):
        pass
ステップ5: 具体的なファクトリクラスの作成
具体的なファクトリクラスを実装します。

python
コードをコピーする
class ConcertFactory(TicketFactory, SeatFactory):
    def create_digital_ticket(self, event_name, date, price, qr_code):
        return DigitalTicket(event_name, date, price, qr_code)

    def create_paper_ticket(self, event_name, date, price, seat):
        return PaperTicket(event_name, date, price, seat)

    def create_seat(self, section, number):
        return ConcertSeat(section, number)

class MovieFactory(TicketFactory, SeatFactory):
    def create_digital_ticket(self, event_name, date, price, qr_code):
        return DigitalTicket(event_name, date, price, qr_code)

    def create_paper_ticket(self, event_name, date, price, seat):
        return PaperTicket(event_name, date, price, seat)

    def create_seat(self, section, number):
        return MovieSeat(section, number)

class SportsFactory(TicketFactory, SeatFactory):
    def create_digital_ticket(self, event_name, date, price, qr_code):
        return DigitalTicket(event_name, date, price, qr_code)

    def create_paper_ticket(self, event_name, date, price, seat):
        return PaperTicket(event_name, date, price, seat)

    def create_seat(self, section, number):
        return SportsSeat(section, number)
ステップ6: クライアントコードの作成
最後に、ファクトリを使ってチケットと座席を生成するクライアントコードを作成します。

python
コードをコピーする
def client_code(factory: TicketFactory, seat_factory: SeatFactory):
    digital_ticket = factory.create_digital_ticket("Amazing Event", "2024-07-01", 100, "QR123456")
    seat = seat_factory.create_seat("A", 1)
    paper_ticket = factory.create_paper_ticket("Amazing Event", "2024-07-01", 100, seat)

    print(digital_ticket.get_details())
    print(paper_ticket.get_details())

# コンサート用のファクトリを使用
concert_factory = ConcertFactory()
client_code(concert_factory, concert_factory)

# 映画用のファクトリを使用
movie_factory = MovieFactory()
client_code(movie_factory, movie_factory)

# スポーツイベント用のファクトリを使用
sports_factory = SportsFactory()
client_code(sports_factory, sports_factory)
まとめ
このように、Abstract Factoryパターンを使用することで、新しい種類のチケットや座席を追加する場合でも、既存のクライアントコードを変更することなく、システムを柔軟に拡張できます。具体的なクラス（ConcertTicket、MovieTicket、SportsTicketなど）に依存せず、インターフェース（TicketFactory、SeatFactory）を通じてオブジェクトを生成するため、コードの変更が最小限で済みます。

これでAbstract Factoryパターンの柔軟性について理解が深まることを願っています。質問や追加の課題があれば、いつでもお知らせください。
"""