BUILD_DIR := $(shell pwd)
VERBOSE   := 0
obj-m := hello.o

KDIR    := /lib/modules/3.10.0-693.21.1.el7.x86_64/build
PWD     := $(shell pwd)
VERBOSE = 0

default:
	$(MAKE) -C $(KDIR) SUBDIRS=$(BUILD_DIR) M=$(PWD) KBUILD_VERBOSE=$(VERBOSE) modules

clean:
	rm -rf  *.o *.ko *.mod.c *.symvers *.order .tmp_versions .hello.*
