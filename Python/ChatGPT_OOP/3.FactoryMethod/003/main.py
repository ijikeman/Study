"""
課題1: 新しいチケット種類の追加
現在のコードに新しいチケット種類を追加してみてください（例: ExhibitTicket）。以下の手順を実行してください：

Ticket インターフェースを実装する新しい ExhibitTicket クラスを作成します。このクラスには、get_detail() と get_price() メソッドが必要です。
ExhibitTicket を生成するための ExhibitTicketFactory クラスを作成します。これは TicketFactory を継承し、create_ticket() メソッドをオーバーライドして ExhibitTicket を返します。
main.py にて、config.json に "kind": "exhibit" という新しいチケット種類を追加し、それを処理するためのコードを追加します。

課題2: 複数のプロバイダーの活用
現在の実装では、DetailProviderとPriceProviderを使用していますが、
それぞれのプロバイダーが異なる種類の詳細情報や価格を提供することを考えてください。
以下の手順で取り組んでください：
DetailProvider と PriceProvider を拡張し、それぞれ別の種類のイベント
（映画、コンサート、スポーツ、展示など）に対応するメソッドを追加します。
新しい ConcertDetailProvider, ConcertPriceProvider, SportsDetailProvider, SportsPriceProvider などを作成します。
各チケット種類のファクトリークラスで、適切なプロバイダーを使用するように修正します。
例えば、ConcertTicketFactory は ConcertDetailProvider と ConcertPriceProvider を使用します。

課題3: ファクトリーメソッドのパターン化
main.py で、ファクトリークラスを生成するためのファクトリーメソッド（クリエーターメソッド）を追加します。例えば、create_ticket_factory(ticket_kind: str) というメソッドを追加し、それに基づいて適切なファクトリークラスをインスタンス化します。
これらの課題を通じて、Factory Method パターンの柔軟性と拡張性を理解し、実装スキルを向上させることができるでしょう。
"""
from modules.TicketFactory import MovieTicketFactory, SportsTicketFactory, ConcertTicketFactory, ExhibitTicketFactory

import json
import os

def create_ticket_factory(ticket_kind):
    if ticket_kind == 'movie':
        return MovieTicketFactory()
    elif ticket_kind == 'sports':
        return SportsTicketFactory()
    elif ticket_kind == 'concert':
        return ConcertTicketFactory()
    elif ticket_kind == 'exhibit':
        return ExhibitTicketFactory()
    else:
        raise ValueError(f"Invalid ticket kind: {ticket_kind}")

if __name__=="__main__":
    file_name = 'config.json'

    # プログラムのカレントディレクトリパスを取得
    current_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_dir, file_name)

    #config.jsonを読み込む
    with open(file_path) as f:
        config = json.load(f)

    ticket_kind = config['kind']
    factory = create_ticket_factory(ticket_kind)
    ticket = factory.create_ticket()
    print(ticket.get_price())
    print(ticket.get_detail())
