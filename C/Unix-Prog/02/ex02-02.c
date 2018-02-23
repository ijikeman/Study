#include <stdio.h>

int main()
{
  char c;
  // fread(*buff, size, nmemb, stream)
  while (fread(&c, 1, 1, stdin) == 1)
    fwrite(&c, 1, 1, stdout);
}

// ex02-01 < /test.txt > /tmp/test.txt
