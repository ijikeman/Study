from .Interface import Shape

class Drawing:
    def __init__(self):
        self.shapes = []

    def addShape(self, shape):
        self.shapes.append(shape)
    
    def drawAll(self):
        for shape in self.shapes:
            shape.draw()
    
    def moveAll(self, x, y):
        for shape in self.shapes:
            shape.move(x, y)
