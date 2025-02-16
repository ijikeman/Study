"""
modules/Interface.pyにはShape, Compareable, Flyableクラスだけを設置して、
Circle, Rectangle ShapeCollectionは別のclassモジュールファイルにした方がよいですか？

ChatGPT
モジュールの構造を整理して、クラスを別々のファイルに分けるのは良い考えです。これにより、コードの可読性が向上し、管理がしやすくなります。以下に、提案するモジュール構成を示します。

モジュール構成の提案
modules/Interface.py:

Shape, Compareable, Flyable のインターフェースを定義します。
modules/Shapes.py:

Circle, Rectangle クラスを定義します。
modules/Collections.py:

ShapeCollection クラスを定義します。
"""
from abc import ABC, abstractmethod

class Shape(ABC):
    def __init__(self, x, y=None, z=None):
        self.x = x
        self.y = y
        self.z = z

    @abstractmethod
    def calculateArea(self):
        pass

class Compareable(ABC):
    @abstractmethod
    def compareTo(self, other):
        pass

class Flyable(ABC):
    @abstractmethod
    def fly(self):
        pass
