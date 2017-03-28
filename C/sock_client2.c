#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main() {
  int client_sock, client_len;
  struct sockaddr_in client_addr;

  if ((client_sock = socket(PF_INET, SOCK_STREAM, 0)) < 0) {
    perror("Can't Create client_sock");
    exit(1);
  }

  client_addr.sin_family = AF_INET;
  client_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
  client_addr.sin_port = htons(1234);

  if (connect(client_sock, (struct sockaddr *)&client_addr, sizeof(client_addr)) <0) {
    perror("Can't Create connect");
    exit(1);
  }
  write(client_sock, "Test", strlen("Test") + 1);
  close(client_sock);
}

