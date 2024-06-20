from multiprocessing import Process, Event
import time

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

class WorkerProcess(ProcessBase):
    def run(self):
        i = 0
        while not self.stop_event.is_set():
            try:
                print(f"Child process is running... {i}")
                i += 1
                time.sleep(1)
            except KeyboardInterrupt:
                self.stop_event.set()

    def cleanup(self):
        print(f"finish worker cleanup")

class MainProcess:
    def __init__(self):
         # worker Processを生成
        self.worker = WorkerProcess()

    def run(self):
        # process.start()を呼び出す
        self.worker.start()
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            print("Main process interrupted. Setting stop event.")
            self.worker.stop()
            print("Main process is shutting down...")

if __name__ == "__main__":
    main_process = MainProcess()
    main_process.run()
