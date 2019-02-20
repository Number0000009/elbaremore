CROSS_COMPILE ?= aarch64-linux-gnu-

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld

SRC := src/main.S src/uart.S src/vectors.S
INCLUDE := -I include
OBJECTS := main.o uart.o vectors.o
OUTPUT := main

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

clean:
	rm $(OUTPUT) $(OBJECTS)
