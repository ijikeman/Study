#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/shm.h>
#define SHM_KEY 12345

// 共有メモリにデータを格納する構造体
struct transfer_data {
  int no;
  int flg;
  char data[256];
};

// 共有メモリの情報を格納する構造体
struct share_info {
  int id; //shm_id
  struct transfer_data *data; // shm_address
};

int main(int argc, char *argv[]) {
  struct share_info sh_info;

  // 共通の鍵情報で共有メモリ内に領域を作成
  if ((sh_info.id = shmget((key_t)SHM_KEY, sizeof(struct transfer_data), IPC_CREAT|0777)) == -1) {
    perror("Can't create shm");
    exit(1);
  }
  printf("Create shm_id = %d\n", sh_info.id);

  // shmatするとsharedのアドレスポインタが返ってくるのでtransfer_dataの構造体のポインタと一致させる
  if ((sh_info.data = shmat(sh_info.id, 0 ,0)) == (void *)-1) {
    perror("Can't get shm addr");
    exit(1);
  }
  printf("shared address = 0x%x\n", sh_info.data);

  // transfer_data内にデータを格納
  strcpy(sh_info.data->data, "hoge");
  sh_info.data->no = 0;
  sh_info.data->flg = 1;

  // flgが2になる(client側でデータを取り出す)まで待機
  while(1) {
    if ( sh_info.data->flg == 2 ) break;
  }
  // 共有メモリを破棄
  if (shmdt(sh_info.data) == -1) {
    perror("shmdt");
    exit(1);
  }
  return(0);
}
