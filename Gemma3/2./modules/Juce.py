from .Shohin import Shohin

class Juce(Shohin):
    def __init__(self, name, description, price, quantity, image_path):
        super().__init__(name, description, price, quantity, image_path)
        self.category = "Juce"
        self.size = "Medium"
        self.color = "Red"
        self.flavor = "Citrus"
        self.nutrition_info = {
            'calories': 50,
            'sugar': 10,
            'vitamin_c': 30
        }
