# Lab System calls
先切到syscall分支:
```Linux
$ git fetch
$ git checkout syscall
$ make clean
```
- [Lab System calls](#lab-system-calls)
- [System call tracing](#system-call-tracing)
- [Sysinfo](#sysinfo)

# System call tracing

原文要求

<div class="required">
  In this assignment you will add a system call tracing feature that
  may help you when debugging later labs.  You'll create a
  new <tt>trace</tt> system call that will control tracing. It should
  take one argument, an integer "mask", whose bits specify which
  system calls to trace.  For example, to trace the fork system call,
  a program calls <tt>trace(1 &lt;&lt; SYS_fork)</tt>, where <tt>SYS_fork</tt> is a
  syscall number from <tt>kernel/syscall.h</tt>. You have to modify
  the xv6 kernel to print out a line when each system call is about to
  return, if the system call's number is set in the mask.
  The line should contain the
  process id, the name of the system call and the
  return value; you don't need to print the system call
  arguments. The <tt>trace</tt> system call should enable tracing
  for the process that calls it and any children that it subsequently forks,
  but should not affect other processes.
</div>

几点Hints:

<ul><li><p>Add <tt>$U/_trace</tt> to UPROGS in Makefile

</p></li><li><p>Run <kbd>make qemu</kbd> and you will see that the
	compiler cannot compile <tt>user/trace.c</tt>, because the
	user-space stubs for the system call don't exist yet: add a
	prototype for the system call to <tt>user/user.h</tt>, a stub
	to <tt>user/usys.pl</tt>, and a syscall number
	to <tt>kernel/syscall.h</tt>.  The Makefile invokes the perl
	script <tt>user/usys.pl</tt>, which produces <tt>user/usys.S</tt>,
	the actual system call stubs, which use the
	RISC-V <tt>ecall</tt> instruction to transition to the
	kernel. Once you fix the compilation issues,
	run <kbd>trace 32 grep hello README</kbd>; it will fail
	because you haven't implemented the system call in the kernel
	yet.

</p></li><li><p>Add a <tt>sys_trace()</tt> function
	in <tt>kernel/sysproc.c</tt> that implements the new system
	call by remembering its argument in a new variable in
	the <tt>proc</tt> structure (see <tt>kernel/proc.h</tt>). The
	functions to retrieve system call arguments from user space are
	in <tt>kernel/syscall.c</tt>, and you can see examples
        of their use in <tt>kernel/sysproc.c</tt>.
</p></li>

<li><p>Modify <tt>fork()</tt> (see <tt>kernel/proc.c</tt>) to copy
    the trace mask from the parent to the child process. </p></li>

<li><p>Modify the <tt>syscall()</tt> function
	in <tt>kernel/syscall.c</tt> to print the trace output. You will need to add an array of syscall names to index into.</p></li>

<li><p>If a test case passes when you run it inside qemu directly but
  you get a timeout when running the tests using <tt>make grade</tt>, try
  testing your implementation on Athena. Some of tests in this lab can be a bit
  too computationally intensive for your local machine (especially if you use
  WSL).</p></li>

  </ul>

逐一理解，首先Makefile文件就不多说了

```Makefile
$U/_trace\
```

第二个hint需要我们在``user/user.h``和``user/usys.pl``和``kernel/syscall.h``添加相应的内容，可以根据上文来推测。

in ``user/user.h``

```C
// system calls
int fork(void);
......
......
int uptime(void);
// add a prototype for the system call
int trace(int);
```

in ``user/usys.pl``
```perl
......
entry("uptime");
# a stub
entry("trace");
```

in ``kernel/syscall.h``

```C
// System call numbers
#define SYS_fork  1
......
......
#define SYS_trace 22
```

完成上述操作后，运行``trace 32 grep hello README``仍然无法成功，因为在内核中的系统调用还没有实现。

第三个hint很重要，

``Add a sys_trace() function in kernel/sysproc.c that implements the new system call by remembering its argument in a new variable in the proc structure (see kernel/proc.h). ``

解释：
在``kernel/sysproc.c``中添加一个``sys_trace()``函数，这个函数来实现这个新的系统调用。而这个新的系统调用，是通过在proc结构体中的新变量中来记住它的参数。

也就是说，要做两件事，一个是在``kernel/sysproc.c``中添加一个``sys_trace()``函数;一个是要在proc结构体中添加新的变量。

接下来看第三个hint的第二句话，

``The functions to retrieve system call arguments from user space are in kernel/syscall.c, and you can see examples of their use in kernel/sysproc.c.``

在``kernel/syscall.c``中有很多 从用户空间 检索/获取(retrieve)系统调用参数 的函数，具体例子可以参考``kernel/sysproc.c``

通过阅读``kernel/syscall.c``可以发现有很多函数

```C
int fetchaddr(uint64 addr,uint64 *ip);
int fetchstr(uint64 addr,char* buf,int max);
static uint64 argraw(int n);
void argint(int n,int* ip);
void argaddr(int n,uint64 *ip);
int argstr(int n,char* buf,int max);
```

阅读这些函数的注释，结合我们需要的命令行`trace 32 grep hello README`可以看见，我们主要是要获取`32`这个参数，所以我着重阅读了`argint()`函数。而第三个hint第二句话也说明了在`kernel/sysproc.c`中有些许使用`argint()`的例子。

大概的感性认识就是，`argint(int n,int* ip)`将系统调用参数中第n个32bit数存储到ip中。

那么我根据提示，先在`kernel/sysproc.c`中添加`sys_trace()`函数：

```C
uint64
sys_uptime(void)
{
    ...
}

//add a sys_trace()
uint64
sys_trace(void)
{
    printf("sys_trace: test");//目前还不知道填什么
}
```

其实这里可以试着在xv6系统中运行一下`trace 32 grep hello README`可以发现这一行起作用了。

跟着提示，再去`kernel/proc.h`中阅读一下proc结构体。到这里就有些许眉头了，在proc结构体中可以发现一个进程的一些属性，比如pid，该进程的父进程等等。这个Lab让我们实现`trace`，那么需要的就是`trace mask`了，用于确定具体哪一个系统调用需要追踪。比如`trace 32 grep hello README`中，`32`就是`1 << SYS_read`也就是1左移5位，表示追踪`read`系统调用。

那么我们在proc结构体中添加`trace_mask`

```C
struct proc {
    struct spinlock lock;
    ......
    int pid;
    struct proc *parent;
    ......
    //trace mask
    int trace_mask;
};
```

接着到`kernel/syscall.c`中先做些简单工作。

```C
// Prototypes for the functions that handle system calls.
extern unit64 sys_fork(void);
......
extern uint64 sys_trace(void);

......
static uint64 (*syscalls[])(void) = {
[SYS_fork]    sys_fork,
......
[SYS_trace]   sys_trace,
};
```

提示还说，可以从`kernel/sysproc.c`中阅读如何获取参数的例子。

上文我提及了`argint()`，另外一个就是用`myproc()`函数来获取当前进程的相关属性。

**在填写`sys_trace()`函数之前，我们先暂停，继续往下看hint**

第四个hint照做就行，读到`fork()`后有一种恍然大悟的感觉，这里就是父子进程共享内存段的代码实现。

我们把proc结构体中的新变量`trace_mask`复制给子进程。

```C
int 
fork(void)
{
    int i,pid;
    struct proc *np;
    struct proc *p = myproc();
    ......
    // copy trace mask
    np->trace_mask=p->trace_mask;
    ......
}
```

第五个hint就是真正实现`trace`了，在这里先捋一下整个`trace`的过程。

首先`trace 32 grep hello README`中，

用户态运行`trace 32`，在`user/trace.c`中的main函数可以看见调用了`trace()`函数。

然后就从用户态进入到内核态,执行`sys_trace()`函数,这个函数通过某种方式把参数(mask)传给`syscall()`函数,然后`syscall()`函数输出结果,这个结果包括当前进程的pid,系统调用的名字及其返回值.

这里所说的"通过某种方式"其实已经明了,使用`myproc()`对当前进程的proc结构体中的trace_mask赋值即可.

in `kernel/sysproc.c`:

```C
uint64
sys_trace(void)
{
    struct proc *p = myproc();

    int mask;
    argint(0, &mask);

    p->trace_mask=mask;
    return 0;
}
```

in `kernel/syscall.c`:

```C
// syscall_names
char* syscall_names[] = {
    "fork",
    "exit",
    ......
    "trace",
}


void
syscall(void)
{
    int num;
    struct proc *p = myproc();

    num = p->trapframe->a7;
    if(num > 0 && num < NELEM(syscalls) && syscalls[num] ) {
        //这里num是系统调用的数 比如SYS_read是5,
        //然后syscalls[nums]()返回的是系统调用的返回值,存到a0寄存器里面.
        p->trapframe->a0 = syscalls[nums]();

        // solution
        if( (p->trace_mask >> num) & 1 ){
            printf("%d: syscall %s -> %d\n",p->pid,syscall_names[num - 1],p->trapframe->a0);
        }
    }else{
        ......
    }
}
```

经检验,通过测试.

# Sysinfo

原文要求：
<div class="required">
  In this assignment you will add a system call, <tt>sysinfo</tt>,
  that collects information about the running system.  The system call
  takes one argument: a pointer to a <tt>struct sysinfo</tt>
  (see <tt>kernel/sysinfo.h</tt>). The kernel should fill out the
  fields of this struct: the <tt>freemem</tt> field should be set
  to the number of bytes of free memory, and the <tt>nproc</tt>
  field should be set to the number of processes whose <tt>state</tt>
  is not <tt>UNUSED</tt>.
  We provide a test program <tt>sysinfotest</tt>; you pass this
  assignment if it prints "sysinfotest: OK".
</div>

前两点提示与`trace`实验类似，在Makefile里面添加一行，在`user/user.h`，`user/usys.pl`，`kernel/syscall.h`以及`kernel/syscall.c`中添加类似的代码即可。

注意在`user/user.h`中要添加一个

```C
struct sysinfo;
int sysinfo(struct sysinfo*);
```

到这里编译没有问题。

查看`sysinfo`结构体内部，有两个东西。一个是`freemem`一个是`nproc`(其状态不能是UNUSED)

接下来第三个提示就比较重要。

目的是把结构体sysinfo从内核空间复制到用户空间。而需要我们借鉴`sys_fstat()`和`filestat()`两个函数的实例，来学会使用`copyout()`

`copyout()`个人理解：

```CPP
int copyout(pagetable_t pagetable, uint64 dstva, char* src, uint64 len);
```

按照注释也能感性认识，从src中取len字节数据传给dstva(destination vitural address)的用户空间。

那么结合`sys_fstat()`和`filestat()`，在`kernel/sysproc.c`把函数写完。

```CPP
uint64
sys_sysinfo(void)
{
    struct sysinfo si;// sysinfo
    uint64 addr; // user pointer to struct sysinfo
    struct proc* p = myproc();

    argaddr(0, &addr);// only one argument: struct sysinfo* ,so we use argaddr()

    // waiting for implement
    si.freemem = -1;
    si.nproc = -1;

    // copy from kernel to user space;
    if(copyout(p->pagetable, addr, (char*)&si, sizeof(si)) < 0){
        return -1;
    }

    return 0;
}
```

第四第五个提示也很明确了，前往`kernel/kalloc.c`和`kernel/proc.c`添加两个函数，获取sysinfo结构体中的两个变量：`freemem`和`nproc`即可。

in `kernel/kalloc.c`:

这个文件中`kmem`是全局的结构体变量，内部有个锁lock，以及一个链表freelist;我们数完freelist之后，数量乘以每页的大小(4096)即可。(注意看kalloc()函数，分配以PGSIZE为单位)

```CPP
uint64
collect_freemem(void)
{
    struct run *r;
    uint64 cnt = 0;// number of freemem

    acquire(&kmem.lock);
    r = kmem.freelist;

    while(r){
        r = r->next;
        cnt++;
    }
    release(&kmem.lock);

    return PGSIZE * cnt;// bytes per page times cnt;
}

```

in `kernel/proc.c`:

数进程数很简单，注意是‘非UNUSED’进程。阅读这个文件可以知道有个进程池类似的概念（变量`proc`数组）就从这里数。

```CPP
uint64
collect_nproc(void)
{
    struct proc* p;
    uint64 cnt = 0;

    for(p = proc; p < &proc[NPROC]; p++){
        if(p->state != UNUSED){
            cnt++;
        }
    }
    return cnt;
}
```

把这俩实现的函数在`kernel/sysproc.c`中声明，然后在`sys_sysinfo()`中调用即可。

```CPP
uint64 collect_freemem(void);
uint64 collect_nproc(void);

......

uint64
sys_sysinfo(void)
{
    struct sysinfo si;// sysinfo
    uint64 addr; // user pointer to struct sysinfo
    struct proc* p = myproc();

    argaddr(0, &addr);// only one argument: struct sysinfo* ,so we use argaddr()

    // implement
    si.freemem = collect_freemem();
    si.nproc = collect_nproc();

    // copy from kernel to user space;
    if(copyout(p->pagetable, addr, (char*)&si, sizeof(si)) < 0){
        return -1;
    }

    return 0;
}
```

运行`sysinfotest`这个实验就此结束了。