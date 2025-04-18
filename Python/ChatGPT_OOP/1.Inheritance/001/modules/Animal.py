class AnimalBase:
    def __init__(self, name, age,):
        self.age = age
        self.name = name
        self.voice = '動物の鳴き声'
    
    def speak(self):
        print(self.voice)

    def info(self):
        print (f"age: {self.age}")
        print (f"name: {self.name}")

class Dog(AnimalBase):
    def __init__(self, name, age,):
        super().__init__(name, age,)
        self.voice = 'ワンワン'

class Cat(AnimalBase):
    def __init__(self, name, age,):
        super().__init__(name, age,)
        self.voice = 'ニャーニャー'
