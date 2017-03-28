#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(void) {
  pid_t pid;
  int msg_size = 256;
  char msg1[msg_size];
  char msg2[msg_size];
  char result[msg_size];
  int pp[2], qq[2];

  pipe(pp);
  pipe(qq);
  pid = fork();

  if (pid == 0) {
    close(pp[0]);
    close(qq[1]);
    strcpy(msg1, "abc");
    strcpy(msg2, "def");
    printf("[Child]: Sent Message '%s'\n", msg1);
    write(pp[1], msg1, sizeof(msg1));
    printf("[Child]: Sent Message '%s'\n", msg2);
    write(pp[1], msg2, sizeof(msg2));
    close(pp[1]);
    read(qq[0], result, msg_size);
    close(qq[0]);
    printf("[Child]: Recieved Message '%s'\n", result);
  } else {
    close(pp[1]);
    close(qq[0]);
    read(pp[0], msg1, sizeof(msg1));
    printf("[Parent]: Recieved Message '%s'\n", msg1);
    read(pp[0], msg2, sizeof(msg2));
    printf("[Parent]: Recieved Message '%s'\n", msg2);
    close(pp[0]);
    strcat(msg1, msg2);
    printf("[Parent]: Send Message '%s'\n", msg1);
    write(qq[1], msg1, sizeof(msg1));
    close(qq[1]);
  }
}
