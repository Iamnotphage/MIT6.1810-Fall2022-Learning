# Lab Copy on Write
先切到cow分支
```Linux
$ git fetch
$ git checkout cow
$ make clean
```
- [Lab Copy on Write](#lab-copy-on-write)
- [Implement copy-on-write fork](#implement-copy-on-write-fork)

先去看看lecture 8

这里放一张scause的图表：

![scause](/img/scause.png)

表示trap机制中进入supervisor mode的原因。

<h2>The problem</h2>


The fork() system call in xv6 copies all of the parent process's
user-space memory into the child. If the parent is large, copying can
take a long time. Worse, the work is often largely wasted:
fork() is commonly followed by exec() in the child, which 
discards the copied memory, usually without using most of it.
On the other hand, if both parent and child use a copied page, and one or both
writes it, the copy is truly needed.

<h2>The solution</h2>

Your goal in implementing copy-on-write (COW) fork() is to defer allocating and
copying physical memory pages until the copies are actually
needed, if ever.

<p>
COW fork() creates just a pagetable for the child, with PTEs for user
memory pointing to the parent's physical pages. COW fork() marks all
the user PTEs in both parent and child as read-only. When either
process tries to write one of these COW pages, the CPU will force a
page fault. The kernel page-fault handler detects this case, allocates
a page of physical memory for the faulting process, copies the
original page into the new page, and modifies the relevant PTE in the
faulting process to refer to the new page, this time with the PTE
marked writeable. When the page fault handler returns, the user
process will be able to write its copy of the page.

</p>

<p>
COW fork() makes freeing of the physical pages that implement user
memory a little trickier. A given physical page may be referred to by
multiple processes' page tables, and should be freed only when the
last reference disappears.  In a simple kernel like xv6 this
bookkeeping is reasonably straightforward, but in production kernels
this can be difficult to get right; see, for example,
<a href="https://lwn.net/Articles/849638/">Patching until the COWs
come home</a>.

</p>

# Implement copy-on-write fork

solution:

可以根据网页中some reasonable plan of attack来一一攻克难题；

* Modify uvmcopy() to map the parent's physical pages into the child, instead of allocating new pages. Clear PTE_W in the PTEs of both child and parent for pages that have PTE_W set.
  
* Modify usertrap() to recognize page faults. When a write page-fault occurs on a COW page that was originally writeable, allocate a new page with kalloc(), copy the old page to the new page, and install the new page in the PTE with PTE_W set. Pages that were originally read-only (not mapped PTE_W, like pages in the text segment) should remain read-only and shared between parent and child; a process that tries to write such a page should be killed.

* Ensure that each physical page is freed when the last PTE reference to it goes away -- but not before. A good way to do this is to keep, for each physical page, a "reference count" of the number of user page tables that refer to that page. Set a page's reference count to one when kalloc() allocates it. Increment a page's reference count when fork causes a child to share the page, and decrement a page's count each time any process drops the page from its page table. kfree() should only place a page back on the free list if its reference count is zero. It's OK to to keep these counts in a fixed-size array of integers. You'll have to work out a scheme for how to index the array and how to choose its size. For example, you could index the array with the page's physical address divided by 4096, and give the array a number of elements equal to highest physical address of any page placed on the free list by kinit() in kalloc.c. Feel free to modify kalloc.c (e.g., kalloc() and kfree()) to maintain the reference counts.

* Modify copyout() to use the same scheme as page faults when it encounters a COW page.

然后就是
Some hints:

* It may be useful to have a way to record, for each PTE, whether it is a COW mapping. You can use the RSW (reserved for software) bits in the RISC-V PTE for this.
* usertests -q explores scenarios that cowtest does not test, so don't forget to check that all tests pass for both.
Some helpful macros and definitions for page table flags are at the end of kernel/riscv.h.
* If a COW page fault occurs and there's no free memory, the process should be killed.

这里对于lab实现来说，其实没有像前面那样一条条看，然后根据提示照做那么简单。

PS: **对于新建函数在defs.h定义等操作不赘述**

提示的第一条告知我们需要给每个PTE设置一个COW bit来标识是否是COW页。

in `kernel/riscv.h`:

```CPP
#define PTE_COW (1L << 8) // solution: use RSW bits
```

然后根据攻克攻略的第三条，我们需要建立一个"reference count"的变量，来对每一个pte进行映射的计数。

in `kernel/kalloc.c`:

```CPP
struct {
  struct spinlock lock;
  struct run *freelist;
  int ref[PHYSTOP / PGSIZE]; // ref count
} kmem;

// solution: 

void
ref_increase(void* pa){
  acquire(&kmem.lock);
  kmem.ref[(uint64)pa/PGSIZE]++;
  release(&kmem.lock);
}

void
ref_decrease(void* pa){
  acquire(&kmem.lock);
  kmem.ref[(uint64)pa/PGSIZE]--;
  release(&kmem.lock);
}

// 因为kinit初始化操作调用了freerange()
void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    kmem.ref[(uint64)p / PGSIZE]= 1;
    kfree(p);
  }
}

// kfree也要对ref进行操作
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // solution: ref decrease
  acquire(&kmem.lock);
  kmem.ref[(uint64)pa/PGSIZE]--;
  if(kmem.ref[(uint64)pa/PGSIZE] <= 0){
    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);

    r = (struct run*)pa;

    r->next = kmem.freelist;
    kmem.freelist = r;
  }
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r){
    kmem.freelist = r->next;
    kmem.ref[(uint64)r/PGSIZE] = 1;// solution
  }
  release(&kmem.lock);

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
  }
  return (void*)r;
}
```

第一条来看，让我们修改uvmcopy()函数，这个其实在`kernel/proc.c`的fork()函数中被调用了：

```CPP
int
fork(void)
{
  ......
  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  ......
  return pid;
}
```

这可能造成很大程度的浪费，因为子进程可能根本没有用到父进程的一些页表，那么我们需要在uvmcopy()中进行映射而不是直接复制父进程的页表；这样需要写的时候，父子进程就不再共享某一个pte，那个pte才进行复制，从而节约资源。

所以我们在uvmcopy中修改关于页表分配的内容，让子进程和父进程共享页表（也就是子进程的页表指针指向父进程，需要写子进程的页的时候再复制copy on write）

in `kernel/vm.c`:

```CPP
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  //char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);

    // solution: modify uvmcopy() and clear PTE_W
    // if((mem = kalloc()) == 0)
    //   goto err;
    // memmove(mem, (char*)pa, PGSIZE);

    if(*pte & PTE_W){
      *pte = (*pte & (~PTE_W)) | PTE_COW;
    }

    ref_increase((void*)pa);
    flags = PTE_FLAGS(*pte);
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
      //kfree(mem);
      goto err;
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}
```

那么接下来需要在usertrap中添加一些出现page fault后的情况

in `kernel/trap.c`:

```CPP
void
usertrap(void){
......
  } else if((which_dev = devintr()) != 0){
    // ok
  } else if( (r_scause() == 15 || r_scause() == 13) )  {
    // solution: Modify usertrap() to recognize page faults
    //printf("cow start!\n");
    uint64 va = r_stval();
    if( va < PGROUNDDOWN(p->trapframe->sp) && 
        va >= PGROUNDDOWN(p->trapframe->sp)-PGSIZE){
          p->killed=1;
    }else{
      int ret;
      if( (ret = cow_alloc(p->pagetable, va)) < 0){
        p->killed=1;
      }
    }
  } else {
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    setkilled(p);
  }
......
}
```

这里有一个cow_alloc函数我们还没写，就是最核心的，遇到了copy on write该怎么复制这个页。

in `kernel/kalloc.c`:

```CPP
int
cow_alloc(pagetable_t pagetable, uint64 va){
  uint64 pa;
  uint64 mem;
  pte_t *pte;
  int flags;

  if(va >= MAXVA){
    return -1;
  }
  va = PGROUNDDOWN(va);
  pte = walk(pagetable, va ,0);

  if(pte == 0){
    return -1;
  }else if( !(*pte & PTE_V)){
    return -1;
  }else if( !(*pte & PTE_U)){
    return -1;
  }

  pa = PTE2PA(*pte);
  flags = PTE_FLAGS(*pte);

// 下面这一坨if else非常重要
  if(flags & PTE_W){
    return 0;
  }else if((flags & PTE_COW) == 0){
    return -1;// without cow bit
  }

  acquire(&kmem.lock);
  if(kmem.ref[pa/PGSIZE] == 1){
    *pte &= ~PTE_COW;
    *pte |= PTE_W;
    release(&kmem.lock);
    return 0;
  }
  release(&kmem.lock);

  if( (mem=(uint64)kalloc()) == 0){
    return -1;// out of memory
  }
  memmove((void*)mem, (void*)pa, PGSIZE);
  *pte = ((PA2PTE(mem) | PTE_FLAGS(*pte) | PTE_W) & (~PTE_COW));

  kfree((void *)pa);
  return 0;
}
```

最后一个，容易忽略的：

* Modify copyout() to use the same scheme as page faults when it encounters a COW page.

in `kernel/vm.c`:

```CPP
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    va0 = PGROUNDDOWN(dstva);
    cow_alloc(pagetable, va0);// solution: copy on write
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE;
  }
  return 0;
}
```

记得添加一下time.txt进行记录

总算是通过了。(20230823)

![cow](/img/grade-lab-cow.png)