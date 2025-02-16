from .Interface import Shape
from .Shapes import Circle, Rectangle

class ShapeCollection:
    def __init__(self):
        self.shapes = []

    def addShape(self, shape: Shape): # Shapeオブジェクトであることを示しているが強制力はない
        # 型チェックを追加
        if not isinstance(shape, Shape):
            raise TypeError(f"Excepted object of type Shape, but got {type(shape).__name__}")
        self.shapes.append(shape)
    
    def totalArea(self) -> float: # floatをreturnすることを示している
        total = 0
        for shape in self.shapes:
            total += shape.calculateArea()
        return total


