"""
課題4: インターフェースを利用したコレクションの管理
次のステップとして、作成したインターフェースを利用してコレクションの管理を行います。
これにより、異なる種類のオブジェクトを一緒に扱う方法や、ポリモーフィズムの利点を理解することができます。

問題4: 異なる形状のコレクションの管理
新たに ShapeCollection クラスを作成し、Shape インターフェースを実装する形状（円や長方形）を管理するコレクションを保持します。
ShapeCollection クラスに以下のメソッドを追加します:
addShape(shape: Shape): コレクションに形状を追加します。
totalArea() -> float: コレクション内の全ての形状の面積の合計を計算します。
"""
from modules.Shapes import Circle, Rectangle
from modules.Collections import ShapeCollection

collection = ShapeCollection()
circle = Circle(5)
rectangle = Rectangle(4, 5)
collection.addShape(circle)
collection.addShape(rectangle)
print(f"Total area: {collection.totalArea()}")
