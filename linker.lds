MEMORY
{
/* Per ARM DUI0837F */
/* Trusted Boot ROM, S */
        .TBROM : ORIGIN = 0x00000000, LENGTH = 0x3ffffff

/* Trusted SRAM, S */
        .TSRAM : ORIGIN = 0x04000000, LENGTH = 0x3ffff

/* Trusted DRAM, S */
        .TDRAM : ORIGIN = 0x06000000, LENGTH = 0x1ffffff

/* Non-trusted SRAM, S/NS */
         .SRAM : ORIGIN = 0x2e000000, LENGTH = 0xffff
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
