---
layout: post
title: "机器与语言"
modified: 
description: "Notes for Machines and their languagesp"
tags: []
categories: [ cs, language]
image:
  feature: 49196792_p0.jpg
  credit: ミクの日だったので | WS [pixiv] 
  creditlink: http://www.pixiv.net/member_illust.php?mode=medium&illust_id=49196792
---

Machines and Languages感觉难度比较大，这里记一下笔记来让自己记忆一下，以后复习的时候有一个可以参考的东西。

# Basic
在深入其他内容之前，我们需要掌握一下语言的概念。

关系：对于集合$A$与集合$B$, *从A到B的关系(A relation from A to B)*是$A$与$B$的一个笛卡尔积$A \times B$的子集。一个在集合$A$上的关系是从$A$到$A$的关系，或者说是$A \times A$的一个子集。

我们可以将关系表述为：
定义$R$表示一个在某集合上的关系，我们可以将"A与B相关"写作：

> $aRb$

或者

> $(a, b) \in R$

一个在集合$A$上的关系$R$如果满足如下条件，我们称之为*等价关系(equivalence relation)*：


1. $R$具有*自反性(reflexive)*：对于所有的$x \in A, xRx$.
2. $R$具有*对称性(symmetric)*: 对于所有的$x, y \in A$, 如果$xRy$，那么$yRx$.
3. $R$具有*传递性(transtive)*: 对于所有的$x, y, z \in A$, 如果$xRy, yRz$，那么$xRz$.

对于一个在集合$A$上的等价关系$R$，以及一个元素$x \in A$，包含$x$的*等价类(equivalence class)*定义为：

> $[x]_R = \lbrace y \in A \| yRx \rbrace $

对于等价类与等价关系，我们有如下定理：

> 如果$R$是一个A上的等价关系，关于R的等价类将A分割成若干子集。A内的两个元素当且仅当他们属于同一等价类时，他们有等价关系。

*字母表(Alphabet)*是若干符号的一个有限集，比如`{a, b}`,`{0, 1}`.我们使用希腊字母$\Sigma$来表示一个字母表。一个在字母表$\Sigma$之上的*字符串(String)*定义为$\Sigma$内符号的一个有限序列。对于一个字符串$x$,$\|x\|$表示字符串的长度。另外，我们有空字符串$\Lambda$是在任意的字母表$\Sigma$之上，且$\|\Lambda\| = 0$

$n_a(X)$表示$a$在字符串$X$中的出现次数。

我们用$\Sigma^*$来表示所有在字母表$\Sigma$之上的字符串。而一个*语言(language)*则是$\Sigma^*$的一个子集。

我们用$xy$来表示字符串$x$与$y$的*连接(concatenation)*，这也是对字符串最基本的操作。它有着如下的特性：
你
- 对于任意的$x$,$x \Lambda = \Lambda x = x$
- $\|xy\| = \|x\| + \|y\|$

对于在$\Sigma$之上定义的语言$L_1, L_2$, $L_1 \cup L_2, L_1 \cap L_2, L_1 - L_2$都是在$\Sigma$之上定义的语言。

如果$L$是在$\Sigma$上定义的语言，那么$\L^*$表示将$L$中任意数目的任意字符串连接起来的语言。我们把这种操作称为*Kleene星号(Kleene Star)*操作。

> $L^* = \cup  \lbrace L^k \| k \in \mathbb{N} \rbrace$

# Finite Automata

## 定义与性质
在讨论有限状态自动机前，我们先来讨论一下*语言接收机(language accepter)*: 任何输出被限制为"yes"或者"no"的计算机可以被认为是一个语言接收机。
计算机所接受的语言是将语言输入该计算机后输出且只输出"yes"的语言，而除此之外的语言将输出"no"。另外，在没有任何输入时，我们可以认为其接受%\Lambda%作为输入，而且此时有输出。


在这里，为了讨论的方便，我们约定：

- 输出被限制为由一系列单个符号所组成的字符串，我们可以将其看作一个由单个符号所组成的序列
- 计算机对任何的当前的字符串输入都有一个相对应的输出

*有限状态自动机(finite automaton/finite state machine， FA)*是一种具有如下性质的简单机器：

- 输出被限制为"yes"与"no"
- 它只具有非常简单原始的内存容量

有限状态自动机一直处于一个特定的*状态(state)*。对于每一步输入，它将”移动“到下一个状态（也包括当前的状态）。它的”移动“只决定于当前的状态以及输入的内容。所有的状态被分为两类：

- 接受(accepting)，返回"yes"
- 不接受(nonaccepting)，返回"no"

一个有限状态自动机拥有一个初始状态，当且仅当输入为空字符串$\Lambda$时，自动机处于这个初始状态。

有限状态自动机可以被如下的参数所描述：

- 有限的*状态集*: $Q$
- 有限的*输入字母表*: $\Sigma$
- *初始状态*: $q_0 \in Q$
- *接受状态集* $A \subseteq Q$
- *状态转换函数* $\delta: Q \times \Sigma \rightarrow Q$

我们将有限状态自动机用如下的五元组所表示：

$M: (Q, \Sigma, q_0, A, \delta )$

对于处于状态$q$的FA与输入字符$\sigma$，$\delta(q, \sigma)$用于表示转换后的状态。

$\delta^*(q, x)$用于表示FA在接受了输入字符串$x$的状态。

对于函数$\delta^*(q, x)$,我们有：

- $\forall q \in Q, \delta^*(q, \Lambda) = q$

- $\forall q \in Q, \forall y \in \Sigma^\*, \forall \sigma \in \Sigma^\*, \delta^\*(q, y\sigma) = \delta(delta^\*(q,y),\sigma)$

如上是一个使用数学归纳法的递归定义。

如果我们有一个定义为$M = (Q, \Sigma, q_0, A, \delta)$的FA, 令$x \in \Sigma^\*$，定义$x$*被$M$接受*为：

> $\delta^*(q_0, x) \in A$

同样的，定义*不被$M$接受*为：

> $\delta^*(q_0, x)\not \in A$

定义*被$M$接受的语言*为：

> $L(M)=\lbrace x \in \Sigma^* \| x\ is\  accepted\  by\ M\rbrace$

## 语言的交，并，差集以及FA

创建接受两个语言的交并差集的FA的一个基本思路是创造一个同时能处理两个语言的FA。

假设我们有两个FA:$M_1 = (Q_1, \Sigma_1, q_1, A_1, \delta_1)$, $M_2 = (Q_2, \Sigma_2, q_2, A_2, \delta_2)$，分别接受语言$L_1$，$L_2$，定义$M = (Q, \Sigma, q_0, A, \delta)$为：

- $Q = Q_1 \times Q_2$
- $q_0 = (q_1, q_2)$
- $\delta((p,q), \sigma) = (\sigma_1(p,\sigma), \sigma_2(q, \sigma))$

那么，我们有：

- $A = \lbrace(p, q) \| p \in A_1 or\ q \in A_2 \rbrace, M\ accepts\ L_1 \cup L_2$
- $A = \lbrace(p, q) \| p \in A_1 and\ q \in A_2 \rbrace, M\ accepts\ L_1 \cap L_2$
- $A = \lbrace(p, q) \| p \in A_1 and\ q \not \in A_2 \rbrace, M\ accepts\ L_1 - L_2$

构建一个如上的$M$的过程为：

1. 创建$Q_1 \times Q_2$，列出所有的笛卡尔积
2. 根据原来两个FA的转换函数，画出所有转换函数
3. 将$(q_1, q_2)$作为初始状态，根据条件寻找接受状态，组成一个新的状态机
4. 化简这个状态机

## 区分两个字符串

我们有定义如下：如果$L$是一个在字母表$\Sigma$之上定义的语言，
$x$, $y$是在字母表$\Sigma^\*$之上定义的字符串，那么如果存在一个字符串$z \in \Sigma^\*$,使得要么$xz \in L$且$yz \not \in L$, 要么$xz \not \in L$且$\yz \in L$,我们认为$x$与$y$*可被L区分(L-distinguishable)*。

等价的，我们有：当$L/x \not = L/y$,$L/x = \lbrace z \in \Sigma^* \| xz \in L \rbrace$,$x$与$y$可被L区分。

> 定理：假设$M = (Q, \Sigma, q_0, A, \delta)$是一个接受$L \subset \Sigma^*$的FA，
>     - 如果$x$,$y$是两个可被L区分的字符串，那么$\delta^*(q_0, x) \not = \delta*(q_0, y)$
>     - 对于所有的$n \geq 2$,如果存在一个n对的可被L区分的字符串，那么Q至少会有n个状态。

## 泵引理(Pumpling Lemma)
如果$M = (Q, S, q_0, A, \delta)$是一个接受$L$的FA且状态数量为n，如果其接受一个字符串$x$使得$\|x\| \geq n$,那么当字符被读入时，M必然会不止一次进入同一个状态。

这使得我们可以对如上FA创建任意多的字符串使得其被L所接受——只需要任意重复其重复的状态即可。于是，我们可以导出*泵引理(Pumping Lemma)*：
如果$L$是定义在$\Sigma$上的语言，且$L$被FA$M = (Q, \Sigma, q_0, A, \delta)$所接受，存在一个整数$n$使得对于满足$\|x\| \geq n$的任意$x \in L$，存在三个字符串$u, v, w$使得$x = uvw$，且：
- $\|uv\| \leq n$
- $\|v\| > 0$
- 对于任意的$i \geq 0$,$uv^iw$属于L

这里，整数n通常是FA的状态数目，但是我们一般不需要知道这些。

泵引理最普遍的应用是通过反证法证明一个语言<strong>不能</strong>被一个FA所接受。我们首先假设这个语言可以被FA接受，然后我们取n作为在泵引理中使用的整数。之后，我们选取一个字符串，使得$\|x\| \geq n$,然后我们使用泵引理来得到冲突。
例题详见课件。

## 创建最简状态机 与 Myhill-Nerode 定理



