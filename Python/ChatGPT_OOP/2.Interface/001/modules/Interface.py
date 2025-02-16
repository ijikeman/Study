"""
私はプログラム初心者です。oopでabcだけ学びました
次のステップに進みたいので課題をだしてください

プログラム初心者として、次に進むための課題として以下のようなものを考えることができます。これらはOOP（Object-Oriented Programming）を活用してスキルを深めるための手助けになるでしょう。

1. **簡単なクラス設計と実装**:
- 例えば、動物や自動車などのオブジェクトに関するクラスを設計してみてください。それぞれのクラスには、属性（例：名前、年齢、速度）とメソッド（例：移動、音を出す）を含めてください。

2. **継承とポリモーフィズムの理解**:
- 既存のクラスを継承して、新しいクラスを作成し、そのクラスのメソッドをオーバーライドしてみてください。例えば、動物のサブクラスとして、犬や猫などの特定の動物のクラスを作成することができます。

3. **インターフェースや抽象クラスの利用**:
- いくつかのクラスに共通する振る舞いをインターフェースや抽象クラスとして抽出し、それを実装する具体的なクラスを作成してみてください。

4. **コーディングのベストプラクティス**:
- エラーハンドリングや例外処理の実装、コードのリファクタリング（改善）、ドキュメンテーションの追加など、実際のプロジェクトでよく見られるベストプラクティスについて学びましょう。

5. **データ構造とアルゴリズムの理解**:
- OOPを使って、異なるデータ構造（リスト、マップ、キューなど）や、それらを操作するアルゴリズム（探索、ソートなど）を実装してみてください。

これらの課題を通じて、OOPの基礎を強化し、実際のプログラミング経験を積むことができます。また、自分の興味やプロジェクトの要件に合わせて課題を調整することもできますので、自分のペースで進んでくださいね。

インターフェースを学びたい　step by step で進めたいのでプログラム作成問題を出してください

インターフェースを学ぶためのプログラム作成問題をいくつか挙げてみます。これらの問題を通じて、インターフェースの使い方やその重要性を体験することができるでしょう。

### 問題1: 形状と面積の計算

以下の形状を表すインターフェース `Shape` を定義し、それを実装するクラスを作成してください。各クラスは、その形状の面積を計算するメソッドを実装します。

- `Circle`: 円を表すクラス。半径を持ちます。
- `Rectangle`: 長方形を表すクラス。幅と高さを持ちます。

各クラスは `Shape` インターフェースを実装し、面積を計算するためのメソッド `calculateArea()` を実装してください。

### 問題2: オブジェクトの比較

以下のインターフェース `Comparable` を定義し、それを実装するクラスを作成してください。これにより、オブジェクト同士を比較できるようにします。

```java
interface Comparable {
    int compareTo(Comparable other);
    }
    ```

    作成するクラス例:

    - `Person`: 人物を表すクラス。名前と年齢を持ちます。年齢に基づいて比較します。
    - `Car`: 車を表すクラス。メーカー名と価格を持ちます。価格に基づいて比較します。

    各クラスは `Comparable` インターフェースを実装し、`compareTo()` メソッドをオーバーライドしてください。

    ### 問題3: 飛べる動物の管理

    以下のインターフェース `Flyable` を定義し、それを実装するクラスを作成してください。これにより、飛ぶことができる動物の管理ができるようにします。

    ```java
    interface Flyable {
        void fly();
        }
        ```

        作成するクラス例:

        - `Bird`: 鳥を表すクラス。種類（例: スズメ、カラス）を持ち、`fly()` メソッドで飛ぶ振る舞いを実装します。
        - `Airplane`: 飛行機を表すクラス。メーカー名や型式を持ち、`fly()` メソッドで飛行する振る舞いを実装します。

        各クラスは `Flyable` インターフェースを実装し、`fly()` メソッドをオーバーライドしてください。

        これらの問題を通じて、インターフェースの使い方や実装方法を学びながら、オブジェクト指向プログラミングの基本を深めることができます。
"""
from abc import ABC, abstractmethod
class Shape(ABC):
    def __init__(self, x, y=None, z=None):
        self.x = x
        self.y = y
        self.z = z

    @abstractmethod
    def calculateArea(self):
        pass

class Compareable(ABC):
    @abstractmethod
    def compareTo(self, other):
        pass

class Flyable(ABC):
    @abstractmethod
    def fly(self):
        pass

class Circle(Shape):
    def __init__(self, x):
        super().__init__(x)
        self.radius = 3.14

    def calculateArea(self):
        return self.x * self.radius

class Rectangle(Shape):
    def calculateArea(self):
        return self.x * self.y

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

class Bird(Flyable):
    def __init__(self, kind):
        self.kind = kind
    
    def fly(self):
        if self.kind == 'crow':
            print("カーカー")
        elif self.kind == 'sparrow':
            print("チュンチュン")
        else:
            print("バサバサ")

class Airplane(Flyable):
    def __init__(self, maker, model):
        self.maker = maker
    
    def fly(self):
        if self.maker == 'Jet':
            print("ビュン")
        elif self.maker == 'Jumbo Jet':
            print("ブォーン")
        else:
            print("シューン")
