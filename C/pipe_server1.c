#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(void)
{
  pid_t pid;
  int msg_size = 256;
  char msg[msg_size];
  int pp[2];

  pipe(pp);

  pid = fork();

  if (pid == 0) {
    strcpy(msg ,"send message from child");
    close(pp[0]);
   write(pp[1], msg, msg_size+1);
    close(pp[1]);
  } else {
    close(pp[1]);
    read(pp[0], msg, msg_size);
    printf("%s\n", msg);
    close(pp[0]);
  }
  return(0);
}
