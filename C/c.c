#include <stdio.h>
#include <sys/shm.h>

struct sharememory
{
    int a;
};
// 共有メモリー用構造体
struct sharememory_info
{
    int    id;               /* 共有メモリー識別子 */
    struct sharememory *shm; /* 共有情報           */
};

///////////////////////////////////////////////////////

int main(int argc, char *argv[])
{
    struct sharememory_info shmem_inf;

    /* 共有メモリー識別子取得 */
    if(( shmem_inf.id = shmget(IPC_PRIVATE,
                               sizeof(struct sharememory),
                               IPC_CREAT|0666)) == -1) {
        perror("shmget");
        return 0;
    }

    if((shmem_inf.shm = shmat(shmem_inf.id, 0, 0)) == (void *)-1) {
        perror("shmat");
        return 0;
    }
}
