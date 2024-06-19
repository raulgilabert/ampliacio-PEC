OUTPUT_FORMAT("elf32-sisa","elf32-sisa","elf32-sisa")
OUTPUT_ARCH(sisa)

ENTRY(_start)

SECTIONS
{
	. = 0x1000;
	.text : {
		*(.text.start)
		*(.text)
		*(.text*)
		*(.rodata)
		*(.rodata*)
	}

	. = ALIGN(2);
	.data : {
		*(.data)
		*(.data*)
		*(.bss)
		*(.bss*)
		. += 0x200; /* Minimum stack */
		. = ALIGN(2);
		_user_stack = ABSOLUTE(.);
	}
}
