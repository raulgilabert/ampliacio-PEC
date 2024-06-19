#pragma once
#ifndef KERNEL_H
#define KERNEL_H

#include "libc.h"
#include "list.h"
#include "hardware.h"

extern void _user_code_start;
extern void _user_code_end;
extern void _user_data_start;
extern void _user_data_end;
extern void _kernel_code_start;
extern void _kernel_code_end;
extern void _kernel_data_start;
extern void _kernel_data_end;

#define EXC_INV_INSTR   0x0
#define EXC_ODD_ADRESS  0x1
#define EXC_OVERFLOW_FP 0x2
#define EXC_DIV_ZERO_FP 0x3
#define EXC_DIV_ZERO    0x4
#define EXC_ITLB_MISS   0x6
#define EXC_DTLB_MISS   0x7
#define EXC_ITLB_INV    0x8
#define EXC_DTLB_INV    0x9
#define EXC_ITLB_PROT   0xA
#define EXC_DTLB_PROT   0xB
#define EXC_DTLB_RONLY  0xC
#define EXC_PROT_INSTR  0xD
#define EXC_CALLS       0xE
#define EXC_INT         0xF

#define INT_TIMER    0x0
#define INT_BUTTON   0x1
#define INT_SWITCH   0x2
#define INT_KEYBOARD 0x3

#define PSW_USER_MODE   0
#define PSW_KERNEL_MODE 1
#define PSW_IE          2

#define NUM_TASKS 3

#define SCHED_DEFAULT_QUANTUM 1

struct task_struct {
	union {
		struct {
			uint16_t r0;
			uint16_t r1;
			uint16_t r2;
			uint16_t r3;
			uint16_t r4;
			uint16_t r5;
			uint16_t r6;
			uint16_t r7;
			uint16_t pc;
			uint16_t psw;
		} reg;
		uint16_t regs[10];
	};
	uint8_t pid;
	uint8_t quantum;
	struct list_head list;
};

/* Scheduling */
void sched_init(void);
void sched_run(void);
void sched_schedule(struct list_head *queue);
uint8_t sched_get_free_pid(void);

#endif /* KERNEL_H */
