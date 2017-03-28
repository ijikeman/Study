#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main (int argc, char *argv[])
{
    //ソケットファイルディスクリプタ
    int server_sockfd, client_sockfd;
    //ソケットサイズ代入用変数
    int server_len, client_len;
    //ソケットの構造体
    struct sockaddr_in server_address;
    struct sockaddr_in client_address;

    //ソケットを生成
    server_sockfd = socket(AF_INET,SOCK_STREAM ,0);

    //ソケット構造体にパラメータを設定
    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = inet_addr("127.0.0.1");
    server_address.sin_port = htons(7743);

    //構造体のサイズを取得
    server_len = sizeof(server_address);

    //ソケットファイルディスクリプタとソケット構造体を結びつけ
    //俗に言う「ソケットに名前をつける」行為だと思う
    bind(server_sockfd,(struct sockaddr *)&server_address,server_len);

    //接続キューを作成する
    //この場合は接続キューを5個作成
    listen(server_sockfd,5);

    //無限ループ
    while(1) {
        //受信用変数、送信用変数
        char recv_data;
        char send_data;

        //接続要求を受け入れる
        client_len = sizeof(client_address);
        client_sockfd = accept(server_sockfd, (struct sockaddr *)&client_address, &client_len);

        //なんか処理
        //client_sockfdから受信変数に1バイト読み込み
        //インクリメントして送信変数に代入
        //client_sockfdに送信変数から1バイト書き込み
        read(client_sockfd, &recv_data,1);
        send_data = recv_data+1;
        write(client_sockfd, &send_data, 1);

        //クライアントソケットを閉じる
        close(client_sockfd);
    }
}
