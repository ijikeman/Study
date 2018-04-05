BUILD_DIR := $(shell pwd)
VERBOSE   := 0
bj-m := timer1.o

KDIR    := /lib/modules/$(shell uname -r)/build
PWD     := $(shell pwd)
VERBOSE = 0

default:
		$(MAKE) -C $(KDIR) SUBDIRS=$(BUILD_DIR) M=$(PWD) KBUILD_VERBOSE=$(VERBOSE) modules

clean:
	rm -f *.o *.ko *.mod.c
