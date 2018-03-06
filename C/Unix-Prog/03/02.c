#include <stdio.h>
#include <errno.h>

int main(void)
{
  FILE *fp;
  if ((fp = fopen("/tmp/test.txt", "w")) == NULL) {
    perror("open");
  }
  fputs("12345", fp);
  fputs("67890", fp);
  fclose(fp);

  if ((fp = fopen("/tmp/test.txt", "r")) == NULL) {
    perror("open");
  }
  char s[10];
  fgets(s, 256, fp);
  printf("%s", s);
  fclose(fp);
}
