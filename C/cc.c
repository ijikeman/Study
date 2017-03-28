#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdlib.h>

int main (int argc, char *argv[])
{
    //ソケットファイルディスクリプタ
    int sockfd;
    //ソケットサイズ代入用変数
    int len;
    //ソケットの構造体
    struct sockaddr_in address;
    //接続結果代入用変数
    int result;
    //受信用変数、送信用変数
    char send_data = 'a';
    char recv_data;

    //ソケットを生成
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);

    //ソケット構造体にパラメータを設定
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = inet_addr("127.0.0.1");
    address.sin_port = htons(7743);

    //構造体のサイズを取得
    len = sizeof(address);

    //サーバに接続要求を出す
    //許可されれば接続する
//    result = connect(sockfd,(struct sockaddr *) &address, len);

    //接続許可が下りなければ
    //-1が返ってくるのでエラー処理
//    if(result == -1) {
//        printf("Server connection err\n");
//        exit(1);
//    }

    //送受信
    send(sockfd,&send_data,1, 0);
printf("Client: Write\n");
    recv(sockfd,&recv_data,1, 0);
printf("Client: Read\n");

    //受信したものを表示
    printf("Recv:%c\n",recv_data);

    //接続を閉じる
    close(sockfd);
    return 0;
}
