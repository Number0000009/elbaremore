## Baremore
Baremetal boot environment.

## Builing and running
Make sure to copy a Linux kernel image as `Image` and dtb as `fdt.dtb` (for more info take a look at the linker script).

	make
	./run.sh

## TODO
A *minimal* boot environment.

- Reserve a fucking EL3 stack already, otherwise it's all fiddly when preserving caller registers when calling routines
- Make phex64 macro akin to writeln

## BUGS
- UART divider might need a proper initialization on devboards (works with fvp as is, though)
