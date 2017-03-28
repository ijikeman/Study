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
unsigned char versionpacket[] = {
        0x03, 0x04, /* ID */
        0x81, 0x80, /* FLAG 00000001, 00000000 */
        0x00, 0x01, /* QDCOUNT 1 One Question */
        0x00, 0x00, /* ANCOUNT 1 by Client */
        0x00, 0x00, /* NSCOUNT 0 by Client */
        0x00, 0x01, /* ARCOUNT 0 by Client */

        /* QUESTION SECTION */
        0x05, 'y', 'a', 'h', 'o', 'o', 0x02, 'c', 'o', 0x02, 'j', 'p', 0x00, /* QNAME */
        0x00, 255, /* QTYPE = 259(TKEY RR) */
        0x00, 1, /* QCLASS = 255(ANY) */

        /* Answer record  */
        0x05, 'y', 'a', 'h', 'o', 'o', 0x02, 'c', 'o', 0x02, 'j', 'p', 0x00, /* QNAME */
        0x00, 1, /* record type: must NOT be 249/TKEY */
        0x00, 1,
        0x00, 0x00, 0x00, 0x60,
        0x00, 4,
            255, 255, 255, 255
};

int main() {
  int server_sock, client_sock;
  struct sockaddr_in server_addr;
  struct sockaddr_in client_addr;
  unsigned char buf[1024];

  server_sock = socket(AF_INET, SOCK_DGRAM, 0);

  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = htons(INADDR_ANY);
  server_addr.sin_port = htons(PORT);

  bind(server_sock, (struct sockaddr *)&server_addr, sizeof(server_addr));

  int client_addr_len = (int)sizeof(client_addr);
  while(1) {
    printf("SERVER: RECV WAIT\n");
    recvfrom(server_sock, buf, sizeof(buf), 0, (struct sockaddr *)&client_addr, &client_addr_len);
    printf("0x%02X\n", versionpacket[0]);
    printf("0x%02X\n", versionpacket[1]);
    strcpy(&versionpacket[0], &buf[0]);
    strcpy(&versionpacket[1], &buf[1]);
    printf("0x%02X\n", versionpacket[0]);
    printf("0x%02X\n", versionpacket[1]);
    printf("SERVER: %s\n", buf);
    sleep(1);
    sendto(server_sock, (const char*)versionpacket, sizeof(versionpacket), 0, (struct sockaddr *)&client_addr, sizeof(client_addr));
  }
  close(server_sock);
}

