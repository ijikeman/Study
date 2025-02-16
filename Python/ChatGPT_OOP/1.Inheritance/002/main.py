"""
練習問題 2: 継承とポリモーフィズム
問題
動物園の動物たちに対して、特定の行動を管理するプログラムを作成しましょう。以下の仕様に従ってください。

AnimalBase クラスには以下のメソッドを追加します。

move メソッド（仮の実装として、「移動する」と表示する）
Dog クラスと Cat クラスに move メソッドをオーバーライドします。

Dog クラスの move メソッドでは、「走る」と表示する
Cat クラスの move メソッドでは、「歩く」と表示する
動物のリストを作成し、すべての動物に対して speak メソッドと move メソッドを呼び出すプログラムを作成します。
"""
from modules import AnimalBase, Dog, Cat

animal_list = []

animal_list.append(Dog("ポチ", 3))
animal_list.append(Cat("タマ", 5))
animal_list.append(Dog("ジョン", 4))
animal_list.append(Cat("ミケ", 7))

for animal in animal_list:
    animal.speak()
    animal.move()
