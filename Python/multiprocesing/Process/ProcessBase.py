# multiprocessing.Processやmultiprocessing.Eventと記載すると長いのでProcessとEventを省略記載形式に変更
from multiprocessing import Process, Event

# ProcessBaseクラスを実装
class ProcessBase:
    def __init__(self):
        self.stop_event = Event()
        # run_wrapperを呼び出して処理を共通化する
        self.process = Process(target=self.run_wrapper)
    
    def start(self):
        self.process.start()
    
    def run_wrapper(self):
        try:
            # run()を呼び出す。run()の処理は継承クラスでそれぞれ実装する
            self.run()
        except KeyboardInterrupt:
            print(f"{self.__class__.__name__} received KeyboardInterrupt")
        finally:
            # cleanup_wrapper()を呼び出す
            self.cleanup_wrapper()

    def run(self):
        raise NotImplementedError("Subclasses must implement this method")
    
    def cleanup_wrapper(self):
        self.cleanup()
        print(f"{self.__class__.__name__} is shutting down...")

    # cleanupは継承クラス側で実装を記載
    def cleanup(self):
        pass

    def stop(self):
        self.stop_event.set()
        self.process.join()