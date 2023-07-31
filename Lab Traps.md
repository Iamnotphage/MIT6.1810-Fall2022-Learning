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

这张表一定要仔细阅读并理解。

下面是Lecture5对这张表的部分解释

> 第一列中的寄存器名字并不是超级重要，它唯一重要的场景是在RISC-V的Compressed Instruction中。基本上来说，RISC-V中通常的指令是64bit，但是在Compressed Instruction中指令是16bit。在Compressed Instruction中我们使用更少的寄存器，也就是x8 - x15寄存器。我猜你们可能会有疑问，为什么s1寄存器和其他的s寄存器是分开的，因为s1在Compressed Instruction是有效的，而s2-11却不是。除了Compressed Instruction，寄存器都是通过它们的ABI名字来引用。

> a0到a7寄存器是用来作为函数的参数。如果一个函数有超过8个参数，我们就需要用内存了。从这里也可以看出，当可以使用寄存器的时候，我们不会使用内存，我们只在不得不使用内存的场景才使用它。

```
Q: Which registers contain arguments to functions?  For example, which register holds 13 in main's call to printf?
A: a0-a7; a2;

Q: Where is the call to function f in the assembly code for main? Where is the call to g? (Hint: the compiler may inline functions.)
A: 无；无；因为g被inline到f中，而f进一步被inline到main函数中

Q: At what address is the function printf located?
A: 0x64a;

Q: What value is in the register ra just after the jalr to printf in main?
A: 0x38; 因为auipc和jalr组合起来进入printf函数之后，ra应该执行0x34的下一条指令，所以是0x38;

Q: Run the following code.

	unsigned int i = 0x00646c72;
	printf("H%x Wo%s", 57616, &i);
      
    What is the output? Here's an ASCII table that maps bytes to characters.
    The output depends on that fact that the RISC-V is little-endian. If the RISC-V were instead big-endian what would you set i to in order to yield the same output? Would you need to change 57616 to a different value?
A: Output: He110 World; 如果是大端存储，那么i=0x726c64即可得到相同输出;57616不用改。

Q: In the following code, what is going to be printed after 'y='? (note: the answer is not a specific value.) Why does this happen?

	printf("x=%d y=%d", 3);

A: 查看0x64a处的printf汇编代码可以发现，有很多sd指令不断用a1到a7的寄存器获取函数参数；这里3已经被a1存储，那么这条语句的输出取决于寄存器a2中的值。
```

# Backtrace

# Alarm