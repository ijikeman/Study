from abc import ABC, abstractmethod
class AnimalBase(ABC):
    def __init__(self, name, age, weight):
        self.name = name
        self.age = age
        self.weight = weight

    def info(self):
        print(f"name: {self.name}, age: {self.age}歳, weight: {self.weight}kg")

    @abstractmethod
    def speak(self):
        pass

    @abstractmethod
    def move(self):
        pass

    @abstractmethod
    def eat(self):
        pass

    @abstractmethod
    def rest(self):
        pass

class Dog(AnimalBase):
    def speak(self):
        print("ワンワン")
    
    def move(self):
        print("走る")
    
    def eat(self, food_weight):
        self.weight += int(food_weight)
        print(f"{self.name}は食べ物を{self.food_weight}kg食べて、体重が{self.weight}kgになった。")
    
    def rest(self):
        self.age += 1
        print(f"{self.name}は休んで年齢が{self.age}歳になった。")

class Cat(AnimalBase):
    def speak(self):
        print("ニャーニャー")
    
    def move(self):
        print("歩く")
    
    def eat(self, food_weight):
        self.weight += int(food_weight)
        print(f"{self.name}は食べ物を{self.weight}kg食べて、体重が{self.weight}kgになった。")
    
    def rest(self):
        self.age += 1
        print(f"{self.name}は休んで年齢が{self.age}歳になった。")
