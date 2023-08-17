# Lab Copy on Write
先切到cow分支
```Linux
$ git fetch
$ git checkout cow
$ make clean
```
- [Lab Copy on Write](#lab-copy-on-write)

先去看看lecture 8

这里放一张scause的图表：

![scause](/img/scause.png)

表示trap机制中进入supervisor mode的原因。

<h2>The problem</h2>


The fork() system call in xv6 copies all of the parent process's
user-space memory into the child. If the parent is large, copying can
take a long time. Worse, the work is often largely wasted:
fork() is commonly followed by exec() in the child, which 
discards the copied memory, usually without using most of it.
On the other hand, if both parent and child use a copied page, and one or both
writes it, the copy is truly needed.

<h2>The solution</h2>

Your goal in implementing copy-on-write (COW) fork() is to defer allocating and
copying physical memory pages until the copies are actually
needed, if ever.

<p>
COW fork() creates just a pagetable for the child, with PTEs for user
memory pointing to the parent's physical pages. COW fork() marks all
the user PTEs in both parent and child as read-only. When either
process tries to write one of these COW pages, the CPU will force a
page fault. The kernel page-fault handler detects this case, allocates
a page of physical memory for the faulting process, copies the
original page into the new page, and modifies the relevant PTE in the
faulting process to refer to the new page, this time with the PTE
marked writeable. When the page fault handler returns, the user
process will be able to write its copy of the page.

</p>

<p>
COW fork() makes freeing of the physical pages that implement user
memory a little trickier. A given physical page may be referred to by
multiple processes' page tables, and should be freed only when the
last reference disappears.  In a simple kernel like xv6 this
bookkeeping is reasonably straightforward, but in production kernels
this can be difficult to get right; see, for example,
<a href="https://lwn.net/Articles/849638/">Patching until the COWs
come home</a>.

</p>

resolution:

