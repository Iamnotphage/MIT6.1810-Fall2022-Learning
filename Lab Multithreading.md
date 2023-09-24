# Lab Multithreading
先切到thread分支
```Linux
$ git fetch
$ git checkout thread
$ make clean
```
- [Lab Multithreading](#lab-multithreading)
- [Uthread: switching between threads](#uthread-switching-between-threads)
- [Using threads](#using-threads)
- [Barrier](#barrier)

# Uthread: switching between threads

先看看Lecture 11；

然后是关于Caller寄存器和Callee寄存器的区别：

![reg](/img/Table18-2.png)

* Caller Saved寄存器在函数调用的时候不会保存
* Callee Saved寄存器在函数调用的时候会保存

教授在Lecture 5的解释：

    这里的意思是，一个Caller Saved寄存器可能被其他函数重写。假设我们在函数a中调用函数b，任何被函数a使用的并且是Caller Saved寄存器，调用函数b可能重写这些寄存器。我认为一个比较好的例子就是Return address寄存器（注，保存的是函数返回的地址），你可以看到ra寄存器是Caller Saved，这一点很重要，它导致了当函数a调用函数b的时侯，b会重写Return address。所以基本上来说，任何一个Caller Saved寄存器，作为调用方的函数要小心可能的数据可能的变化；任何一个Callee Saved寄存器，作为被调用方的函数要小心寄存器的值不会相应的变化。我经常会弄混这两者的区别，然后会到这张表来回顾它们。

Alright，那么看看要求

<p>In this exercise you will design the context switch mechanism for a
  user-level threading system, and then implement it.  To get you
  started, your xv6 has two files user/uthread.c and
  user/uthread_switch.S, and a rule in the Makefile to build a uthread
  program.  uthread.c contains most of a user-level threading package,
  and code for three simple test threads.
  The threading package is missing some of the code to create a thread and to switch
  between threads.

  </p>

<div class="required">
<p>
Your job is to come up with a plan to create threads and save/restore
registers to switch between threads, and implement that plan.
When you're done,
<tt>make grade</tt> should say that your solution passes the
<tt>uthread</tt> test.
</p></div>

要求大概就是让我们整出一种新建线程和存储寄存器来切换线程的方案。

梳理一下下面的提示，原文有点乱。

* You will need to add code to thread_create() and thread_schedule() in user/uthread.c, and thread_switch in user/uthread_switch.S.
* Ensure that when thread_schedule() runs a given thread for the first time, the thread executes the function passed to thread_create(), on its own stack. 
* Ensure that thread_switch saves the registers of the thread being switched away from, restores the registers of the thread being switched to, and returns to the point in the latter thread's instructions where it last left off.
* Modifying struct thread to hold registers is a good plan.
* thread_switch needs to save/restore only the callee-save registers. Why?
* You can see the assembly code for uthread in user/uthread.asm, which may be handy for debugging.
* 步进调试的示例

根据上面的提示，来进一步梳理一下。

* 首先我们需要在一些函数内部/某些文件种添加一些代码
* thread_schedule() 运行给定线程时，线程要执行 从 thread_create() 传来的函数
* thread_switch 妥善处理寄存器
* thread结构体里面加点东西
* thread_switch 只需要保存callee寄存器
* 参考别的汇编代码

这里已经有点眉目了

首先在结构体thread中，添加context (上下文)

结合梳理的第四个第五个提示:

in `user/uthread.c`:

```c++
// solution: context
struct context{
  uint64 ra;
  uint64 sp;

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

struct thread {
  char       stack[STACK_SIZE]; /* the thread's stack */
  int        state;             /* FREE, RUNNING, RUNNABLE */
  struct context context;       // context
};


```

梳理出来的第二个提示告诉我们`thread_schedule() 运行给定线程时，线程要执行 从 thread_create() 传来的函数`

那我们看一下`thread_create()`函数:

其实就是遍历所有线程，找到FREE状态的设置为RUNNABLE，但是如果要执行传入的函数func，就需要把这个线程的context部分中的ra(return address)设置为func的地址。

为什么呢？因为这里的模拟进程切换实际上就是 proc_1 -> scheduler -> proc_2

当thread_schedule()函数把proc_2弄上cpu时，要恢复context中的寄存器，其中就有ra，这样一旦恢复完寄存器，汇编代码中的ret指令就会跳转到ra中，去执行func

所以我们来写一下// YOUR CODE HERE 下面的部分代码:

in `user/uthread.c`:
```C++
void 
thread_create(void (*func)())
{
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }
  t->state = RUNNABLE;
  // YOUR CODE HERE
  t->context.ra = (uint64)func;
  t->context.sp = (uint64)(t->stack) + STACK_SIZE - 1; // sp points stack base
}
```
那么，继续结合梳理出来的提示，进一步完善`thread_switch()`函数

in `user/uthread.c`:
```c++
extern void thread_switch(uint64, uint64);
```

我们可以发现，根本找不到`thread_switch()`函数的具体实现......

实际上这个函数是用汇编来实现，因为C语言最多只能操作一下内存，但是对于寄存器却无能为力。这里的switch是需要保存和加载寄存器的，所以只能是汇编代码来实现。

我们翻到`uthread_switch.S`文件,根据callee寄存器来进行操作：

保存旧线程的寄存器,恢复新线程的寄存器 (寄存器a0是函数的第一个参数，a1是寄存器的第二个参数)

```asm
	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	/* accroding to switch.S */
	sd ra, 0(a0)
	sd sp, 8(a0)
	sd s0, 16(a0)
	sd s1, 24(a0)
	sd s2, 32(a0)
        sd s3, 40(a0)
        sd s4, 48(a0)
        sd s5, 56(a0)
        sd s6, 64(a0)
        sd s7, 72(a0)
        sd s8, 80(a0)
        sd s9, 88(a0)
        sd s10, 96(a0)
        sd s11, 104(a0)

	ld ra, 0(a1)
	ld sp, 8(a1)
	ld s0, 16(a1)
	ld s1, 24(a1)
	ld s2, 32(a1)
        ld s3, 40(a1)
        ld s4, 48(a1)
        ld s5, 56(a1)
        ld s6, 64(a1)
        ld s7, 72(a1)
        ld s8, 80(a1)
        ld s9, 88(a1)
        ld s10, 96(a1)
        ld s11, 104(a1)
	ret    /* return to ra */

```

最后，我们需要在`user/uthread.c`中，在函数`thread_schedule()`里面添加线程切换的函数即可；

```c++
    if (current_thread != next_thread) {         /* switch threads?  */
        next_thread->state = RUNNING;
        t = current_thread;
        current_thread = next_thread;
        /* YOUR CODE HERE
         * Invoke thread_switch to switch from t to next_thread:
         * thread_switch(??, ??);
         */
        thread_switch((uint64)&t->context, (uint64)&next_thread->context);
    } else
    next_thread = 0;
```

最后make qemu一下，运行一下uthread应该是没问题的。

# Using threads



# Barrier

