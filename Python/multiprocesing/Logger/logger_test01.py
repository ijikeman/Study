import logging
import multiprocessing
import os

class MyLogger:
    def __init__(self, filename='app.log'):
        self.filename = filename
        self.logger = self.setup_logger()

    def setup_logger(self):
        logger = multiprocessing.get_logger()
        logger.setLevel(logging.INFO)
        handler = logging.FileHandler(self.filename)
        formatter = logging.Formatter('%(asctime)s - %(process)s - %(levelname)s - %(message)s')
        handler.setFormatter(formatter)
        logger.addHandler(handler)
        return logger

    def log(self, message):
        self.logger.info(message)

def worker_func(logger):
    logger.log(f'This log message is from process {os.getpid()}.')

def main():
    logger = MyLogger()
# 例として複数の子プロセスを生成
    processes=[]
    for _ in range(5):
        p = multiprocessing.Process(target=worker_func, args=(logger))
        processes.append(p)
        p.start()

    for p in processes:
        p.join()

if __name__ == '__main__':
    main()