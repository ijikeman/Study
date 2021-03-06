#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/shm.h>
#define SHM_KEY 12345

struct transfer_data {
  int no1;
  int no2;
  int result;
  int flg;
  char data[10];
};

struct share_info {
  int id;
  struct transfer_data *data;
};

int main(int argc, char *argv[])
{
  struct share_info sh_info;
  struct transfer_data *t_data;

  if ((sh_info.id = shmget((key_t)SHM_KEY, sizeof(struct transfer_data), IPC_CREAT|0777)) == -1) {
    perror("Can't create shm");
    exit(1);
  }
  printf("Create shm_id = %d\n", sh_info.id);

  // shmatするとsharedのアドレスポインタが返ってくるのでdataのポインタと一致させる
  if ((sh_info.data = shmat(sh_info.id, 0 ,0)) == (void *)-1) {
    perror("Can't get shm addr");
    exit(1);
  }
  printf("shared address = 0x%x\n", sh_info.data);
  while (1) {
    if (sh_info.data->no1 != 0 && sh_info.data->no2 != 0) break;
  }
  printf("no1 = %d, no2 = %d, flg = %d, data = %s\n", sh_info.data->no1, sh_info.data->no2, sh_info.data->flg, sh_info.data->data);
  sh_info.data->result = sh_info.data->no1 + sh_info.data->no2;
  sh_info.data->flg = 2;
  return(0);
}
