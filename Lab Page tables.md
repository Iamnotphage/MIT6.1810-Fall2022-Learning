# Lab Page tables
先切到pgtbl分支
```Linux
$ git fetch
$ git checkout pgtbl
$ make clean
```
- [Lab Page tables](#lab-page-tables)
- [Speed up system calls](#speed-up-system-calls)
- [Print a page table](#print-a-page-table)
- [Detect which pages have been accessed](#detect-which-pages-have-been-accessed)

# Speed up system calls

先看懂这个图片：

![fg3-4](/img/fg3-4.png)

这里解释一下

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

同样的，根据后两个提示照猫画虎：

in `kernel/proc.c/allocproc()`

```CPP
......
found:
    p->pid = allocpid();
    p->state = USED;

    // Allocate a trapframe page.
    if((p->trapframe = (struct trapframe *)kalloc()) == 0 ){
        freeproc(p);
        release(&p->lock);
        return 0;
    }
    // Solution: Allocate a usyscall
    if((p->usyscall = (struct usyscall *)kalloc()) == 0 ){
        freeproc(p);
        release(&p->lock);
        return 0;
    }

    // solution: initialize
    p->usyscall->pid = p->pid;
......
```

in `kernel/proc.c/freeproc()`

```CPP
// solution: free the page
if(p->usyscall){
    kfree((void*)p->usyscall);
}
p->usyscall = 0;
```

in `kernel/proc.c/proc_freepagetable()`

```CPP
// solution: uvmunmap
uvmunmap(pagetable, USYSCALL, 1, 0);
uvmunmap(pagetable, TRAMPOLINE, 1, 0);
......
```

运行pgtbltest，ugetpid_test:OK

通过。

# Print a page table

先看懂下面这个图片：

![fg3-2](/img/fg3-2.png)

这个实验挺简单的。不多赘述。

先按照提示重点看一下`kernel/vm.c`中的函数`freewalk()`。

其实就是递归遍历这个三级页表（dfs）

那么根据这个操作，直接在最后几行添加这个`vmprint()`函数：

```CPP
// solution: vmprint()
void
recursive_vmprint(pagetable_t pagetable, uint64 depth)
{
    // only 3 level pagetable
    if(depth > 2){
        return;
    }

    // there are 2^9 = 512 PTEs in a page table
    for(int i = 0; i < 512; i++){
        pte_t pte = pagetable[i];
        if(pte & PTE_V){
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
            if(depth == 0){
                printf(" ..%d: pte %p pa %p\n", i , pte, child);
                recursive_vmprint((pagetable_t)child, depth + 1);
            }else if(depth == 1){
                printf(" .. ..%d: pte %p pa %p\n", i , pte, child);
                recursive_vmprint((pagetable_t)child, depth + 1);
            }else{
                printf(" .. .. ..%d: pte %p pa %p\n", i , pte, child);
            }
        }
    }
    return;
}

void 
vmprint(pagetable_t pagetable)
{
    printf("page table %p\n", pagetable);
    recursive_vmprint(pagetable, 0);
    return;
}
```

然后去`kernel/defs.h`中定义这个原型

```CPP
......
// vm.c
......
void    vmprint(pagetable_t); // solution: define the prototype
```

还有`kernel/exec.c`中的`exec()`函数中 在return argc;之前加入给定代码。

```CPP
......
// solution: insert the code
if(p->pid == 1){
    vmprint(p->pagetable);
}

return argc;

......
```

最后运行一下`./grade-lab-pbtbl pte printout`显示OK即可。

# Detect which pages have been accessed

同样还是需要这张图片：

![fg3-2](/img/fg3-2.png)

注意这里我们需要用到PTE_A这个标志位（在第六位）。

test