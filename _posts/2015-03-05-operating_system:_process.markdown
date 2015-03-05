---
layout: default
title: {{ title }}
description:
tags: [process, Computer Science, Operating System, note]
categories: [ Computer Science, Operating System]
image:
  feature:
  credit:
  creditlink:
---
进程是一个程序运行中的实例，对进程的管理，如CPU分配，内存空间分配等等是操作系
统的重要内容。主要是小学期的内容，现在来总结一下。


# 计算机分时系统
现在的计算机系统大部分是多任务系统(multiprogramming),可以参考
[MULTICS](http://en.wikipedia.org/wiki/Multics):

* 并发(Concurrency, 或者伪并行pseudo parallelism)是通过对单一CPU上执行
  的进程进行调配而实现的。(一个人吃三个馒头)
* 并行(Parallelism)是通过物理上的多CPU来实现的。(三个人吃三个馒头)

多任务系统需要上下文切换(context switching)来调整进程的执行，然而这种
方式会带来开销(overhead)。
上下文切换：中止并保存当前进程，然后启动/重启另一个进程
操作系统通过调用器(dispatcher)与排程器(scheduler)来进行进程管理：

* 分配/保护资源
* 插入进程
* 支持进程间通信

# 进程
每个进程都包括：

- 程序代码
- 数据，包括堆(stack)跟栈(heap)的数据
- 进程控制块(process control block, PCB)

PCB保存所有有关于进程管理的信息，对于多任务系统中的上下文切换而言，PCB
是必不可少的。

## 进程的状态(state)
进程在它的生命周期中，会在不同的状态之间切换。
一个常见的进程状态转换图如下：
![process.jpg](/image/process.jpg)
+ `running` 状态的进程占用CPU
+ `block` 状态的进程无法继续执行，比如正在等待I/O
+ `ready` 状态的进程等待CPU变得可用
+ `new` 状态的进程刚刚被创建，等待被处理
+ `terminated` 状态的进程已经结束，不过数据仍然有可能被暂时留在内存中。
+ `suspended` 状态的进程被交换(swap)出去了


