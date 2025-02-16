# multiprocessing.Processやmultiprocessing.Eventと記載すると長いのでProcessとEventを省略記載形式に変更
from multiprocessing import Process, Event
import time
import signal
import os
def worker(stop_event, parent_pid):
    i = 0
    # stop_eventを受け取るまでループする
    while not stop_event.is_set():
        try:
            # 親プロセスが生きていない場合はbreakして終了する
            if not is_parent_running(parent_pid):
                print(f"Parent process({parent_pid}) has exited. Exiting child process.")
                stop_event.set()
            print(f"Child process is running... {i}")
            i += 1
            time.sleep(1)
        # worker側でもCtrl + Cを受け取る
        except KeyboardInterrupt:
            print("Child process interrupted. Setting stop event.")
            # stop_event.set()で自らイベントを発生させてbreakする(単純にbreakでも同じ)
            stop_event.set()
    print("Worker process is shutting down...")

# 次の関数を実装する
# 親プロセスが生きているか確認する
# 親プロセスが生きている場合はTrueを返す
def is_parent_running(parent_pid):
    try:
        os.kill(parent_pid, 0)
    except OSError:
        return False
    return True

def main():
    # 親プロセスのPIDを取得
    parent_pid = os.getpid()
    stop_event = Event()
    process = Process(target=worker, args=(stop_event, parent_pid))
    process.start()

    # sigtermハンドルを実装
    def cleanup(signum, frame):
        print(f"Main process received signal {signum}, setting stop event.")
        stop_event.set()
        process.join()
        print("Main process is shutting down...")
        # exit(0)しないと親プロセスは残ったままになる
        exit(0)

    # シグナルハンドラを設定
    signal.signal(signal.SIGINT, cleanup)  # Ctrl+C (SIGINT) シグナルをキャッチした場合にcleanupを実行
    signal.signal(signal.SIGTERM, cleanup)  

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
