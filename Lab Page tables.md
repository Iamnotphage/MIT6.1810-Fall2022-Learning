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

先看一下简要题干：
<div class="required">
Your job is to implement <tt>pgaccess()</tt>, a system call that reports which
pages have been accessed. The system call takes three arguments. First, it takes
the starting virtual address of the first user page to check. Second, it takes the
number of pages to check. Finally, it takes a user address to a buffer to store
the results into a bitmask (a datastructure that uses one bit per page and where
the first page corresponds to the least significant bit). You will receive full
credit for this part of the lab if the <tt>pgaccess</tt> test case passes when
running <tt>pgtbltest</tt>.
</div>

同样还是需要这张图片：

![fg3-2](/img/fg3-2.png)

注意这里我们需要用到PTE_A这个标志位（在第六位）。

结合前五个提示：

我们主要做以下事情：

* 声明变量
* 用argaddr和argint获取参数
* 设置边界条件
* Detect which pages have been accessed(待实现)
* 用copyout函数把结果传给用户空间

in `kernel/sysyproc.c`

```CPP
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
    buf = 0x1111; // just for test

    if(copyout(p->pagetable, bitmask, (char*)&buf, sizeof(buf)) < 0){
        return -1;
    }

    return 0;
}
#endif
```

这里`buf = 0x1111`用于测试代码copyout是否将kernel中的掩码传给user空间。

(这里用buf暂存掩码结果，根据题目，这里的低位的次序表示第几页，比如二进制0000 1111表示第0、1、2、3页均被access过)

后期将补上这段核心代码。

再看后面的提示，需要我们去定义`PTE_A`，结合上图和前文代码:

in `kernel/riscv.h`:

```CPP
#define PTE_A (1L << 6) // solution: define PTE_A
```

这里需要我们仔细阅读`walk()`函数以便我们后期调用。

那么到这里就需要实现核心代码了（检测哪一页被访问过）大体上需要我们这样：

* 获取当前进程的页表
* 用walk()函数获取PTE
* 对PTE中的PTE_A位进行检测，是否被访问
* 如果被访问，buf对应位置1
* 最后PTE中的PTE_A位进行置0（复位）
* 重复用walk()函数获取PTE，直到遍历结束

```CPP
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
```

这里位运算的细节也不算太难。

关于设置buf掩码，初始值一定要是全0，若第i页被访问过(PTE_A)，1左移动i位后和buf按位或运算即可，最后结果存buf。

关于重置PTE_A，先把PTE_A全部取反（111...11011111）然后按位与上pte的值，最后赋值回去。

最后运行一下测试，通过OK就行。