#include "kernel.h"

extern void (*cpu_idle)(void);

struct task_struct *current;
static struct task_struct *idle_task;
static struct task_struct tasks[NUM_TASKS];

static struct list_head freequeue;
static struct list_head readyqueue;

static uint8_t global_pid;
static uint8_t global_quantum;

static inline struct task_struct *list_pop_front_task(struct list_head *l)
{
	return list_entry(list_pop_front(l), struct task_struct, list);
}

syscall_value_t sys_fork(void)
{
	struct task_struct *new;

	/* Return error when no free tasks remain */
	if (list_empty(&freequeue))
		return -1;

	new = list_pop_front_task(&freequeue);

	/* Copy current task_struct to the new one */
	memcpy(new, current, sizeof(struct task_struct));

	/* Set return value to 0 and an unused PID */
	new->reg.r1 = 0;
	new->pid = sched_get_free_pid();

	/* Place new on the readyqueue */
	list_add_tail(&new->list, &readyqueue);

	return new->pid;
}

syscall_value_t sys_getpid(void)
{
	return current->pid;
}

syscall_value_t sys_getticks(void)
{
	return hw_getticks();
}

syscall_value_t sys_readkey(void)
{
	return hw_readkey();
}

static int sched_needs_switch(void)
{
	if (current->pid == 0) {
		/* Stop idling if there are new tasks */
		if (!list_empty(&readyqueue))
			return 1;
		else
			return 0;
	} else {
		/* Reschedule when quantum expires */
		global_quantum--;
		if (global_quantum == 0)
			return 1;
		else
			return 0;
	}
}

static void sched_task_switch(struct task_struct *next)
{
	global_quantum = next->quantum;
	/* Context will be restored from new current */
	current = next;
}

void sched_schedule(struct list_head *queue)
{
	struct task_struct *next;

	if (current->pid != 0) {
		/* Save current and select another task */
		list_add_tail(&current->list, queue);
		next = list_pop_front_task(&readyqueue);
	} else {
		/* Switch to idle_task if none remain */
		if (list_empty(&readyqueue))
			next = idle_task;
		else
			next = list_pop_front_task(&readyqueue);
	}

	/* Task switch to next */
	sched_task_switch(next);
}

void sched_run(void)
{
	/* Update scheduling info, switch task if needed */
	if (sched_needs_switch()) {
		sched_schedule(&readyqueue);
	}
}

uint8_t sched_get_free_pid(void)
{
	return ++global_pid;
}

static void sched_init_queues(void)
{
	int i;

	/* Initialise scheduling queues */
	INIT_LIST_HEAD(&freequeue);
	INIT_LIST_HEAD(&readyqueue);

	for (i = 0; i < NUM_TASKS; i++)
		list_add_tail(&(&tasks[i])->list, &freequeue);
}

static void sched_init_idle(void)
{
	idle_task = list_pop_front_task(&freequeue);

	idle_task->pid = 0;
	idle_task->quantum = SCHED_DEFAULT_QUANTUM;
	idle_task->reg.pc = (uintptr_t)&cpu_idle;
	idle_task->reg.psw = PSW_IE | PSW_KERNEL_MODE;
}

static void sched_init_task1(void)
{
	struct task_struct *task1 = list_pop_front_task(&freequeue);

	task1->pid = 1;
	task1->quantum = SCHED_DEFAULT_QUANTUM;
	task1->reg.pc = (uint16_t)&_user_code_start;
	task1->reg.psw = PSW_IE | PSW_USER_MODE;

	/* Set task1 as current task */
	sched_task_switch(task1);
}

void sched_init(void)
{
	int i;

	/* Initialise tasks */
	for (i = 0; i < NUM_TASKS; i++) {
		tasks[i].pid = -1;
		memset(&(&tasks[i])->regs, 0, sizeof(tasks[i].regs));
	}

	/* Setup queues, idle and task1 for scheduling */
	sched_init_queues();
	sched_init_idle();
	sched_init_task1();

	/* task1 has PID 1 */
	global_pid = 1;
}

int kernel_main(void)
{
	/* Initialise hardware and scheduling */
	hw_init();
	sched_init();

	/* "Call gate" return */
	void (*user_entry)(void) = (void (*)(void))(&_user_code_start);
	__asm__(
		"wrs s0, %0\n\t"
		"wrs s1, %1\n\t"
		"reti"
		: : "r"(PSW_USER_MODE | PSW_IE), "r"(user_entry)
	);

	return 0;
}
