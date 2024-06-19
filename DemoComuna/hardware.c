#include "hardware.h"

static uint16_t clock_ticks;

static struct cbuffer key_cbuffer;

void hw_init(void)
{
	clock_ticks = 0;
	key_cbuffer.head = 0;
	key_cbuffer.tail = 0;
	key_cbuffer.count = 0;
}

uint16_t hw_getticks(void)
{
	return clock_ticks;
}

char hw_readkey(void)
{
	char key = 0;

	if (key_cbuffer.count > 0) {
		key = key_cbuffer.data[key_cbuffer.tail];
		key_cbuffer.tail = (key_cbuffer.tail + 1) % KEY_CBUFFER_SIZE;
		key_cbuffer.count--;
	}

	return key;
}

void timer_routine(void)
{
	clock_ticks++;
	sched_run();
}

void button_routine(void)
{

}

void switch_routine(void)
{

}

void keyboard_routine(void)
{
	char key_char;

	if (key_cbuffer.count >= KEY_CBUFFER_SIZE)
		return;

	__asm__(
		"in %0, 15\n\t"
		: "=r"(key_char)
	);

	key_cbuffer.data[key_cbuffer.head] = key_char;
	key_cbuffer.head = (key_cbuffer.head + 1) % KEY_CBUFFER_SIZE;
	key_cbuffer.count++;
}
