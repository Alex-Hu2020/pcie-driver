NAME := riffa
VENDOR_ID0 := 10EE
VENDOR_ID1 := 1172
MAJNUM := 100

CURRENT_PATH := $(shell pwd)

# Build variables
KVER := $(shell uname -r)
LIB_VER_MAJ := 1
LIB_VER_MIN := 0
LIB_VER := $(LIB_VER_MAJ).$(LIB_VER_MIN)
DRVR_HDR := riffa_driver.h
DBUGVAL := DBUG

obj-m += $(NAME).o
$(NAME)-y := riffa_driver.o circ_queue.o

all: builddvr
debug: CC += -DDEBUG -g
debug: DBUGVAL = DEBUG
debug: builddvr
builddvr: $(NAME).ko

$(NAME).ko: *.c *.h
	$(MAKE) -C $(KERNEL_SRC) M=$(shell pwd) modules $(KBUILD_OPTIONS)
	rm -rf $(LIB_OBJS)

modules_install:
	$(MAKE) INSTALL_MOD_STRIP=1 -C $(KERNEL_SRC) M=$(shell pwd) modules_install

unload:
	rmmod $(NAME)

clean:
	rm -Rf *.ko *.cmd *.o *.so *.so.* .*.cmd Module.symvers Module.markers modules.order *.mod.c .tmp_versions *mod

setup:
	if [ -f "$(RHR)" ]; then yum install kernel-devel-`uname -r`;\
	else apt-get install linux-headers-`uname -r`; fi

