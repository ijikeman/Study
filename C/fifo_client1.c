#include <stdio.h>
#include <string.h>
#include <fcntl.h>

int main(void) {
  int fd;
  int msg_size = 256;
  char msg[msg_size];

  mkfifo("/tmp/fifo1", 0777);
  fd = open("/tmp/fifo1", O_RDONLY);
  read(fd, msg, msg_size);
  printf("Recieved Message '%s'\n", msg);
  close(fd);
  return(0);
}
