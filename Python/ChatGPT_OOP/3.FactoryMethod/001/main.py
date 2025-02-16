"""
Factory Methodパターンを学ぶために、チケットシステムを題材にした課題を出します。この課題では、異なる種類のチケット（例えば、映画チケット、コンサートチケット、スポーツイベントチケット）を生成するファクトリーメソッドを実装します。

課題の概要
抽象クラスまたはインターフェースを定義:

Ticketという名前の抽象クラスまたはインターフェースを定義し、共通のメソッドを宣言します。例えば、get_event_detailsメソッドなど。
具体的なチケットクラスを実装:

MovieTicket
ConcertTicket
SportsTicket
それぞれのクラスはTicketクラスを継承し、具体的なイベントの詳細を提供するようにします。
ファクトリークラスを定義:

抽象ファクトリークラスTicketFactoryを定義し、create_ticketというファクトリーメソッドを宣言します。
各具体的なチケットクラスのファクトリークラス（MovieTicketFactory、ConcertTicketFactory、SportsTicketFactory）を実装し、TicketFactoryを継承します。
クライアントコードを実装:

クライアントコードで、適切なファクトリークラスを使用してチケットを生成し、その詳細を表示します。

課題の提出方法
上記のコードを実装してください。
追加で、他の種類のチケットを作成してみてください。例えば、TheaterTicketやFestivalTicketなど。
ファクトリークラスを拡張して新しいチケットの生成をサポートしてください。
生成されたチケットの詳細を出力するクライアントコードを実行し、その出力を確認してください。
この課題を通じて、Factory Methodパターンの基本的な概念と実装方法を理解し、異なる種類のオブジェクト生成に対する柔軟性を体験してください。
"""
from modules.TicketFactory import ConcertTicketFactory, MovieTicketFactory, SportsTicketFactory

def main():
    # Movie ticket
    movie_factory = MovieTicketFactory()
    movie_ticket = movie_factory.create_ticket()
    print(movie_ticket.get_event_details())
    print(movie_ticket.get_client_code())

    # Concert ticket
    concert_factory = ConcertTicketFactory()
    concert_ticket = concert_factory.create_ticket()
    print(concert_ticket.get_event_details())
    print(concert_ticket.get_client_code())

    # Sports ticket
    sports_factory = SportsTicketFactory()
    sports_ticket = sports_factory.create_ticket()
    print(sports_ticket.get_event_details())
    print(sports_ticket.get_client_code())

if __name__ == "__main__":
    main()
