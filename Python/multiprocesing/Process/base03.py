import multiprocessing
import time

def worker(stop_event):
    i = 0
    # stop_eventを受け取るまでループする
    while not stop_event.is_set():
        print(f"Child process is running... {i}")
        i += 1
        time.sleep(1)
    print("Worker process is shutting down...")

def main():
    stop_event = multiprocessing.Event()
    process = multiprocessing.Process(target=worker, args=(stop_event,))
    process.start()

    # メインプロセスが終了しないように無限ループで待機
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Main process interrupted. Setting stop event.")
        # ストップイベントをworkerに送る
        stop_event.set()
        process.join()  # 子プロセスが終了するのを待つ
    finally:
        print("Main process is shutting down...")

if __name__ == "__main__":
    main()
