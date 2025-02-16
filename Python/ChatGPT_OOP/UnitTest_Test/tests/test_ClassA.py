import unittest
import sys
import os

# モジュールのパスを設定
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../modules')))

# クラスのインポート
from modules.ClassA import A_Class1

class TestA_Class1(unittest.TestCase):

    def setUp(self):
        self.a_class1 = A_Class1()

    def test_run(self):
        # 標準出力をキャプチャしてテスト
        import io
        import sys
        captured_output = io.StringIO()
        sys.stdout = captured_output
        self.a_class1.run()
        sys.stdout = sys.__stdout__
        
        self.assertIn("I'm B_Class1", captured_output.getvalue())
        self.assertIn("I'm B_Class2", captured_output.getvalue())

if __name__ == '__main__':
    unittest.main()