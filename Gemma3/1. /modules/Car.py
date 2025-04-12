class Car:
    def __init__(self, make, model, color, year):
        self.make = make
        self.model = model
        self.color = color
        self.year = year
        self.speed = 0
    
    def accelerate(self, increment):
        self.speed += increment
        if self.speed > 100:
            self.speed = 100
    
    def brake(self, decrement):
        if self.speed < decrement:
            self.speed = 0
        else:
            self.speed -= decrement

    def description(self):
        print(f"This is a {self.year} {self.model}, {self.color} in color, with speed of {self.speed} km/h.")
