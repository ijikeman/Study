from ProcessBase import ProcessBase
import time

class WorkerProcess(ProcessBase):
    def run(self):
        i = 0
        while not self.stop_event.is_set():
            try:
                print(f"Child process is running... {i}")
                i += 1
                time.sleep(1)
            except KeyboardInterrupt:
                break

class MainProcess:
    def __init__(self):
        self.worker = WorkerProcess()

    def run(self):
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
