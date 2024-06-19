#pragma once
#ifndef HARDWARE_H
#define HARDWARE_H

#include "libc.h"

#define KEY_CBUFFER_SIZE 32

struct cbuffer {
	char data[KEY_CBUFFER_SIZE];
	uint8_t head;
	uint8_t tail;
	uint8_t count;
};

void hw_init(void);
uint16_t hw_getticks(void);
char hw_readkey(void);

#endif /* HARDWARE_H */
