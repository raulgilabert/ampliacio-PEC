.include "macros.s"

	.set KERNEL_STACK_ADDR, _kernel_data_end

	.text
	.global _start
_start:
	$movei r0, GSR_handler
	wrs s5, r0 		; set GSR handler adress

	$movei r7, KERNEL_STACK_ADDR ; setup kernel stack

	$call r5, kernel_main 	; jump to main

	halt

GSR_handler:
	;; Save process state
	$save_ctx current

	$movei r7, KERNEL_STACK_ADDR

	rds r0, s2

	movi r1, 14 		; check for syscall
	cmpeq r3, r0, r1
	bnz r3, syscall_handler

	movi r1, 15 		; check for interrupt
	cmpeq r3, r0, r1
	bnz r3, interrupt_handler

exception_handler:
	$table_entry r1, r0, exception_vector_start
	jal r5, r1
	bz r3, GSR_end

interrupt_handler:
	getiid r0
	$table_entry r1, r0, interrupt_vector_start
	jal r5, r1
	bnz r3, GSR_end

syscall_handler:
	rds r0, s3 		; get service number
	$movei r1, (syscall_table_end - syscall_table_start) / 2
	cmplt r2, r0, r1 	; check if it is valid
	bz r2, invalid_syscall

	;; get arguments
	and r1, r7, r7
	$movei r2, current
	ld r2, 0(r2)
	addi r7, r2, 2
	$pop r2, r3, r4, r5
	and r7, r1, r1
	$push r5, r4, r3, r2

	$table_entry r1, r0, syscall_table_start
	jal r5, r1 		; jump to service

	$movei r0, current
	ld r0, 0(r0)
	st 2(r0), r1 		; store return value

	movi r0, 0
	bz r0, GSR_end

invalid_syscall:
	$movei r0, current
	ld r0, 0(r0)
	$movei r1, -1
	st 2(r0), r1 		; return error

GSR_end:
	$restore_ctx current
	reti

	.global cpu_idle
cpu_idle:
	movi r0, 0
	bz r0, cpu_idle

ESR_default_halt:
	halt

ESR_default_resume:
	jmp r6

	.section .rodata
	.balign 2
exception_vector_start:
	.word ESR_default_halt   ; 0 Illegal instruction
	.word ESR_default_halt   ; 1 Unaligned access
	.word ESR_default_resume ; 2 Floating point overflow
	.word ESR_default_resume ; 3 Floating point division by zero
	.word ESR_default_halt   ; 4 Division by zero
	.word ESR_default_halt   ; 5 Undefined
	.word ESR_default_halt   ; 6 ITLB miss
	.word ESR_default_halt   ; 7 DTLB miss
	.word ESR_default_halt   ; 8 ITLB invalid page
	.word ESR_default_halt   ; 9 DTLB invalid page
	.word ESR_default_halt   ; 10 ITLB protected page
	.word ESR_default_halt   ; 11 DTLB protected page
	.word ESR_default_halt   ; 12 Read-only page
	.word ESR_default_halt   ; 13 Protection exception
exception_vector_end:

interrupt_vector_start:
	.word timer_routine
	.word button_routine
	.word switch_routine
	.word keyboard_routine
interrupt_vector_end:

syscall_table_start:
	.word sys_fork
	.word sys_getpid
	.word sys_getticks
	.word sys_readkey
syscall_table_end:
