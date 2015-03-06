---
layout: post
title: "操作系统笔记一：进程"
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


# 计算机多任务系统
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
是必不可少的。在后面我们会讨论一下PCB的内容。

## 进程的状态(state)
进程在它的生命周期中，会在不同的状态之间切换。
一个常见的进程状态转换图如下：

![process.jpg]({{ site.url }}images/process.jpg)

* 状态为`running` 的进程占用CPU
* 状态为`block` 的进程无法继续执行，比如正在等待I/O
* 状态为`ready` 的进程等待CPU变得可用
* 状态为`new` 的进程刚刚被创建，等待被处理
* 状态为`terminated` 的进程已经结束，不过数据仍然有可能被暂时留在内存中
* 状态为`suspended` 的进程被交换(swap)出去了

状态转换包含如下：

1. `new` -> `ready`: 接纳新创建的进程
2. `running` -> `blocked`: 进程被阻塞，等待IO或者系统调用
3. `ready` -> `running`: 进程被排程器选中执行
4. `block` -> `ready`: 事件发生了，比如IO操作结束，进程回到等待状态等待被调用
5. `running` -> `ready`: 进程被抢占
6. `running` -> `exit`: 进程结束

进程的生命周期：

![process2.jpg]({{ site.url }}images/process2.jpg)

中断(interrupt)，陷阱(traps),系统调用(system call)都是在如上的状态转换的基础上实现的。

## 进程的创建与终止

操作系统负责创建进程，如下的事件发生时可以创建进程：

+ 系统初始化的时候创建后台与前台进程
+ 用户请求
+ 批处理任务(注：这是windows下的说法，linux下的是shell脚本?)
+ 其他进程创建

如下的系统调用命令可以用来创建子进程：

+ *NIX系统下`fork()`可以创建一个父进程的完整拷贝，然后使用`exec`来执行
+ windows系统下使用`NTCreateProcess()`API
+ Linux下使用`clone()`

同样的，操作系统也负责终止进程。如下的事件发生时终止进程：

+ 进程正常退出
+ 错误：`ERROR`,比如说空间不足
+ 错误：`FATAL`,程序bug
+ 被父进程或者其他被授权的进程杀死（`KILL`）

在进程终止时，需要使用系统调用来通知操作系统进程终止，然后释放被分配的资源，冲刷掉
输出，以及执行可能的系统操作指令。

如下的系统调用命令可以终止进程：

+ *NIX, Linux:`exit()`,`kill()`
+ Windows: `TerminateProcess()`

## 进程的实现
操作系统通过*表*来维护资源的状态：

+ 内存表：内存分配，内存保护以及虚拟内存等等
+ I/O表：可用性，状态，信息转换
+ 文件表：位置，状态
+ 进程表：进程控制块

这些表可以被交叉引用。

## PCB与进程表
PCB包含一些进程管理时必要的属性。通常而言，包含如下几个类别：

+ 进程区分：PID，UID，父进程的PID等
+ 进程状态：用户注册，程序计数，堆栈指针，程序状态,内存管理，文件等等
+ 进程控制信息：进程状态，排程信息等等

PCB必须被保护，否则可能带来一系列严重的问题。

进程表负责管理所有进程的PCB,当进程被中断/切换的时候，操作系统会更新进程表
中的PCB信息。而在进程创建之前，进程表中会为之分配一个入口。


## 上下文切换
上下文切换发生的时候，系统会将原来进程的状态与内容保存起来，然后读入新
的进程所要执行的内容，这个读写操作会产生开销。
如下的事件会触发上下文切换：

+ 进程内中断(interrupt):计时器，I/O，page fault等
+ 由于错误或者异常而导致的陷阱(traps)
+ 系统调用，比如I/O请求

# 进程排程算法
