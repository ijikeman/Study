from .Interface import Compareable

class Person(Compareable):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def compareTo(self, other):
        if self.age > other.age:
            return 1
        elif self.age == other.age:
            return None
        return 0

class Car(Compareable):
    def __init__(self, maker, price):
        self.maker = maker
        self.price = price
    
    def compareTo(self, other):
        if self.price > other.price:
            return 1
        elif other.price == self.price:
            return None
        return 0
