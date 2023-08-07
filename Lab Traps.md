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

xv6book里面说，会使用Trap机制的情况大概分三类：

* system calls 系统调用
* exceptions   异常
* interrupts   硬件中断

先在这里整理一下在Trap机制中非常重要的一些寄存器：

* SATP（Supervisor Address Translation and Protection）寄存器，它包含了指向page table的物理内存地址
* STVEC（Supervisor Trap Vector Base Address）寄存器，它指向了内核中处理trap的指令的起始地址
* SEPC（Supervisor Exception Program Counter）寄存器，在trap的过程中保存程序计数器的值
* SSCRATCH（Supervisor Scratch Register）寄存器，在进入到user space之前，内核会将trapframe page的地址保存在这个寄存器中，也就是0x3fffffe000这个地址。更重要的是，RISC-V有一个指令允许交换任意两个寄存器的值。而SSCRATCH寄存器的作用就是保存另一个寄存器的值，并将自己的值加载给另一个寄存器。

其次是Trap机制的过程：

* ![Trap](/img/trap1.png)

看一下alarm实验的要求：

> In this exercise you'll add a feature to xv6 that periodically alerts
a process as it uses CPU time. This might be useful for compute-bound
processes that want to limit how much CPU time they chew up, or for
processes that want to compute but also want to take some periodic
action. More generally, you'll be implementing a primitive form of
user-level interrupt/fault handlers; you could use something similar
to handle page faults in the application, for example.  Your solution
is correct if it passes alarmtest and 'usertests -q'

需要我们通过test0、test1等等

这里注册系统调用sigalarm()和sigreturn()就不赘述了。

与前几个lab中注册系统调用的操作一模一样。

先试着通过test0吧，这里其实跟lecture6没啥区别的，就是细节非常多。

从user到kernel的转变，涉及到很多细节。

这里从`user/alarmtest.c`中运行的流程开始梳理一遍。一来是巩固自己学到的东西，二来是方便后期阅读。

<a href=“#test”>熟悉该流程的点击这里跳过</a>

首先运行shell（它是用户态的）然后执行alarmtest

这时候就进入了`user/alarmtest.c`来运行main()

我们来看看main里面有什么：

```CPP
int
main(int argc, char *argv[])
{
  test0();
  test1();
  test2();
  test3();
  exit(0);
}
```

最先运行test0；那我们看看test0：

```CPP
void
periodic()
{
  count = count + 1;
  printf("alarm!\n");
  sigreturn();
}

// tests whether the kernel calls
// the alarm handler even a single time.
void
test0()
{
  int i;
  printf("test0 start\n");
  count = 0;
  sigalarm(2, periodic);
  for(i = 0; i < 1000*500000; i++){
    if((i % 1000000) == 0)
      write(2, ".", 1);
    if(count > 0)
      break;
  }
  sigalarm(0, 0);
  if(count > 0){
    printf("test0 passed\n");
  } else {
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
  }
}
```

test0调用了`sigalarm(2, periodic)`

sigalarm是题目说的新添加的系统调用，它有两个参数，一个是interval表示时钟中断间隔，第二个是中断后执行的函数。

这里调用它，这个c文件从头文件`user/user.h`里面找定义，它属于系统调用。跟其他的系统调用一样，通过`usys.pl`脚本文件(这里面定义了entry)产生的汇编代码（会加载头文件`syscall.h`里面的定义的系统调用的常数）来进入内核。

in `usys.S`

```x86asm
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 ecall
 ret
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 ecall
 ret
```

这里把常数SYS_sigalarm通过指令li加载到寄存器a7

然后ecall指令就是正式进入内核了。

在进入内核之前的寄存器组、页表、特殊的寄存器PC等 都没有变化

ecall执行后，其实这些也没咋变，PC变成了trampoline的地址(0x3ffffff004)，即将执行trampoline中的代码。

根据lecture中老教授的说法，ecall只做三件事：

* 将mode标志位从user mode改为supervisor mode
* SPEC寄存器保存ecall之前PC的值
* PC寄存器会变成STVEC指向的地址（trampoline的指令）
  
ecall实际上是CPU的指令，我们看不见具体内容。

ecall之后，我们PC位于trampoline的起始位置，也就是uservec函数的起始位置。

in `trampoline.S`:

```x86asm
......
.globl uservec
uservec:    
	#
        # trap.c sets stvec to point here, so
        # traps from user space start here,
        # in supervisor mode, but with a
        # user page table.
        #

        # save user a0 in sscratch so
        # a0 can be used to get at TRAPFRAME.
        csrw sscratch, a0

        # each process has a separate p->trapframe memory area,
        # but it's mapped to the same virtual address
        # (TRAPFRAME) in every process's user page table.
        li a0, TRAPFRAME
        
        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
        sd sp, 48(a0)
        sd gp, 56(a0)
        sd tp, 64(a0)
        sd t0, 72(a0)
......
```

这里第一条命令就是csrw交换a0寄存器和SSCRATCH寄存器，然后a0存的是TRAPFRAME

接下来很多sd指令，就是store data，也就是保存32个用户寄存器。

然后就是保存一些kernel的东西，kernel_sp、kernel_hartid、kernel_trap、kernel_satp(所以这里页表改变了,变成了kernel page table)

in `trampoline.S`:

```x86asm
# save the user a0 in p->trapframe->a0
        csrr t0, sscratch
        sd t0, 112(a0)

        # initialize kernel stack pointer, from p->trapframe->kernel_sp
        ld sp, 8(a0)

        # make tp hold the current hartid, from p->trapframe->kernel_hartid
        ld tp, 32(a0)

        # load the address of usertrap(), from p->trapframe->kernel_trap
        ld t0, 16(a0)


        # fetch the kernel page table address, from p->trapframe->kernel_satp.
        ld t1, 0(a0)

        # wait for any previous memory operations to complete, so that
        # they use the user page table.
        sfence.vma zero, zero

        # install the kernel page table.
        csrw satp, t1

        # flush now-stale user entries from the TLB.
        sfence.vma zero, zero

        # jump to usertrap(), which does not return
        jr t0
```

最后是jr t0，跳转到t0（也就是usertrap的地址）

in `kernel/trap.c`:

```CPP
void
usertrap(void)
{
  int which_dev = 0;

  if((r_sstatus() & SSTATUS_SPP) != 0)
    panic("usertrap: not from user mode");

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);

  struct proc *p = myproc();
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
  
  if(r_scause() == 8){
    // system call

    if(killed(p))
      exit(-1);

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;

    // an interrupt will change sepc, scause, and sstatus,
    // so enable only now that we're done with those registers.
    intr_on();

    syscall();
......
```

执行到syscall() 然后就会通过defs.h头文件找到`kernel/syscall.c`里面的syscall函数来执行，可以简单看见使用了a7寄存器（也就是存了系统调用号这个常数的寄存器）

```CPP
void
syscall(void)
{
  int num;
  struct proc *p = myproc();

  num = p->trapframe->a7;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
  } else {
    printf("%d %s: unknown sys call %d\n",
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}
```

通过上文的表单可以把sysproc.c中的具体的sys_sigalarm()函数调用，然后返回值存在trapframe的a0中。

之后从syscall返回到`kernel/trap.c`继续执行；

```CPP
......
	syscalll();
  } else if((which_dev = devintr()) != 0){
    // ok
  } else {
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    setkilled(p);
  }

  if(killed(p))
    exit(-1);

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2){
    yield();
  }

  usertrapret();
}
```

之后执行到usertrapret()准备回到用户空间了

```CPP
void
usertrapret(void)
{
  struct proc *p = myproc();

  ......

  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64))trampoline_userret)(satp);
}
```

中间缺省一下，中间部分主要是重新设置一下在trapframe中的satp、sp、hartid、trap的值。

最后就是把userret函数的地址算出来，最后两行就调用userret;

这个userret函数，也在`trampoline.S`文件中：

```x86asm
.globl userret
userret:
        # userret(pagetable)
        # called by usertrapret() in trap.c to
        # switch from kernel to user.
        # a0: user page table, for satp.

        # switch to the user page table.
        sfence.vma zero, zero
        csrw satp, a0
        sfence.vma zero, zero

        li a0, TRAPFRAME

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
        ld sp, 48(a0)
        ......
        ld t6, 280(a0)

	# restore user a0
        ld a0, 112(a0)
        
        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
```

先切换了页表，变成了user page table

然后通过a0寄存器（这时还是trapframe的地址，也就是之前copy的寄存器暂时存放的地方）来恢复用户寄存器。

a0（之前的a0存在trapframe的第112个字节处）也恢复

最后sret就回到了用户态。

<a name='test'></a>