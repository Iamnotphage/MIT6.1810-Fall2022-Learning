# Lab Page tables
先切到pgtbl分支
```Linux
$ git fetch
$ git checkout pgtbl
$ make clean
```
- [Lab Page tables](#lab-page-tables)
- [Speed up system calls](#speed-up-system-calls)

# Speed up system calls

先看懂这三个图片：

![fg3-1](/img/fg3-1.png)

![fg3-2](/img/fg3-2.png)

![fg3-4](/img/fg3-4.png)

这里解释一下最后一个图

**（Figure 3.4: A process’s user address space, with its initial stack.）**

左边那一列也就是进程的用户空间，可以看见最上面从上往下有三个主要区域：**trampoline**,**trapframe**以及**unused**。结合该分支下的`kernel/memlayout.h`的宏定义：

```CPP
#define TRAMPOLINE (MAXVA - PGSIZE)
#define TRAPFRAME (TRAMPOLINE - PGSIZE)
#define USYSCALL (TRAPFRAME - PGSIZE)
```

可以看见宏定义USYSCALL利用了**unused**空间，也就是这里来实现'Speed up system calls'

结合第一二三个提示：我们到`kernel/proc.c`

从`allocproc()`到`proc_freepagetable()`函数仔细阅读一遍。

再看看Hints:

<ul>
  <li>You can perform the mapping in <tt>proc_pagetable()</tt> in <tt>kernel/proc.c</tt>.
  </li><li>Choose permission bits that allow userspace to only read the page.
  </li><li>You may find that <tt>mappages()</tt> is a useful utility.
  </li><li>Don't forget to allocate and initialize the page in <tt>allocproc()</tt>.
  </li><li>Make sure to free the page in <tt>freeproc()</tt>.
</li></ul>

结合一二三点，我们进入`proc_pagetable()`函数里面

```CPP
// map the trampoline code
......
if(mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    return 0;
}

// map the trapframe page just below the trampoline
......
if(mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)
(p->trapframe), PTE_R | PTE_W) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
}

// solution: 这里就是所谓的'perform the mapping'
// 同样模仿上文，发现mappages()有一个变量需要斟酌
// 那就是第四个形参pa;

```

这里简单解释一下```mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)```：该函数为pagetable(一整个页表)创捷一个PTE（PageTableElements 也就是一页），从va开始，分配size，映射到pa，权限是perm

到这里发现形参pa没有能够直接用的变量，需要在进程中设定新变量：in `kernel/proc.h`

```CPP
// Per-process state
struct proc {
    struct spinlock lock;
    ......
    ......

    struct usyscall *usyscall; // solution: data page for USYSCALL
};
```

然后就可以直接抄上文了，补全参数。

进入`proc_pagetable()`函数里面:（记得权限改为PTE_U）

```CPP
// solution: 这里就是所谓的'perform the mapping'
// 同样模仿上文，发现mappages()有一个变量需要斟酌
// 那就是第四个形参pa;
if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)
(p->usyscall), PTE_R | PTE_U) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
}
```

解释一下mappages不成功为啥是这几行uvmunmap()函数，其实是因为分配不成功的话，前两次的也不作数了，最后页表pagetable也free了就行,然后直接返回0。

同样的，照猫画虎：
