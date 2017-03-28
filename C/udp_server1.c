#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
// #include <netinet/udp.h>

#define MAX_BUFSIZE 1024
#define MSG_FAILURE -1

struct dns_msg {
    uint8_t id1; // unsigned char id1も同等
    uint8_t id2;
    uint8_t flg1;
    uint8_t flg2;
    uint8_t buf[MAX_BUFSIZE];
};

int main(int argc, char* argv[]) {
    int sock;
    const char* ip;
    unsigned int port;
    struct sockaddr_in server_sock_addr, client_sock_addr;
    unsigned char buf[MAX_BUFSIZE];
    struct dns_msg recv_data;


    ip = argv[1];
    port = atoi(argv[2]);
    sock = get_socket("udp");
    sockaddr_init(ip, port, &server_sock_addr);

    if (bind(sock, (struct sockaddr *)&server_sock_addr, sizeof(server_sock_addr)) < 0) {
        perror("bind() failed.");
        exit(EXIT_FAILURE);
    }

    while(1) {
        recv(sock, &recv_data, MAX_BUFSIZE, 0);
        // UDPパケットのデータ部分のみ受け取っている事がわかる
        printf("0x%02X\n", recv_data.id1);
        printf("0x%02X\n", recv_data.id2);
        printf("0x%02X\n", recv_data.flg1);
        printf("0x%02X\n", recv_data.flg2);

        // recv(sock, buf, MAX_BUFSIZE, 0);
        // // UDPパケットのデータ部分のみ受け取っている事がわかる
        // printf("0x%02X\n", buf[0]);
        // printf("0x%02X\n", buf[1]);
        // printf("0x%02X\n", buf[2]);
        // printf("0x%02X\n", buf[3]);
    }
}

int get_socket(const char *type) {
    int sock, sock_type, sock_protocol;
    if (strcmp(type, "udp") == 0) {
        sock_type = SOCK_DGRAM;
        sock_protocol = IPPROTO_UDP;
    } else if (strcmp(type, "tcp") == 0) {
        sock_type = SOCK_STREAM;
        sock_protocol = IPPROTO_TCP;
    } else {
        perror("Not support socket type.");
        exit(EXIT_FAILURE);
    }

    if ((sock = socket(PF_INET, sock_type, sock_protocol)) < 0) {
        perror("socket() failed.");
        exit(EXIT_FAILURE);
    }
    return sock;
}

int sockaddr_init(const char* ip, unsigned int port, struct sockaddr_in *sock_addr) {
    (*sock_addr).sin_family = AF_INET;
    struct sockaddr_in sockaddr_in;
    // IPアドレスをバイナリに変換しsin_addrに格納
    if ((inet_aton(ip, &(*sock_addr).sin_addr)) == 0) {
        if (strcmp(ip, "ANY") == 0) {
            (*sock_addr).sin_addr.s_addr = htonl(INADDR_ANY);
        } else {
            fprintf(stderr, "Invalid IP Address.\n");
            exit(EXIT_FAILURE);
        }
    }

    if (port == 0) {
        fprintf(stderr, "invalid port number.\n");
        exit(EXIT_FAILURE);
    }
    (*sock_addr).sin_port = htons(port);
}
