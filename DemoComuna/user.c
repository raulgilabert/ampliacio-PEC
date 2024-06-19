#include "libc.h"

int main()
{
	int pid = fork();

	if (pid == 0)
		main1();
	else
		main2();

	return 0;
}
