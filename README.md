## Baremore
Baremetal boot environment.

## Builing and running
Make sure to copy a Linux kernel image as `Image` and dtb as `fdt.dtb` (for more info take a look at the linker script).

	make
	./run.sh

## TODO
A *minimal* boot environment.

- Reserve a fucking EL3 stack already, otherwise it's all fiddly when preserving caller registers when calling routines;
- Currently only booting primary core, add SMP;
- SMC ping-pong

## BUGS
- UART divider might need a proper initialization on devboards (works with fvp as is, though)

## NOTES
Build bootrwrapper:

	./configure --host=aarch64-linux-gnu --with-kernel-dir=/work/kbuild --with-dtb=/work/kbuild/arch/arm64/boot/dts/arm/foundation-v8-gicv3.dtb --with-cmdline="mem=2G console=ttyAMA0 earlyprintk=pl011,0x1c090000" --enable-gicv3
	make
