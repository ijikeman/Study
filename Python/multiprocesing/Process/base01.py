import multiprocessing
import time

def worker():
    i = 0
    while True:
        print(f"Child process is running... {i}")
        i += 1
        time.sleep(1)
    print(f"Worker process is shutting down...")

def main():
    process = multiprocessing.Process(target=worker)
    process.start()
    print(f"Main process is shutting down...")

if __name__ == "__main__":
    main()
