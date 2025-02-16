from .Interface import Shape, Drawable, Movable

class Circle(Shape, Drawable, Movable):
    def __init__(self, x, y=0):
        super().__init__(x, y)
        self.radius = 3.14

    def calculateArea(self):
        return self.radius * self.x ** 2

    def draw(self):
        print(f"Drawing a circle with radius {self.x}")

    def move(self, x: float, y: float):
        self.x += x
        self.y += y
        print(f"Moved circle to ({self.x}, {self.y})")

class Rectangle(Shape, Drawable, Movable):
    def calculateArea(self):
        return self.x * self.y

    def draw(self):
        print(f"Drawing a rectangle with width: {self.x}, hight: {self.y}")

    def move(self, x: float, y: float):
        self.x += x
        self.y += y
        print(f"Moved rectangle to ({self.x, self.y})")
