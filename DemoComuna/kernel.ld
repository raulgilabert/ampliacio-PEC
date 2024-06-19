OUTPUT_FORMAT("elf32-sisa","elf32-sisa","elf32-sisa")
OUTPUT_ARCH(sisa)

ENTRY(_start)

SECTIONS
{
	. = 0x1000; /* User code & data region */
	.user : {
		_user_code_start = ABSOLUTE(.);
		*(.user.code)
		_user_code_end = ABSOLUTE(.);
		_user_data_start = ABSOLUTE(.);
		*(.user.data)
		_user_data_end = ABSOLUTE(.);
	}

	. = 0x8000; /* Kernel data region */
	_kernel_data_start = ABSOLUTE(.);
	.data : {
		*(.data)
		*(.data*)
		. += 1; /* else .data section does not exist */
	}
	. = ALIGN(2);
	.bss : {
		_kernel_data_bss_start = ABSOLUTE(.);
		*(.bss)
		*(.bss*)
		_kernel_data_bss_end = ABSOLUTE(.);
	}
	. += 0x400; /* Minimum stack */
	. = ALIGN(2);
	_kernel_data_end = ABSOLUTE(.);

	. = 0xC000; /* Kernel code region */
	_kernel_code_start = ABSOLUTE(.);
	.text : {
		*(.text.start)
		*(.text)
		*(.text*)
		*(.rodata)
		*(.rodata*)
	}
	_kernel_code_end = ABSOLUTE(.);
}
