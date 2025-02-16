from .Interface import Shape

class Circle(Shape):
    def __init__(self, x):
        super().__init__(x)
        self.radius = 3.14

    def calculateArea(self):
        return self.radius * self.x ** 2

class Rectangle(Shape):
    def calculateArea(self):
        return self.x * self.y
