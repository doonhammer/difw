#
# # SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
#

#
# Get the right target kernel include files
#
OS=$(shell lsb_release -si)
TARGET_OS := Ubuntu
ifeq ($(OS), $(LOCAL_VERSION))
	KERNEL_VERSION = kernels/$(shell uname -r)
else
	KERNEL_VERSION =  linux-headers-$(shell uname -r)
endif

PROGRAM_NAME ;= difw
EBPF_NAME := $(PROGRAM_NAME)
EBPF_PROGRAM := $(PROGRAM_NAME)
XDP_TARGETS := $(PROGRAM_NAME)_kern
#
USER_TARGETS := $(EBPF_PROGRAM)
LLC := llc
CLANG := clang
CC = gcc -g -c -fPIC 
#
ARCH := x86_64
XDP_C = ${XDP_TARGETS:=.c}
XDP_OBJ = ${XDP_C:.c=.o}
#
NOSTDINC_FLAGS := -nostdinc 
#
# Source Directories
#
C_SRC_DIR := src
vpath  %.c $(C_SRC_DIR) common
#
H_SRC_DIR := src
vpath  %.h $(H_SRC_DIR) common
#
OBJ_DIR := obj
BIN_DIR := bin
#
#LIBBPF_DIR := ../../../github.com/libbpf
##OBJECT_LIBBPF := /usr/lib64/libbpf.a
#OBJECT_LIBELF := /usr/lib/x86_64-linux-gnu/libelf.a
#OBJECT_LIBZ := /usr/lib/x86_64-linux-gnu/libz.a
#
LD := gcc --verbose
#LDFLAGS := -L$(LIBBPF_DIR) 
#LDFLAGS := -Wl, -Bstatic
#
LIBS = -lc -lz -lelf -lbpf
#LIBS = -lc -pthread
#
# Required BPF Directories
# 

#
# CLANG BPF Include files 
#
#srctree := /usr/src/linux-$(KERNEL_VERSION)
HOSTCFLAGS ?= -I/usr/include/
HOSTCFLAGS += -I/usr/src/$(KERNEL_VERSION)/include/
HOSTCFLAGS += -I/usr/include/x86_64-linux-gnu/
#HOSTCFLAGS += -I/usr/include/
#HOSTCFLAGS += -I/home/jmcdowall/repository/code/go/src/github.com/libbpf/include/uapi/
#HOSTCFLAGS += -I/usr/include/linux
#HOSTCFLAGS += -I$(srctree)/usr/include
#HOSTCFLAGS += -I/usr/lib/gcc/x86_64-redhat-linux/4.8.2/include
#HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
#HOSTCFLAGS += -I$(srctree)/tools/include/
#HOSTCFLAGS += -I$(srctree)/include/
#
# GCC Flags only
#
#CFLAGS ?= -I$(LIBBPF_DIR)/include/uapi
CFLAGS ?= -I/usr/include/
#CFLAGS += -I/home/vagrant/repository/code/go/src/github.com/libbpf/include
#CFLAGS += -DNONBLOCK -DDEBUG
#CFLAGS += -DDEBUG2
CFLAGS += -DBUFFER
#CFLAGS += -I$(LIBBPF_DIR)/include
#CFLAGS ?= -I/usr/src/$(KERNEL_VERSION)/include/
#CFLAGS += -I/home/jmcdowall/repository/code/go/src/github.com/libbpf/src/root/usr/include/
#CFLAGS += -I/home/jmcdowall/repository/code/go/src/github.com/libbpf/include/
#CFLAGS += -I/home/jmcdowall/repository/code/go/src/github.com/libbpf/include/uapi/
#
#CFLAGS += -I$(LIBBPF_DIR)/usr/include/
#
#CFLAGS ?= -I/usr/include/
#CFLAGS += -I/usr/src/linux-$(KERNEL_VERSION)/tools/lib/
#CFLAGS += -I/usr/src/linux-$(KERNEL_VERSION)/tools/testing/selftests/bpf/
#CFLAGS += -I/usr/src/linux-$(KERNEL_VERSION)/tools/perf/
#CFLAGS += -I/usr/src/linux-$(KERNEL_VERSION)/tools/include/
#
#
OBJS = \
	$(OBJ_DIR)/$(EBPF_PROGRAM).o \
	$(OBJ_DIR)/xdp_load.o

$(EBPF_PROGRAM).o: $(EBPF_PROGRAM).c
	$(CC) $(CFLAGS) $< -o $(OBJ_DIR)/$@

xdp_load.o: xdp_load.c
	$(CC) $(CFLAGS) $< -o $(OBJ_DIR)/$@
#
dyk_error.o: dyk_error.c
	$(CC) $(CFLAGS) $< -o $(OBJ_DIR)/$@
#
#
all: llvm-check $(USER_TARGETS) $(XDP_OBJ)
#
llvm-check: $(CLANG) $(LLC)
	@for TOOL in $^ ; do \
		if [ ! $$(command -v $${TOOL} 2>/dev/null) ]; then \
			echo "*** ERROR: Cannot find tool $${TOOL}" ;\
			exit 1; \
		else true; fi; \
	done
#
$(OBJECT_LIBBPF):
	@if [ ! -d $(LIBBPF_DIR) ]; then \
		echo "Error: Need libbpf submodule"; \
		echo "May need to run git submodule update --init"; \
		exit 1; \
	else \
		cd $(LIBBPF_DIR) && $(MAKE) all; \
		mkdir -p root; DESTDIR=root $(MAKE) install_headers; \
	fi
#
$(USER_TARGETS): xdp_load.o dyk_error.o $(EBPF_PROGRAM).o
	$(LD) $(LDFLAGS) $(OBJS) $(LIBS)  -o $@
#
$(XDP_OBJ): %.o: %.c
	$(CLANG) -S $(NOSTDINC_FLAGS) \
	    -target bpf \
	    -D__BPF_TRACING__ \
	    -D__KERNEL__ \
	    -D__TARGET_ARCH_$(ARCH) \
	    $(HOSTCFLAGS) \
	    -Wall \
	    -Wno-unused-value \
	    -Wno-pointer-sign \
	    -Wno-compare-distinct-pointer-types \
	    -O2 -emit-llvm -c -g -o ${@:.o=.ll} $<
	$(LLC) -march=bpf -filetype=obj  -o $@ ${@:.o=.ll}
#
# Clean up
# 
.PHONY: clean $(CLANG) $(LLC)
#
clean:
	rm -f *.o
	rm -f *.ll
	rm -f obj/*.o
	rm -f $(EBPF_PROGRAM)
