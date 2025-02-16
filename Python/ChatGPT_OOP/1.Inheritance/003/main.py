"""
次の課題では、ABCを使用しない実装に戻し、より複雑な動作を追加していきましょう。

問題
動物たちに新しい属性として「体重（weight）」を追加します。
動物が食べる行動をシミュレートする eat メソッドを追加します。このメソッドは体重を増加させます。
動物が休む行動をシミュレートする rest メソッドを追加します。このメソッドは年齢を増加させます。
"""
from modules import AnimalBase, Dog, Cat

animal_list = []
animal_list.append(Dog("ポチ", 3, 15))
animal_list.append(Cat("タマ", 5, 10))
animal_list.append(Dog("ジョン", 4, 30))
animal_list.append(Cat("ミケ", 7, 5))

for animal in animal_list:
    animal.info()
    animal.speak()
    animal.move()
    animal.eat(2)
    animal.rest()
    animal.info()
