import unittest
import sys
import os

# モジュールのパスを設定
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../modules')))

# クラスのインポート
from modules.ClassB import B_Class1, B_Class2

class TestB_Class1(unittest.TestCase):

    def setUp(self):
        self.b_class1 = B_Class1()

    def test_run(self):
        # 標準出力をキャプチャしてテスト
        import io
        import sys
        captured_output = io.StringIO()
        sys.stdout = captured_output
        self.b_class1.run()
        sys.stdout = sys.__stdout__
        
        self.assertEqual(captured_output.getvalue().strip(), "I'm B_Class1")

class TestB_Class2(unittest.TestCase):

    def setUp(self):
        self.b_class2 = B_Class2()

    def test_run(self):
        # 標準出力をキャプチャしてテスト
        import io
        import sys
        captured_output = io.StringIO()
        sys.stdout = captured_output
        self.b_class2.run()
        sys.stdout = sys.__stdout__
        
        self.assertEqual(captured_output.getvalue().strip(), "I'm B_Class2")

if __name__ == '__main__':
    unittest.main()
