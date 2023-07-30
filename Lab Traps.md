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

20230727：这个lab开始需要非常仔细阅读xv6文档了，有点难啃。

20230728：妈的今天世界末日了，台风来了，休息一天。怕断电断网。

关于寄存器，参考 [这里](https://pdos.csail.mit.edu/6.828/2020/readings/riscv-calling.pdf) 的`Table 18.2: RISC-V calling convention register usage.`

```TXT
Q: Which registers contain arguments to functions?  For example, which register holds 13 in main's call to printf?
A: a0-a7; a2;

Q: Where is the call to function f in the assembly code for main? Where is the call to g? (Hint: the compiler may inline functions.)
A: 
```

# Backtrace

# Alarm