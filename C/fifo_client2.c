#include <stdio.h>
#include <string.h>
#include <fcntl.h>

int main(void) {
  int fd1, fd2, c, d;
  char buf1[10], buf2[10], result[10];
  mkfifo("/tmp/fifo1", 0777);
  mkfifo("/tmp/fifo2", 0777);
  fd1 = open("/tmp/fifo1", O_RDONLY);
  fd2 = open("/tmp/fifo2", O_WRONLY);

  read(fd1, buf1, sizeof(buf1));
  c = atoi(buf1);
  printf("[Client]: read %d\n", c);
  read(fd1, buf2, sizeof(buf2));
  d = atoi(buf2);
  printf("[Client]: read %d\n", d);
  sprintf(result,"%d",c + d);
  printf("[Client]: sum c + d = %s\n", result);
  write(fd2, result, sizeof(result));
  close(fd1);
  close(fd2);
  return(0);
}
