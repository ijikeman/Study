#include <stdio.h>

int buf[1024];

int
main(argc, argv)
int argc;
char *argv[];
{
  FILE *isp, *osp;
  size_t sz;
  if ((isp = fopen(argv[1], "r")) == NULL)
    return 1;
  if ((osp = fopen(argv[2], "w")) == NULL)
    return 2;
  while ((sz = fread(buf, 1, sizeof(buf), isp)) > 0)
    fwrite(buf, 1, sz, osp);
  return 0;
}
