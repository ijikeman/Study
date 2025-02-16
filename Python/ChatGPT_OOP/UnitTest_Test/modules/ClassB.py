from modules.Interface import BaseClass

class B_Class1(BaseClass):
    def __init__(self):
        self.name = "I'm B_Class1"

    def run(self):
        print(self.name)

class B_Class2(BaseClass):
    def __init__(self):
        self.name = "I'm B_Class2"

    def run(self):
        print(self.name)
