CROSS_COMPILE ?= aarch64-linux-gnu-

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld

SRC := src/main.S src/el3/vectors.S src/el3/handlers.S
INCLUDE := -I include
OBJECTS := main.o vectors.o handlers.o
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
