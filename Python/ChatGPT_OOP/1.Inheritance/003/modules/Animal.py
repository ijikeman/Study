class AnimalBase:
    def __init__(self, name, age, weight):
        self.age = age
        self.name = name
        self.voice = '動物の鳴き声'
        self.weight = int(weight)
    
    def speak(self):
        print(self.voice)

    def info(self):
        print (f"age: {self.age}歳, name: {self.name}, weight: {self.weight}kg")

    def move(self):
        print(f"移動する")

    def eat(self, food_weight):
        self.weight += int(food_weight)
        print(f"{self.name}は食べ物を{food_weight}kg食べたので、体重が{self.weight}kgになった。")
    
    def rest(self):
        self.age += 1
        print(f"{self.name}は休んだので、年齢が{self.age}歳になった。")

class Dog(AnimalBase):
    def __init__(self, name, age, weight):
        super().__init__(name, age, weight)
        self.voice = 'ワンワン'
    
    def move(self):
        print("走る")

class Cat(AnimalBase):
    def __init__(self, name, age, weight):
        super().__init__(name, age, weight)
        self.voice = 'ニャーニャー'

    def move(self):
        print("歩く")
