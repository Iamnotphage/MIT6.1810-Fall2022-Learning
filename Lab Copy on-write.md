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

提示的第一条告知我们需要给每个PTE设置一个COW bit来标识是否是COW页。

in `kernel/riscv.h`:

```CPP
#define PTE_COW (1L << 8) // solution: use RSW bits
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

总算是通过了。

![cow](/img/grade-lab-cow.png)