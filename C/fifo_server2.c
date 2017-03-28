#include <stdio.h>
#include <string.h>
#include <fcntl.h>

int main(void) {
  int fd1, fd2;
  char buf1[10] = "5";
  char buf2[10] = "3";
  char result[10];
  fd1 = open("/tmp/fifo1", O_WRONLY);
  fd2 = open("/tmp/fifo2", O_RDONLY);

  printf("[Server]: write %s\n", buf1);
  write(fd1, buf1, sizeof(buf1));
  printf("[Server]: write %s\n", buf2);
  write(fd1, buf2, sizeof(buf2));
  close(fd1);
  read(fd2, result, sizeof(result));
  printf("[Server]: result = %s\n", result);
  close(fd2);
  return(0);
}
