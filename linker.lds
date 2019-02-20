MEMORY
{
/* Per ARM DUI0837F */
/* Trusted Boot ROM, S */
        .TBROM : ORIGIN = 0x00000000,  LENGTH = 0x3ffffff

/* Trusted SRAM, S */
        .TSRAM : ORIGIN = 0x04000000,  LENGTH = 0x3ffff

/* Trusted DRAM, S */
        .TDRAM : ORIGIN = 0x06000000,  LENGTH = 0x1ffffff

/* Non-trusted SRAM, S/NS */
         .SRAM : ORIGIN = 0x2e000000,  LENGTH = 0xffff

/* DRAM bank 1, 2GB */
        .DRAM1 : ORIGIN = 0x80000000,  LENGTH = 0x7fffffff

/* DRAM bank2 configured for -C bp.dram_size=8 */
/* (-C bp.dram_size=4 has DRAM bank 2 0x08_8000_0000 - 0x08_FFFF_FFFF) */
/* DRAM bank 2, 6GB */
        .DRAM2 : ORIGIN = 0x880000000, LENGTH = 0x17fffffff
}

OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
SECTIONS
{
       .text : {
                . = ALIGN(8);
                main.o (.text)
                *(.text*)
        } >.TBROM

        .rodata : {
                . = ALIGN(8);
                *(.rodata)
        } >.TBROM

        .data : {
                . = ALIGN(8);
                *(.data)
        } >.TSRAM

        .bss : {
                . = ALIGN(8);
                *(.bss)
        } >.TSRAM

        /DISCARD/ : { *(.dynstr*) }
        /DISCARD/ : { *(.dynamic*) }
        /DISCARD/ : { *(.plt*) }
        /DISCARD/ : { *(.interp*) }
        /DISCARD/ : { *(.gnu*) }
        /DISCARD/ : { *(.note*) }
}
