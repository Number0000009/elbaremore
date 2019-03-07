CROSS_COMPILE ?= aarch64-linux-gnu-

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld

SRC := src/main.S src/el3/vectors.S src/el3/handlers.S
RMM_SRC := src/rmm/rmm.S
INCLUDE := -I include
OBJECTS := main.o vectors.o handlers.o
RMM_OBJECTS := rmm.o
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
	$(CC) $(CFLAGS) $(INCLUDE) $(RMM_SRC) -c
	$(LD) $(OBJECTS) $(RMM_OBJECTS) -o $(OUTPUT) $(LDFLAGS)

clean:
	rm $(OUTPUT) $(OBJECTS) $(RMM_OBJECTS)
