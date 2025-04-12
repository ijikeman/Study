# Shohinクラスを継承してSnackを作る

from .Shohin import Shohin

class Snack(Shohin):
    def __init__(self, name, price, weight, calories):
        super().__init__(name, price, weight)
        self.calories = calories
        self.category = "Snack"
        self.nutrition = {  
            "calories": calories,
            "protein": 0,
            "fat": 0,
            "carbohydrate": 0
        }
        self.nutrition["calories"] = calories
