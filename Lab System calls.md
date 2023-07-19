# Lab System calls
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



# Sysinfo