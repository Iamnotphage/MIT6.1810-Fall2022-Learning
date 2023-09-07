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





# Using threads



# Barrier

