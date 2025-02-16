import logging
import multiprocessing
import os

class MyLogger:
    def __init__(self, filename='app.log', debug_mode=False):
        self.filename = filename
        self.logger = self.setup_logger(debug_mode)

    def setup_logger(self, debug):
        # multiprocessing.get_logger()はatomicになっている
        logger = multiprocessing.get_logger()
        if debug:
            level = logging.DEBUG
        else:
            level = logging.INFO
        logger.setLevel(level)
        
        handler = logging.FileHandler(self.filename)
        # Formatterで[now(JST)] [log_level] dataのフォーマットを設定
        def customTime(*args):
            return datetime.now(timezone('Asia/Tokyo')).timetuple()

        # JST対応
        formatter = logging.Formatter(
            fmt='[%(asctime)s] [%(levelname)s] %(message)s',
            datefmt="%Y-%m-%d %H:%M:%S"
        )
        formatter.converter = customTime
        # formatter = logging.Formatter('[%(asctime)s] [%(levelname)s] %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
        handler.setFormatter(formatter)
        logger.addHandler(handler)
        return logger
    
    def log(self, message):
        self.logger.info(message)

    def log_debug(self, message):
        self.logger.debug(message)

# メイン処理を関数化する
def main():
    logger = MyLogger(debug_mode=True) # デバッグモードでの実行
    logger.log('Application started.')

def worker_func():
    logger.log('This is an informational message.')
    logger.log_debug('This is a debug message.')

    processes = []
    for _ in range(5):
        p = multiprocessing.Process(target=worker_func)
        processes.append(p)
        p.start()

    for p in processes:
        p.join()

        logger.log('Application finished.')

if __name__ == '__main__':
    main()
