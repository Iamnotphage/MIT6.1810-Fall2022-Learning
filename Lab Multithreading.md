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

# Using threads

# Barrier

