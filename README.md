## Baremore
Baremetal boot environment.

## Builing and running
Make sure to copy a Linux kernel image as `Image` and dtb as `fdt.dtb` (for more info take a look at the linker script).

Device tree must contain the following node:

	chosen {
	bootargs = "mem=2G console=ttyAMA0 earlyprintk=pl011,0x1c090000";
	};

Then:

	make
	./run.sh

## TODO
A *minimal* boot environment.

- Add TZC-400 support for actual memory/io filtering? Currently secure memory modelling is disabled, although we do payload (Linux kernel with DTB) relocation from Trusted Boot ROM to DRAM bank 1, which is kinda stupid without having the actual secure memory enabled?

## BUGS
- UART divider might need a proper initialization on devboards (works with fvp as is, though)

## NOTES
Build bootrwrapper:

	./configure --host=aarch64-linux-gnu --with-kernel-dir=/work/kbuild --with-dtb=/work/kbuild/arch/arm64/boot/dts/arm/foundation-v8-gicv3.dtb --with-cmdline="mem=2G console=ttyAMA0 earlyprintk=pl011,0x1c090000" --enable-gicv3
	make
