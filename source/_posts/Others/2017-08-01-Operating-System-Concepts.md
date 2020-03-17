---
title: "OS Concepts and Notes"
date: 2017-08-01
tags: Kernel
categories: Lecture
---

# Ch 3 - Basic Concepts

## shared libraries

### static library

creating a library
```powershell
>> ar crt libpriv1.a sub1.o sub2.o sub3.o
```

using a library
```powershell
>> gcc -o prog prog.c -L. -lpriv1 -L/lib -lc
```

### shared library
save space and use one copy of library in memory.

```powershell
% gcc -fPIC -c myputs.c
% ld -shared -o libmyputs.so myputs.o
```
others are the same


# Ch 4 - Operating-System Design

## devices

### Terminal and shell

#### issues
- terminals are slow and characters generation are too fast
- characters arrive from the keyboard even though there isn’t a waiting read request from an application

#### one approach
two threads, one for input and one for output.

#### deal with backspace
using another input queue
- one for partial-line
- one for completed line

#### modularization
**line-discipline module** in some systems, provides the common character-handling code, and make the device independent with the kernel.

#### pseudo terminal
window master -> pseudoterminal master -> pseudoterminal slave -> line discipline -> application

### Network communication
...

## virtual machines, microkernels

### virtual machine

#### VMM (virtual machine monitor)
- provide hardware abstraction for guest OS

#### virtualization type
- **pure virtualization**: guest is not modified
- **para-virtualization**guest is modified

#### VMM mode
- virtual machine runs in user mode of real machine
- VMM runs in privileged mode of real machine
- guest OS runs in the (virtual) privileged mode
- guest app runs in the (virtual) user mode

processor in VM is **REAL** processor.

#### VMM operation
trap:
- hardware make upcall to VMM
- VMM find out which VM
- VMM deliver trap through VM to OS

#### sensitive and privileged mode
- All **sensitive** instructions must be **privileged**, or cannot build VM for the processor.
-  sensitive instructions is a **subset** of its privileged instructions
-  execute a **sensitive instruction** in virtual user or virtual privileged mode, will **trap into VMM**

#### problem with Intel x86
not all **sensitive** instructions are **privileged** instructions, which result that Intel x86 is unable to build VM


#### full virtualization
- binary rewriting (VMware)
	- replace the sensitive instruction with **hypercalls**, done by VMware.
	- guest OS is unmodified
- hardware virtualization, fix the hardware (Intel)
	- introduce "ring -1" for root mode
	- `VM-exit` to root mode
	- no use of root mode
- I/O virtualization (VMware)
	- split the driver in VMM
	- use Host/Guest model

#### para-virtualization (Xen)
- sensitive instructions replaced with  **strong text** calls
- guest machine has **no device drivers**

#### VM meet virtual memory
solution:
- Para-virtualization to the Rescue
- Hardware to the Rescue

### microkernels
> basic understand of the microkernel


# Ch 5 - Processor Management

## threads implementations

### one level model
All the kernels are created in the kernel, if need to turn into user thread, one need to ``return from interrupt``
- **pros**: easy to implement, win and linux use this model.
- **cons**: system call cost is expensive, so make `pthread_mutex` **on the user level** (why?).

> understand the NPTL, how to make `futex` on the user level

### two-level model
N * 1 (single kernel thread per process)
the user thread goes into kernel when making `system call`.
- **pros**: fast
- **cons**: when one goes into system call, other threads are blocked.

M * N (multiple kernel threads per process)
similar with N to 1 model, which is fast.

### problem with two-level models
- I/O blocking problem
- **Priority Inversion problem**: the priority in userspace and kernel are different.
	- solution: Scheduler Activations Model (*understand how it work*)

### thread implementation - simple processor
- CurrentThread -> ...
- RunQueue -> ...
- Mutex Queue, I/O Queue -> ...

each ... is a thread data structure, and this is doubly link list.
> understand the function of `thread_switch` for simple processor
```cpp
void thread_switch( ) {
	thread_t NextThread, OldCurrent;
	NextThread = dequeue(RunQueue);
	OldCurrent = CurrentThread;
	CurrentThread = NextThread;
	swapcontext(&OldCurrent->context, &NextThread->context);
}
```

### thread implementation -  multiple processor
the difficulty is locking, when two thinks that they get the mutex.

solution:
- compare and swap and spin lock
- blocking lock
- futex

### solution: pin lock, blocking lock, futex

lock other CPUs when implementing on one CPU
```cpp
void spin_lock(int *mutex) {
	while(CAS(mutex, 0, 1));
}	// easy but wasteful.
```

 blocking lock

/? understand why some solutions are not available.

 futex

/?understand how to implement the futex.


## interrupts
non-preemption kernels: return to the same thread when interrupted.

### interrupt masking

IPL: set the IPL to n, then block the interrupts below **(<=)** n.

One cannot use mutex inside a signal handler (why?)
```cpp
void AccessXThread() {
	int oldIPL;
	oldIPL = setIPL(IHLevel);
	X = X+1;
	setIPL(oldIPL);
}
```
need to change in the `thread_switch` function, understand how it works.
```cpp
void thread_switch() {
	thread_t *OldThread;
	int oldIPL;
	oldIPL = setIPL(HIGH_IPL);
	// protect access to RunQueue by
	// masking all interrupts
	while(queue_empty(RunQueue)) {
		// repeatedly allow interrupts, then check
		// RunQueue
		setIPL(0);
		// 0 means no interrupts are masked
		setIPL(HIGH_IPL);
	}
	// We found a runnable thread
	OldThread = CurrentThread;
	CurrentThread = dequeue(RunQueue);
	swapcontext(OldThread->context, CurrentThread->context);
	setIPL(oldIPL);
}
```
### Preemptive Kernels & Multiple CPUs
the spin lock only lock other CPUs, but have nothing to do with interrupt in the same CPU. e.g.
```cpp
// in CPU 1
void AccessXThread() {
	SpinLock(&L);
	X = X+1;
	SpinUnlock(&L);
}

//in CPU2
void AccessXInterrupt() {
	...
	SpinLock(&L);
	X = X+1;
	SpinUnlock(&L);
	...
}
```
this will work if the interrupt are done in CPU2, however, if it is operated in the same CPU, problems may occurred.

solution:
```cpp
int x = 0;
SpinLock_t L = UNLOCKED;

void AccessXThread() {
	DisablePreemption();
	MaskInterrupts();
	SpinLock(&L);
	X = X+1;
	SpinUnlock(&L);
	UnMaskInterrupts();
	EnablePreemption();
}

// interrupt code is the same
```

### Deferred Work
Interrupt handlers run with interrupts masked up to its interrupt priority level.

sometimes, need to defer most of the work after the interrupt handler returns (e.g. the interrupt handler will do a lot of things), like return from function call.

### Thread Preemption
- user level preemption, go to different user thread in the user space.
- kernel level preemption, go to different user thread in the kernel.

### Directed Processing
- Signals, e.g. ctrl + c in UNIX is a signal, generated by hardware and invoke the signal handler. Done in **user mode**
- APC (Asynchronous Procedure Calls), also may be done in **kernel** mode than signal.

then when invoking the signal handler,  set up the user stack so that the handler is called as a subroutine and so that when it returns, normal execution of the thread may continue.

## scheduling

### schedule goals
- maximize CPU **utilization**
- maximize **throughput**
	- throughout = job finished / time
- minimize wait time
	- wait time = wait time in queue + execution time in CPU.
	- **average waiting time (AWT)** = wait time / total time.
- minimize response time
- **fairness**

### basic algorithm

- FIFO: fair
- SJF: unfair
- SRTN:
	- preemptive version of SJF
	- unfair, may cause starvation problem
- Round Robin (RR) + FIFO, fair
	- proper q, not too large or small

> know how to calculate the AWT for RR + FIFO!

### Max-min Fairness
- sort jobs based on request xi
- initially, assign sum_xi/N to each job
- satisfy x1, redistribute remaining capacity evenly
- recursion

### priority
Multi-level
- apply RR with multiple level

Multi-level w/ Feedback*
- apply RR with multiple level
- Priority is dynamic
	- if it uses a full time slice, decrease priority
	- if it blocks before using up a full time slice, increase priority
	- To avoid starvation, use **aging**
- not fair

### stride scheduling*
principle
- every thread is assigned a priority, **pass value**
- every thread is assigned a **stride value**
- every time slice, pick the thread with the highest priority, smallest first.

every iteration
-  smallest pass value first. (high priority)
-  increment the thread’s pass value by its stride value
-  iterate
> understand how it works
> Stride is proportion to 1 / number of tickets
> use 1 / p  * smallest common multiplier


### Real Time algorithm

Rate-monotonic scheduling
- $\sum_{i=0}^{n-1}(T_i/P_i)\leq n(2^{1/n}-1)$
- when the equation satisfied, system works
- or need to **simulate** oneself to see if it works

Earliest Deadline First (EDF)
- greedy algorithm

### implementing issue
- priority inversion problem
- multiple processor
	- cache affinity: thread remember the CPU
	- may cause one CPU empty
	- solution: load balancing



# Ch 6 - File Systems

## the basics of file systems

### structure of UNIX’s S5FS

- regarded as an array of blocks of 1KB each
- `Superblock` contains the head of the `free list`, which is a link list.
- `I-list` is an array of index nodes inodes, each  `inodes` represent as a file.
- in the inode, there is a disk map that map the inode with the data region.s

#### iNode
Device -> Inode Number -> File type -> Mode -> Link Count  -> Owner/group ->  Size -> Disk map (where data actually stored)

#### Disk Map (each file)
13 disk pointers

- pointer 0 - 9 -> 1KB block each
- pointer 10 -> 256 max entries = 256KB
- pointer 11 -> 64MB
- pointer 12 -> 16GB

#### Data block
contains data value and metadata, which can be used to reach these files (pointers in DiskMap are metadata)
> understand how does disk map do the mapping

#### Freelist
superlist: freelist -> freelist -> freelist ...

freelist: (100x) super block -> free disk block

The superblock contains the addresses of up to 100 free disk blocks

### Disk Architecture

####  basic concept
disk address = (head/surface#, cylinder/track#, sector#)

####  disk access time and problem
**access time = seek time + rotational latency + data transfer time**

the data transfer time is fixed, only seek time and rotational time can be improved.

problem: the rotational time and access time is too slow, which slow down the disk access time.

## performance improvements

###  some approaches: FFS

#### enlarge big block size
- **pro**: speed up
- **con**: increase **internal fragmentation**

#### use of fragments
The number of fragments per block (1, 2, 4, or 8) is fixed.

- **pro**: fast, less internal fragmentation
- **con**: complicated

#### minimize seek time:
keep related things close to another, and unrelated things separate

use cylinder group rather than i-list and data region.

because seeking the closed **cylinder group** take less time

- **pro**:  better performance
- **con**: complicated

#### minimize rotation latency
the worst case: rotate 360 degree every time.

solution: block interleaving, only rotate and wait for a sector

**pro**: huge improvement

#### buffer cache
one can buffer cache files in large memory

Dirty/modified blocks: write operation on the buffer cache will label the block as "dirty/modified", and clear the dirty  bit after updating the disk.
- read is ok
- write **does matter** because eventually files need to write into disk

solution:
- write-through solution: slow
- write-back solution: write to the disk can wait
	- **pros**: high speed
	- **cons**: longer the wait, higher the risk (if lose power)

### log-structured file system
solution: write in a **long log**, but still need to consider the risk.

principle:
- never delete/update
- append only

  - **pros**: minimize the seek time and rotational latency; can recover from crashes.
  - **cons**: this will **waste a lot of disk space**

> understand how does it work

## crash resiliency

### approaches

#### consistency-preserving
write cache contents to disk in same **order** in which cache was updated

order: use **Topological Sort** to figure it out the order

exception: circular dependency

#### updates as transaction
has **ACID** property
- atomic
- consistent
- isolated
- durable

solution
- journaling
- shadow paging

### journaling

#### two approaches
- record previous contents: **undo journaling**
- record new contents: **redo journaling**

#### journal features
- journal is a separate part of the disk
- journal is **append-only**, append content followed by commit.
- when updating, write to journal first, write to disk after commit to journal

recovery:
- find all committed transactions
- redo these transactions

journal options:
- journal everything, **costly**
- journal metadata

### shadow paging
copy-on-write towards shadow paging tree.

update the root of the tree is a commitment.

> understand how to perform when modifying leave in the tree

## directories and naming

### Hash table approach
cheat direct content as array of hash buckets

problem: collisions in one bucket

#### extensible hashing
> understand how to rehash the extensible hash table.

### B-trees
#### Properties
- every node (except root & leaves) has ≥ ceil(m/2) children, ≤ m children
- the root has at least 2 children (unless it is also a leaf)
- all leaves appear at the same level and carry no keys
- a non-leaf node with k children contains k-1 keys

#### B+ trees
- internal nodes contain no data, just keys
- leaf nodes are linked

Note that the updates are on the top, not the button.

#### implementation
> understand how to split and combine the b+ tree when add/delete the file.

### name-space management
#### mounting
for linux, create an entry in the `inode` to point to the **file system** (it is a system, not a directory or file). e.g.

```
>> mount /dev/disk2 /usr
```

## RAID, flash memory, case studies

### RAID

#### Logical Volume Management
- spanning, into one larger system
- mirroring, increase the consistancy

#### striping and parallel
**pros**: increase the speed

**cons**: higher variance, worse reliability

stripe width: parallel number
stripe unit: the size for each disk

#### striping strategy
performance is **better** with **larger striping unit**

> know how to calculate the fail probability

if fail prob is f for one, the for all N parallel, the prob would be 1-(1-f)^N
solution: **RAID**

### RAID
#### Level1
pure mirroring

#### Level2
Error Correcting Code (ECC)

data bits + check bits

#### Level3
data bits + Parity bits (which one disk dead)

#### Level4
data block + Parity block

#### Level5
problem: write performance bottleneck at the parity disk

solution: **Parity blocks** are **spread** among all the disks in a systematic way

### Flash Memory

**pros**: Random access, Low power, Vibration-resistant

**cons**: Limited lifetime, Write is expensive

#### approach
- NOR: byte addressable
- NAND: page addressable (good)

#### writing
- easy to turn 1 to 0
- erase entire block to recover to 1
- log-structured file system is used

# Ch 7 - Memory Management

## virtual memory
remember where does `eip`, `ebp`, `esp` point to.

### Basics

#### virtual address
virtual address (32 bits) is translated into physical address via MMU

approach:
- Memory Fence (and overlays)
- Base and Bounds Registers

#### Segments
- One pair of base and bounds registers per segment
- text, data, heap and stack can be in different place.

#### Segmentation Fault*
- virtual address not within range of any base-bounds registers
- **or access is incompatible**

#### Memory Mapped File
- map entire file into segment using `mmp()` system call
- need additional register to do this, others are the same

#### Copy-On-Write
- a process gets a **private** copy of the segment after a thread in the process performs a **write** for the **first time**
> understand how `Copy-On-Write` works

#### Swapping
- condition: no new room for segments
- solution: swap the segments into disk, recorded by **validity** bit
- v=0, not available, v=1 available (in the physical memory)
- can start the program with **all** v=0
- every user memory segment **needs a corresponding disk image**.
> understand the data structure of `as_region`

### Paging

#### segmentation VS paging
- s: divide the address space into variable-size segments, **external** fragmentation
- p: divide the address space into fixed-size pages. **internal** fragmentation

#### page
size: 4 KB, 12 bits.
**page-aligned**: if the least significant 12 bits of an address are all zero

virtual memory (address space) and physical memory have pages, need to map virtual page
numbers to physical page numbers.

solution: MMU TLB

#### page frame VS physical page
/?

### Page tables
#### Basic (Two-level) Page Tables

where to store
- page table: in memory
- physical address: (x86) CR3 register

page table
- every process (including OS) has its own page table
- MMU do the translation

cons:
- access time is slow, need two access times
- too large, 2^20 * 4 = 4 MB space in memory

#### Forward-Mapped Page Tables
use multiple level to allocate a physical memory

- in this way, the minimum would be 1MB, because only one segment is used.
- the access time will cost more.
- cut down the overhead table from 3MB into 12KB
- one in page dir table, two in page tables.

> understand how to calculate the minimum size

#### Linear Page Tables
- space 00,  01 point to a page table that point to virtual table
- space 10 point to  a page table that point to physical table

#### Hashes Page Tables

hashed page table

clustered page table

use the last three bits in the page# as index in each page table entry.

inverted page tabee
- combined the PID and the page number, compare the each table in page table.
- compare both PID and Tag

### Translation Lookaside Buffers
hardware cache to remember the page table entries **only**.

TLB --cache--> memory (page table entry) --cache--> disk.

#### changes on PTE
- when PTE changes, must flush the corresponding TLB entry
- When switching to a different process, must flush the entire TLB

#### some approaches
- direct mapping cache
- two-way set-associative cache
- fully associative cache

in a word, compare the key in VA with the tag in TLB. if hit, the get the value, if not trap into the kernel and fetch the PTE in memory. store and swap in the TLB.

#### multiprocessors situation
Before such a mapping is modified, Processor 1 must **shoot-down** (invalidate) the TLB of Processor 2

## OS issues

### General Concerns

you should understand this graph thoroughly.

#### Demand paging
demand paging (lazy evaluation): bring in pages on demand

understand the process when the proc start
- all the V = 0
- trap into the system and fetch from disk on demand

#### Page fault
- Trap occurs
- Find free physical page, by buddy system
- swap page out **if no free physical page**
- Fetch page
- Return from trap

problems: too much swap out will slow down the system

solution:
- prefetching: bring more pages when fetching one page
- **pageout daemon**

#### pageout daemon

policy
- FIFO (First-In-First-Out), **bad** solution.
- LFU (Least-Frequently-Used)
- LRU (Least-Recently-Used), **reference** bit is used.

clock algorithm
- Two-handed: use two pageout daemons
	- front hand: scan all the page frame and set all the reference bit to 0
	- second hand: wake up sometimes later, swap out all the pages with ref == 0
- One-handed: only one pageout daemon
	- if ref == 0, swap out
	- if ref != 0, set ref = 0

> understand the relationship between page frame and physical page.

#### thrashing

happens when the need of page > available page

solution:
- working set principle
- using **local allocation**

global VS local allocation
- global: easy for implementation but bad performance.
- local: every process will preserve several pages their own, will not be swapped out by page daemons.

### Representative Systems

#### VM layout
4GB in total (2^32 Bytes), 3GB for user, 1GB for kernel, **FOR EACH PROCESS**!!!

> have basic understanding when the physical memory is exactly 1GB and when larger than 1GB.

#### mem_map page list
- DMA zone: locations < 2^24, for kernel only
- Normal zone: locations >= 2^24 and < 2^30 - 2^27, for kernel + user
- HighMem zone: locations >= 2 30 - 2 27, for user only

page Lists: free, active, inactive
> understand the process of page fault and pageout daemon

### Copy on Write and Fork

#### fork problem
`fork()` makes a copy of the parent’s address space for the child: **inefficient**.

`vfork()` give the address space of parent to the child, `exec()` hands back the address space to the parent. efficient, but **risk**.

`copy and write fork()`, with lazy evaluation, when modified, make a copy. **good solution**

#### copy on write fork problem

problem happens if **fork after copy on write**.

need to reset the R/W to R/O

#### shadow object
keep track of pages that were originally **copy-on-write** but have been **modified**

if the file is shared, then there is no shadow object.

pages in the shadow object have to be the resident in the bottom object.

> understand the process of change in shadow object when to fork a process

### Backing Store Issues

#### written back situation
Read-only mapping of a file: **NO**

Read-write shared mapping of a file: **YES**

Read-write private mapping of a file: **YES**

Anonymous memory: **YES**

#### swap space
radical-**conservative** approach: **eager evaluation**

radical-**liberal** approach: **lazy evaluation**
