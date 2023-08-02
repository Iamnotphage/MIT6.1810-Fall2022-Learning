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

in `answers-traps.txt`

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

A: Output: He110 World; 如果是大端存储，那么i=0x726c64即可得到相同输出;57616不用改。(没搞懂为啥有这题)

Q: In the following code, what is going to be printed after 'y='? (note: the answer is not a specific value.) Why does this happen?

	printf("x=%d y=%d", 3);

A: 查看0x64a处的printf汇编代码可以发现，有很多sd指令不断用a1到a7的寄存器获取函数参数；这里3已经被a1存储，那么这条语句的输出取决于寄存器a2中的值。
```

# Backtrace

这里也是看一下lecture5就很容易懂。主要是Stack Frame相关的知识。

![stack](/img/stackframe.png)

这里需要看懂这个图片，一个简单的数据结构：栈。

一个栈元素中有两项是必备的: **Return Address** 和 **To Prev. Frame**

而xv6中地址都是64bit，也就是8B，所以ra占8B，fp也占8B。

这样遍历整个栈就很容易了。

看下Hints： 

<ul>
 <li>Add the prototype for your <tt>backtrace()</tt> to <tt>kernel/defs.h</tt> so that
  you can invoke <tt>backtrace</tt> in <tt>sys_sleep</tt>.
 </li><li>The GCC compiler stores the frame pointer of the currently
 executing function in the
 register <tt>s0</tt>. Add the following function
 to <tt>kernel/riscv.h</tt>:
 <pre>static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
  return x;
}
</pre>
 and call this function in <tt>backtrace</tt> to read the current frame pointer.  <tt>r_fp()</tt> uses <a href="https://gcc.gnu.org/onlinedocs/gcc/Using-Assembly-Language-with-C.html">in-line
 assembly</a> to read <tt>s0</tt>.
 </li><li>These
 <a href="https://pdos.csail.mit.edu/6.1810/2022/lec/l-riscv.txt">lecture
 notes</a> have a picture of the layout of stack frames. Note that the
 return address lives at a fixed offset (-8) from the frame pointer of a
 stackframe, and that the saved frame pointer lives at fixed offset (-16) from the frame pointer.
 </li><li>Your <tt>backtrace()</tt> will need a way to recognize that
 it has seen the last stack frame, and should stop.
 A useful fact is that the memory allocated for each kernel
 stack consists of a single page-aligned page,
 so that all the stack frames for a given stack
 are on the same page.
 You can use
 <tt>PGROUNDDOWN(fp)</tt>
 (see <tt>kernel/riscv.h</tt>) to identify the
 page that a frame pointer refers to.
 </li></ul>

前两个hint需要我们操作的内容很熟悉了，添加prototype（原型）然后复制一下给定的代码、等等。

这里重点是 **Implement backtrace()**

第三个提示其实就是lecture中所说的栈的结构了，这里backtrace需要输出**return address**即可。

所以我们需要在backtrace函数中实现：遍历栈、输出ra这样一件事情。

提示4说明了边界条件的判定，去`kernel/riscv.h`中可以利用宏定义`PGROUNDDOWN(fp)`来判定边界。

> A useful fact is that the memory allocated for each kernel stack consists of a single page-aligned page, so that all the stack frames for a given stack are on the same page.

上面这句话很重要，它说明了内核栈是页对齐的（也就是4096 B对齐）所以我们才能够利用`PGROUNDDOWN(fp)`来判定边界。

下面是我的具体实现：

in `kernel/printf.c`:

```CPP
// solution: implement a backtrace() function
void
backtrace(void)
{
	printf("backtrace:\n");
	uint64 fp = r_fp(); // get the fp;
	while(fp > PGROUNDDOWN(fp)){
		printf("%p\n",*(uint64*)(fp-8)); //ra 
		// 这里是因为r_fp返回的是uint64类型，存储内容实际上是一个地址
		// 所以减去8之后 （内容变成 ra 的地址）
		// 先转换为uint64 * 类型之后，取他的值，就变成了ra的值了
		// C语言指针基础内容，不多赘述。
		fp = *(uint64 *)(fp-16); // Prev. fp
	}
	return;
}
```
其实这里有个小细节，fp指向内核栈的栈顶，根据栈的结构来看，**fp-8**其实就是**return address**，**fp-16**就是**Prev. fp**了。

因为asm汇编代码中，调用一个函数，建立一个栈之后，是这样的

```x86asm
sum_then_double:
	addi sp,sp,-16
	sd ra,0(sp)
	call sum_to
	......

```

这里的prologue包含两句话, addi和sd

可以看见创建栈是sp = sp-16的，可是这里给的提示也是减法（用fp来减）。根据lecture的说法，fp是指向当前栈顶的。

所以fp做减法之后可以得到ra和Prev. fp

最后根据题目进行测试，通过即可。

别忘了把backtrace()加进 `panic` in `kernel/printf.c`

# Alarm
