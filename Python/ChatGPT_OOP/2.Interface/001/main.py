from modules.Interface import Circle, Rectangle, Person, Car, Bird, Airplane

if __name__ == '__main__':
 circle = Circle(5)
print(f"Circle area: {circle.calculateArea()}")

rectangle = Rectangle(4, 5)
print(f"Rectangle area: {rectangle.calculateArea()}")

person1 = Person("Alice", 30)
person2 = Person("Bob", 20)
comparison = person1.compareTo(person2)
if comparison > 0:
    print(f"{person1.name} is older than {person2.name}")
elif comparison < 0:
    print(f"{person1.name} is younger than {person2.name}")
else:
    print(f"{person1.name} and {person2.name} are of the same age")

car1 = Car("Toyota", 2000)
car2 = Car("Honda", 1500)
comparison = car1.compareTo(car2)
if comparison > 0:
    print(f"{car1.maker} is more expensive than {car2.maker}")
elif comparison < 0:
    print(f"{car1.maker} is less expensive than {car2.maker}")
else:
    print(f"{car1.maker} and {car2.maker} have the same price")

bird = Bird("sparrow")
bird.fly()

airplane = Airplane("Jet", "Model X")
airplane.fly()