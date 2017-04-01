#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/un.h>
#include <sys/socket.h>
#include <sys/types.h>

#define SOCK_NAME "/tmp/socket"

main() {
  int fd1, fd2, i, ret, len;
  struct sockaddr_un saddr;
  struct sockaddr_un caddr;

  char buf[1024];

  if ((fd1 = socket(PF_UNIX, SOCK_STREAM, 0)) < 0 ) {
    perror("socket failed");
    exit(1);
  }

  saddr.sun_family = AF_UNIX;
  strcpy(saddr.sun_path, SOCK_NAME);

  unlink(SOCK_NAME);

  if (bind(fd1, (struct sockaddr *)&saddr, sizeof(saddr.sun_family) + strlen(SOCK_NAME)) < 0) {
    perror("bind failed");
    exit(1);
  }

  if (listen(fd1, 1) < 0) {
    perror("bind failed");
    exit(1);
  }

  for(;;) {
    len = sizeof(caddr);
    if ((fd2 = accept(fd1, (struct sockaddr *)&caddr, &len)) < 0) {
      perror("accept failed");
      exit(1);
    }
    close(fd1);

    while(ret = read(fd2, buf, 1024)) {
      for (i=0; i<ret; i++) {
        buf[i] = toupper(buf[i]);
      }
      write(fd2, buf, 1024);
    }
    close(fd2);
  }
}
