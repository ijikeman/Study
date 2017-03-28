#include <stdio.h>
#include <string.h>
#include <fcntl.h>

int main(void) {
  int fd;
  int msg_size = 256;
  char msg[msg_size];

  fd = open("/tmp/fifo1", O_WRONLY);
  strcpy(msg, "abc");
  printf("Sent Message '%s'\n", msg);
  write(fd, msg, msg_size + 1);
  close(fd);
  return(0);
}
