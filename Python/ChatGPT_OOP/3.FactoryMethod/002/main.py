"""
次の課題では、より高度なFactory Methodパターンの応用を学びます。
これには、依存関係の注入や設定ファイルを使ったファクトリの柔軟な切り替えを含みます。

課題の概要
依存関係の注入:

チケットの生成には、イベントの詳細や価格などの追加情報が必要になります。
これらの情報を生成するクラスを別途用意し、ファクトリに注入します。
設定ファイルを使用したファクトリの切り替え:

設定ファイル（例えば、JSONファイル）を使って、生成するチケットの種類を動的に変更できるようにします。
"""
from modules.TicketFactory import MovieTicketFactory, SportsTicketFactory, ConcertTicketFactory

import json
import os
if __name__=="__main__":
    file_name = 'config.json'

    # プログラムのカレントディレクトリパスを取得
    current_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_dir, file_name)

    #config.jsonを読み込む
    with open(file_path) as f:
        config = json.load(f)

    ticket_kind = config['kind']
    if ticket_kind == 'movie':
        factory = MovieTicketFactory()
    elif ticket_kind == 'sports':
        factory = SportsTicketFactory()
    elif ticket_kind == 'concert':
        factory = ConcertTicketFactory()
    elif ticket_kind == 'exhibit':
        factory = ExhibitTicketFactory()
    else:
        raise ValueError(f"Invalid ticket kind: {ticket_kind}")
    ticket = factory.create_ticket()
    print(ticket.get_price())
    print(ticket.get_detail())
