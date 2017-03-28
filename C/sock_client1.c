#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>

#define SERVER_SOCK_FILE "/tmp/server.socket"

int main() {
  int client_sock, client_len;
  struct sockaddr_un client_addr;

  if ((client_sock = socket(PF_UNIX, SOCK_STREAM, 0)) < 0) {
    perror("Can't Create client_sock");
    exit(1);
  }

  client_addr.sun_family = AF_UNIX;
  strcpy(client_addr.sun_path, SERVER_SOCK_FILE);

  if (connect(client_sock, (struct sockaddr *)&client_addr, sizeof(client_addr.sun_family) + strlen(SERVER_SOCK_FILE)) <0) {
    perror("Can't Create connect");
    exit(1);
  }
  write(client_sock, "Test", strlen("Test"));
  close(client_sock);
}

