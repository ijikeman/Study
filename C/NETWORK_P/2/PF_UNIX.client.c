#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <string.h>
#include <sys/un.h>
#include <stdlib.h>

#define SOCK_NAME "/tmp/socket"

main() {
  struct sockaddr_un addr;
  int fd;
  int ret = 1024;
  char buf[1024];

  addr.sun_family = AF_UNIX;
  strcpy(addr.sun_path, SOCK_NAME);

  if ((fd = socket(PF_UNIX, SOCK_STREAM, 0)) < 0) {
    perror("socket failed");
    exit(1);
  }

  if (connect(fd, (struct sockaddr *)&addr, sizeof(addr.sun_family) + strlen(SOCK_NAME)) < 0) {
    perror("connect failed");
    exit(1);
  }

  while(fgets(buf, 1024, stdin)) {
    write(fd, buf, 1024);
    ret = read(fd, buf, ret);
    printf("%s", buf);
  }
  close(fd);
  exit(0);
}
