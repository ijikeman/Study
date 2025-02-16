"""
Factory Method:
具体的なオブジェクト生成をサブクラスに任せるためのメソッドを提供します。
単一の製品（チケット）を生成するために使用されます。

Abstract Factory:
関連する複数の製品を生成するためのインターフェースを提供します。
製品のファミリー（関連する複数のチケットや関連するオブジェクト）を一貫性を持って生成するために使用されます。

Abstract Factoryのメリット
Abstract Factoryを使用することで、以下のメリットがあります。

一貫性のあるオブジェクト生成:
関連するオブジェクト群を一貫して生成できるため、システム全体で整合性が保たれます。
依存性の分離:

クライアントコードは具体的なクラスに依存せず、インターフェースに依存するため、コードの柔軟性と拡張性が向上します。

実装の見直し
もう一度、チケットシステムを題材にして、Abstract Factoryの実装を見てみましょう。
今回は、チケットの種類（例えば、コンサートチケットと映画チケット）に加えて、
座席情報も含めたチケットを生成するシナリオを考えます。

ステップ2: 座席情報のクラス定義
次に、座席情報のクラスを定義します。

python
コードをコピーする
# 基本的なSeatクラス
class Seat:
    def __init__(self, section, number):
        self.section = section
        self.number = number

    def get_details(self):
        return f"Section: {self.section}, Number: {self.number}"

# 具体的なConcertSeatクラス
class ConcertSeat(Seat):
    def get_details(self):
        return f"Concert Seat - {super().get_details()}"

# 具体的なMovieSeatクラス
class MovieSeat(Seat):
    def get_details(self):
        return f"Movie Seat - {super().get_details()}"
ステップ3: Abstract Factoryインターフェースの作成
次に、TicketFactoryインターフェースとSeatFactoryインターフェースを定義します。

python
コードをコピーする
from abc import ABC, abstractmethod

class TicketFactory(ABC):
    @abstractmethod
    def create_ticket(self, event_name, date, price):
        pass

class SeatFactory(ABC):
    @abstractmethod
    def create_seat(self, section, number):
        pass
ステップ4: 具体的なファクトリクラスの作成
具体的なファクトリクラスを実装します。

python
コードをコピーする
class ConcertFactory(TicketFactory, SeatFactory):
    def create_ticket(self, event_name, date, price):
        return ConcertTicket(event_name, date, price)

    def create_seat(self, section, number):
        return ConcertSeat(section, number)

class MovieFactory(TicketFactory, SeatFactory):
    def create_ticket(self, event_name, date, price):
        return MovieTicket(event_name, date, price)

    def create_seat(self, section, number):
        return MovieSeat(section, number)
ステップ5: クライアントコードの作成
最後に、ファクトリを使ってチケットと座席を生成するクライアントコードを作成します。

python
コードをコピーする
def client_code(factory: TicketFactory, seat_factory: SeatFactory):
    ticket = factory.create_ticket("Amazing Event", "2024-07-01", 100)
    seat = seat_factory.create_seat("A", 1)
    print(ticket.get_details())
    print(seat.get_details())

# コンサート用のファクトリを使用
concert_factory = ConcertFactory()
client_code(concert_factory, concert_factory)

# 映画用のファクトリを使用
movie_factory = MovieFactory()
client_code(movie_factory, movie_factory)
まとめ
このように、Abstract Factoryパターンを使うことで、関連する複数のオブジェクト（チケットと座席）を一貫して生成することができます。これにより、クライアントコードが具体的なクラスに依存せず、柔軟に拡張可能なシステムを構築できます。
"""
from modules.Factory import TicketFactory, SeatFactory
from modules.Factories import MovieFactory, ConcertFactory

def client_code(ticket_factory: TicketFactory, seat_factory: SeatFactory):
    ticket = factory.create_ticket("SuperMario", "2023.12.23", 99.99)
    seat = factory.create_seat("A", 5)
    print(ticket.get_detail())
    print(seat.get_detail())

ticket_type = 'concert'

if ticket_type == 'movie':
    factory = MovieFactory()
elif ticket_type == 'concert':
    factory = ConcertFactory()
else:
    raise(f"Not Found ticket_type: {ticke_type}")

client_code(factory, factory)
