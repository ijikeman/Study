"""
次のステップとして、より高度なオブジェクト指向プログラミングの概念や、インターフェースの応用を含む課題に取り組んでみましょう。

課題5: 多態性とコンポジションの理解
次に進むための課題として、多態性（ポリモーフィズム）とコンポジションの概念を使ったプログラムを作成します。

問題5: 図形の描画と移動
Drawableインターフェースを定義し、draw()メソッドを宣言します。
Movableインターフェースを定義し、move(x: float, y: float)メソッドを宣言します。
CircleとRectangleクラスをDrawableおよびMovableインターフェースを実装するように拡張します。
新しいDrawingクラスを作成し、複数の図形を管理します。このクラスは以下のメソッドを持ちます：
addShape(shape: Drawable): 図形を追加します。
drawAll(): すべての図形を描画します。
moveAll(x: float, y: float): すべての図形を移動します。
"""
from modules.Shapes import Circle, Rectangle
from modules.DrawManager import Drawing

c1 = Circle(3)
r1 = Rectangle(2,3)
c1.draw()
r1.draw()
drawing_manager = Drawing()
drawing_manager.addShape(c1)
drawing_manager.addShape(r1)

drawing_manager.drawAll()
drawing_manager.moveAll(2, 4)