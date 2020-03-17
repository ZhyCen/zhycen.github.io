---
title: "Kernel Notes"
date: 2017-07-03
tags: Kernel
categories: Lecture
---
# midtern overview

- EIP EBP ESP指向的位置以及作用要理解
- Process的几个函数需要知道``fork(), exec(), wait(), exit()``，PCB的流程，return code，zombie state等等
- Process 中的Adress Space的结构，以及每个结构的作用是什么，通过code来解释每个结构中发生了什么事
- execl的作用，以及如何将代码插入子进程中
- thread的几个函数 ``pthread_create(), pthread_join(), pthread_exit()``
- 会使用guard command，注意用的是**方括号**不是圆括号
- 了解semaphore的概念，以及binary和multiple的情况下的线程情况
- 分析consumer和producer的例子，知道semaphore和mutex的区别，以及用mutex实现semaphore的不足之处，这也是为什么要用wait condition的原因
- 了解``pthread_cond_wait()``的使用方法，以及mutex锁住的情况，什么时候锁，什么时候解锁
- reader和writer又是另外一情况（和semaphore相比），主要是reader不需要更改文件，只要没有writer，多个reader可以同时？了解此情况
- barrier问题是如何通过引入generation解决问题的？
- 了解线程不安全的原因，大多数是全局变量，例如``errorno, stdout``等等，还有就是大小未知，课件中用ip地址来举例，了解如何让线程安全。
- 了解signal handler的使用方法，清楚的意识到只是借用某一个线程而不是重新创建一个线程
- signal mask的作用以及如何创建mask
- 注意signal是以进程为单位的，如果要应用到特定线程需要block signal. 但是不同的信号呢？需要mask吗？
- 了解``sigwait()``是如何运作的，sigwait解决了上述mask的问题，使得mask可以不影响其他线程
- 了解signal遇到system call的情况，课件中有读和写两个例子
- 理解``pthread_cancel()``的作用，和``pthread_join(), pthread_exit()``之间的关系，以及需要注意cancel的时间和清理工作（如何？）
- cancellation的几个规则，以及cancellation常规点以及创建``pthread_testcancel()``，具体到clean handler里面的结构，其最终还是``pthread_exit()``，注意``pthread_cleanup_push()``和``pthread_cleanup_pop()``成对出现，pop这里的index的含义是什么？push和pop之间必须要lock。
- context在address space中是如何运作的，需要初步读懂汇编语言（用于cpu的执行），结合汇编语言知道每个stack frame的结构，从下至上分别是：**arguments, eip, ebp, saved registers, local variables**
- 了解thread ``switch()``的运作方式，和cpu中的esp有关，注意switch function中的return是**针对改变之后的那个线程**。thread的switch是系统层面的，一个线程休眠，一个线程唤醒。CPU不知道线程。
- signal和interrupt的区别，signal是kernel层向user space层的中断，interrupt是从硬件层到kernel层的中断。了解trap以及interrupt中的HAL的作用，如何从系统的层面实现interrupt的。需要注意的是硬件和软件的interrupt在kernel以及HAL层的应对措施是完全相似的。
- 了解interrupt在user space和kernel时候 interrupt handler（这个handler在哪？）借用kernel stack的情形。对应的context保存在stack的下方。注意区分context和kernel stack。interrupt可以套interrupt，但是必须要所有interrupt执行完之后才可以执行user/kernel thread。
- 了解两种interrupt mask的形式：bit mask 和 hierarchical interrupt level，其中后者有优先级别，低于IPL的被锁住，高于的则不锁住。
- 了解计算机结构，总线以及各个硬件的控制器的作用。总线上设备的分类：PIO/DMA，大致了解一下两种设备的区别，以及内部寄存器的结构。
- 了解device driver和device controller的关系，driver和kernel的关系。driver提供了device和OS之间的interface，device 使之independent。
- 了解first fit和best fit内存分配的机制，**注意这里的内存指的的dynamic的内存**，什么情况下哪种分配比较好，一般用first fit比较多。两种fragmentaton problem：internal（buddy system）和external（best-fit）的概念和区别。
- 了解内存非配中可使用的内存列表的表示，用``doubly linkedlist``表示，如果空闲则有前后link，如果被使用，则没有flink或者blink；注意每个可用空间的前后都有一个block表明size。（为什么？便于前后追踪，因为不知道每一个你block的具体size），熟悉list空间大小的计算，注意size一栏的值，以及prev和next值得改动。（很有可能计算题）
-  知道如何用buddy system表示以及计算，知道如何用slab allocation，weenix中有描述。
-  了解linker和loader的作用，linker preforms **relocation** and **symbol resolution**, loader **loads programs into memory**. loader is evoked by **exec()**
-  了解.o文件描述的文件位置和参数等内容，以及reallocation的描述也在obj文件中。(这块内容不是很好懂，需要花时间理解透彻)
-  系统启动需要一个简易的OS把kernel的代码加载到内存中去。了解bios系统启动的步骤，很可能考简答题。开机-cpu加载64kb-进入POST-初始化硬件-定位内存-寻找boot设备并复制到内存并运行boot program
