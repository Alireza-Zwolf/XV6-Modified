#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_get_parent_pid(void)
{
  return myproc()->parent->pid;
}

int
sys_find_largest_prime_factor(void)
{
  int n = myproc()->tf->edx;
  // cprintf("sys_find_largest_prime_factor called with n=%d\n", n);
  
  int maxPrime = -1;
  while (n % 2 == 0) {
      maxPrime = 2;
      n = n / 2;
  }
  while (n % 3 == 0) {
      maxPrime = 3;
      n = n / 3;
  }

  for (int i = 5; i <= n/2; i += 6) {
      while (n % i == 0) {
          maxPrime = i;
          n = n / i;
      }
      while (n % (i+2) == 0) {
          maxPrime = i + 2;
          n = n / (i + 2);
      }
  }

  if (n > 4) {
      maxPrime = n;
  }

  // cprintf("sys_find_largest_prime_factor returning %d\n", maxPrime);
  return maxPrime;
}

int 
sys_get_callers(void)
{
  int sys_call_number;
  if (argint(0, &sys_call_number) < 0)
    return -1;

  get_callers(sys_call_number);
  return 0;
}
