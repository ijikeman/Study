import multiprocessing
import time

def worker():
    i = 0
    while True:
        print(f"Child process is running... {i}")
        i += 1
        time.sleep(1)

def main():
    process = multiprocessing.Process(target=worker)
    process.start()

    # メインプロセスが終了しないように無限ループで待機
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Main process interrupted. Terminating child process.")
        process.terminate()
        process.join()
    finally:
        print(f"Main process is shutting down...")

if __name__ == "__main__":
    main()