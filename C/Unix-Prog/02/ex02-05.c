#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>

int buf[1024];

int
main(argc, argv)
int argc;
char *argv[];
{
  int ifd, ofd;
  size_t sz;

  if ((ifd = open(argv[1], O_RDONLY)) < 0)
    return 1;
  if ((ofd = open(argv[2], O_WRONLY)) < 0)
    return 1;
  while ((sz = read(ifd, &buf, sizeof(buf))) >= 0)
    write(ofd, &buf, sz);
  return 0;
}
