obj-m := timer1.o

KDIR    := /lib/modules/(uname -r)/build
PWD     := $(shell pwd)
VERBOSE = 0

default:
	$(MAKE) -C $(KDIR) M=$(PWD) KBUILD_VERBOSE=$(VERBOSE) modules

clean:
	rm -rf  *.o *.ko *.mod.c *.symvers *.order .tmp_versions .timer1.*
