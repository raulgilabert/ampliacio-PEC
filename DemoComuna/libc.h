#pragma once
#ifndef LIBC_H
#define LIBC_H

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(*a))

#ifndef NULL
#define NULL ((void *)0)
#endif

#define SYSCALL_FORK     0
#define SYSCALL_GETPID   1
#define SYSCALL_GETTICKS 2
#define SYSCALL_READKEY  3

typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef char int8_t;
typedef int int16_t;
typedef unsigned int size_t;
typedef unsigned int uintptr_t;
typedef unsigned int syscall_value_t;

static inline int _syscall(uint16_t service_number)
{
	int result;
	__asm__(
		"and r0, %0, %0\n"
		"calls r0\n"
		"and %1, r0, r0\n"
		: "=r" (result)
		: "r" (service_number)
	);
	return result;
}

#define fork()     ((int)_syscall(SYSCALL_FORK))
#define getpid()   ((int)_syscall(SYSCALL_GETPID))
#define getticks() ((unsigned int)_syscall(SYSCALL_GETTICKS))
#define readkey()  ((char)_syscall(SYSCALL_READKEY))

void *memcpy(void *destination, const void *source, size_t num);
void *memset(void *ptr, int value, size_t num);
int __mulsi3(int a, int b);

#endif /* LIBC_H */
