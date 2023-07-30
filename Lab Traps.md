# Lab Traps
先切到trap分支:
```Linux
$ git fetch
$ git checkout traps
$ make clean
```
- [Lab Traps](#lab-traps)
- [RISC-V assembly](#risc-v-assembly)
- [Backtrace](#backtrace)
- [Alarm](#alarm)

# RISC-V assembly

20230727：这个lab开始需要非常仔细阅读xv6文档和看lecture了，有点难啃。

20230728：妈的今天世界末日了，台风来了，休息一天。怕断电断网。

关于寄存器，参考 [这里](https://pdos.csail.mit.edu/6.828/2020/readings/riscv-calling.pdf) 的`Table 18.2: RISC-V calling convention register usage.`

![Table18-2](/img/Table18-2.png) 

下面是Lecture5对这张表的部分解释

> 第一列中的寄存器名字并不是超级重要，它唯一重要的场景是在RISC-V的Compressed Instruction中。基本上来说，RISC-V中通常的指令是64bit，但是在Compressed Instruction中指令是16bit。在Compressed Instruction中我们使用更少的寄存器，也就是x8 - x15寄存器。我猜你们可能会有疑问，为什么s1寄存器和其他的s寄存器是分开的，因为s1在Compressed Instruction是有效的，而s2-11却不是。除了Compressed Instruction，寄存器都是通过它们的ABI名字来引用。

> a0到a7寄存器是用来作为函数的参数。如果一个函数有超过8个参数，我们就需要用内存了。从这里也可以看出，当可以使用寄存器的时候，我们不会使用内存，我们只在不得不使用内存的场景才使用它。

```TXT
Q: Which registers contain arguments to functions?  For example, which register holds 13 in main's call to printf?
A: a0-a7; a2;

Q: Where is the call to function f in the assembly code for main? Where is the call to g? (Hint: the compiler may inline functions.)
A: 
```

# Backtrace

# Alarm