#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>

#define MAX_CONNECTS 5
#define SERVER_SOCK_FILE "/tmp/server.socket"

int main() {
  int server_sock, client_sock, server_len, client_len;
  struct sockaddr_un server_addr;
  struct sockaddr_un client_addr;
  char buf[10];

  server_sock = socket(AF_UNIX, SOCK_STREAM, 0);

  server_addr.sun_family = AF_UNIX;
  strcpy(server_addr.sun_path, SERVER_SOCK_FILE);
  server_len = sizeof(server_addr);

  unlink(SERVER_SOCK_FILE);
  bind(server_sock, (struct sockaddr *)&server_addr, server_len);

  listen(server_sock , MAX_CONNECTS);

  while(1) {
    client_len = sizeof(client_addr);
    if ((client_sock = accept(server_sock, (struct sockaddr *)&client_addr, &client_len)) < 0) {
      perror("Error client_sock");
      exit(1);
    }
    close(server_sock);
    break;
  }
  read(client_sock, buf, sizeof(buf));
  printf("Read %s\n", buf);
  close(client_sock);
}
