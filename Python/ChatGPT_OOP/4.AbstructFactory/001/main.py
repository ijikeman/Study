"""
ステップ1: 基本的なクラスの定義
Ticketという基本クラスを定義し、それを継承する具体的なクラスをいくつか作成します。
例えば、ConcertTicketとMovieTicketクラスを作成します。

ステップ2: Abstract Factoryインターフェースの作成
TicketFactoryというインターフェースを作成し、create_ticketメソッドを定義します。

ステップ3: 具体的なファクトリクラスの作成
ConcertTicketFactoryとMovieTicketFactoryクラスを作成し、それぞれcreate_ticketメソッドを実装します。

ステップ4: クライアントコードの作成
クライアントコードで、ファクトリを使用してチケットを生成し、その詳細を表示します。
"""
from modules.Factory import TicketFactory
from modules.Factories import MovieTicketFactory, ConcertTicketFactory

def client_code(factory: TicketFactory):
    ticket = factory.create_ticket("SuperMario", "2023.12.23", 99.99)
    print(ticket.get_detail())

ticket_type = 'concert'

if ticket_type == 'movie':
    factory = MovieTicketFactory()
elif ticket_type == 'concert':
    factory = ConcertTicketFactory()
else:
    raise(f"Not Found ticket_type: {ticke_type}")

client_code(factory)


