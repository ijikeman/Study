#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define MAX_CONNECTS 5

int main() {
  int server_sock, client_sock, server_len, client_len;
  struct sockaddr_in server_addr;
  struct sockaddr_in client_addr;
  char buf[10];

  server_sock = socket(AF_INET, SOCK_STREAM, 0);

  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
  server_addr.sin_port = htons(1234);

  server_len = sizeof(server_addr);
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
