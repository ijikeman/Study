from .Interface import Flyable

class Bird(Flyable):
    def __init__(self, kind):
        self.kind = kind
    
    def fly(self):
        if self.kind == 'crow':
            print("カーカー")
        elif self.kind == 'sparrow':
            print("チュンチュン")
        else:
            print("バサバサ")

class Airplane(Flyable):
    def __init__(self, maker, model):
        self.maker = maker
    
    def fly(self):
        if self.maker == 'Jet':
            print("ビュン")
        elif self.maker == 'Jumbo Jet':
            print("ブォーン")
        else:
            print("シューン")
