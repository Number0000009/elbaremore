CROSS_COMPILE ?= aarch64-linux-gnu-

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld

COMMODITIES := main.o
SRC := src/main.S
OUTPUT := main

CFLAGS := \
	-Wall \
	-Werror \
	-fomit-frame-pointer \
	-fno-common \
	-nostdlib

LDFLAGS := -T linker.lds

all:
	$(CC) $(CFLAGS) $(SRC) -c
	$(LD) $(LDFLAGS) $(COMMODITIES) -o $(OUTPUT)

clean:
	rm $(OUTPUT) $(COMMODITIES)
