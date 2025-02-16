from modules.ClassB import B_Class1, B_Class2

class A_Class1:
    def __init__(self):
        self.b_class1 = B_Class1()
        self.b_class2 = B_Class2()

    def run(self):
        self.b_class1.run()
        self.b_class2.run()
