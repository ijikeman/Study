#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

void print_my_port_num(int sock) {
    struct sockaddr_in s;
    int sz = sizeof(s);
    getsockname(sock, (struct sockaddr *)&s, &sz);
    printf("%d\n", ntohs(s.sin_port));
}

struct dns_msg {
    uint8_t id1; // unsigned char id1も同等
    uint8_t id2;
    uint8_t flg1;
    uint8_t flg2;
    uint8_t buf[1024];
};

int
main(int argc, char* argv[]) {
    int sock;
    struct sockaddr_in addr;
    struct sockaddr_in senderinfo;
    int senderinfolen;
    int n;
    char buf[2048];
    struct dns_msg recv_data;

    if (argc != 2) {
        fprintf(stderr, "Usage : %s dstipaddr\n", argv[0]);
        return 1;
    }

    sock = socket(AF_INET, SOCK_DGRAM, 0);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(53);
    inet_pton(AF_INET, argv[1], &addr.sin_addr.s_addr);
    n = sendto(sock, "HELLO", 5, 0, (struct sockaddr *)&addr, sizeof(addr));

    if (n < 1) {
        perror("sendto");
        return 1;
    }

    print_my_port_num(sock);

    memset(buf, 0, sizeof(buf));
    senderinfolen = sizeof(senderinfo);

    recvfrom(sock, &recv_data, sizeof(&recv_data), 0, (struct sockaddr *)&senderinfo, &senderinfolen);
    print_my_port_num(sock);
    printf("0x%02X\n", recv_data.id1);
    printf("0x%02X\n", recv_data.id2);
    printf("0x%02X\n", recv_data.flg1);
    printf("0x%02X\n", recv_data.flg2);
    close(sock);
    return 0;
}
