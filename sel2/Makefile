CROSS_COMPILE ?= aarch64-linux-gnu-

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld
OC := $(CROSS_COMPILE)objcopy

SRC := src/rmm/rmm.S
INCLUDE := -I ../include
OBJECTS := rmm.o
OUTPUT := rmm

CFLAGS := \
	-Wall \
	-Werror \
	-fomit-frame-pointer \
	-fno-common \
	-nostdlib

LDFLAGS := -T linker.lds

all:
	$(CC) $(CFLAGS) $(INCLUDE) $(SRC) -c
	$(LD) $(OBJECTS) -o $(OUTPUT) $(LDFLAGS)
	$(OC) -O binary $(OUTPUT)

clean:
	rm $(OUTPUT) $(OBJECTS)
