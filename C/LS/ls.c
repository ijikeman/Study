#include <stdio.h>
#include <stdlib.h>
#include <fts.h>

int main(int argc, char *argv[]) {
	FTS *ftsp;
	FTSENT *p;

	static char dot[]=".";
	static char *dotav[] = {dot, NULL};

	if (argc == 1)
		argv = dotav;
	else
		argv++;
	ftsp = fts_open(argv, 0, NULL);
	while((p = fts_read(ftsp)) != NULL) {
		printf("%s\n", p->fts_path);
	}
	fts_close(ftsp);
	exit(EXIT_SUCCESS);
}
