#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.
  // solution: implement
  uint64 addr; // arg 0 the starting virtual address of the first user page to check
  int n; // arg 1 the number of pages to check
  int bitmask; // arg 2 a user address to a buffer to store the results into a bitmask
  struct proc* p = myproc(); // current process
  int buf = 0; // store a temporary buffer in the kernel; 
  // assume that all pages are not accessed: 0x0000 0000 (32 PTEs)

  argaddr(0, &addr);
  argint(1, &n);
  argint(2,&bitmask);

  // upper limit and lower limit for safety
  if( n > 32 || n < 0){
    return -1;
  }

  // result in buf
  pte_t *pte = 0;

  for(int i = 0; i < n; i++){
    int va = addr + i * PGSIZE;
    pte = walk(p->pagetable, va, 0);
    if(*pte & PTE_A){
      buf = buf | (1L << i); // i_th page is accessed
    }
    *pte = (*pte) & ~PTE_A; // set the access bit (PTE_A) to zero
  }

  if(copyout(p->pagetable, bitmask, (char*)&buf, sizeof(buf)) < 0){
    return -1;
  }

  return 0;
}
#endif

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
