---
layout: post
title: "MAL-确定有限自动状态机"
modified: 
description: "Notes for Machines and their language"
tags: [ finite automata, cs, notes]
categories: [ Computer Science, Math]
image:
  feature: 49196792_p0.jpg
  credit: ミクの日だったので | WS [pixiv] 
  creditlink: http://www.pixiv.net/member_illust.php?mode=medium&illust_id=49196792
---

Machines and Languages感觉难度比较大，这里记一下笔记来让自己记忆一下，以后复习的时候有一个可以参考的东西。这一篇文章主要是对ppt的一些翻译以及自己的一些想法的记录，主要围绕着确定有限自动机展开。

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

我们用$\Sigma^\*$来表示所有在字母表$\Sigma$之上的字符串。而一个*语言(language)*则是$\Sigma^\*$的一个子集。

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
$x$, $y$是在字母表$\Sigma^\*$之上定义的字符串，那么如果存在一个字符串$z \in \Sigma^\*$,使得要么$xz \in L$且$yz \not \in L$, 要么$xz \not \in L$且$yz \in L$,我们认为$x$与$y$*可被L区分(L-distinguishable)*。

等价的，我们有：当$L/x \not = L/y$,$L/x = \lbrace z \in \Sigma^* \| xz \in L \rbrace$,$x$与$y$可被L区分。

定理：假设$M = (Q, \Sigma, q_0, A, \delta)$是一个接受$L \subset \Sigma^\*$的FA，

- 如果$x$,$y$是两个可被L区分的字符串，那么$\delta^\*(q_0, x) \not = \delta^\*(q_0, y)$
- 对于所有的$n \geq 2$,如果存在一个n对的可被L区分的字符串，那么Q至少会有n个状态。

## 泵引理(Pumpling Lemma)
如果$M = (Q, S, q_0, A, \delta)$是一个接受$L$的FA且状态数量为n，如果其接受一个字符串$x$使得$\|x\| \geq n$,那么当字符被读入时，M必然会不止一次进入同一个状态。

这使得我们可以对如上FA创建任意多的字符串使得其被L所接受——只需要任意重复其重复的状态即可。于是，我们可以导出*泵引理(Pumping Lemma)*：
如果$L$是定义在$\Sigma$上的语言，且$L$被FA$M = (Q, \Sigma, q_0, A,
\delta)$所接受，存在一个整数$n$使得对于满足$\|x\| \geq n$的任意$x \in
L$，存在三个字符串$u, v, w$使得$x = uvw$，且：

- $\|uv\| \leq n$
- $\|v\| > 0$
- 对于任意的$i \geq 0$,$uv^iw$属于L

这里，整数n通常是FA的状态数目，但是我们一般不需要知道这些。

泵引理最普遍的应用是通过反证法证明一个语言<strong>不能</strong>被一个FA所接受。我们首先假设这个语言可以被FA接受，然后我们取n作为在泵引理中使用的整数。之后，我们选取一个字符串，使得$\|x\| \geq n$,然后我们使用泵引理来得到冲突。
例题详见课件。

一些可被泵引理所解决的问题：

- 给定一个$x$，判断是否$x \in L$
- 给定一个有n状态的FA $M$, 判定语言$L(M)$是否为空
- 给定一个有n个状态的FA $M$,$L(M)$是否无穷？

## 创建最简状态机 与 Myhill-Nerode 定理

### 等价类

> 定义：对于一个语言$L \subset \lbrace a, b \rbrace^\*$,我们定义一个在集合$\Sigma^\*$之上的关系$I_L$如下：对于任意的$x, y \in \Sigma^\*$,$x I_L y$当且仅当x，y可被L区分时成立。我们称这样的关系$I_L$为等价关系。对于$X \subset L$,在该集合内任意两个元素对满足等价关系$xI_Ly$,我们称这样的集合为等价集。

假设一个接受字符串"aa"的语言，如果要创建一个符合该语言的自动机，我们需要至少三个状态。三个状态分别对应结尾不是a的字符串，结尾只有一个a的字符串，结尾为两个a的字符串。

### Myhill-Nerode定理

> 定理：对于一个语言$L \subset \Sigma^\*$，有对于等价关系$I_L$的等价类的集合$Q_L$,当且仅当集合$Q_L$是有限集时，该语言可以被一个FA所接受。

如果集合$Q_L$是有限集，那么我们可以建立一个FA$M_L = Q_L, \Sigma, q_0, A, \delta$如下：

- $q_0 = [\Lambda]$
- $A = \lbrace q \in Q_L \| q \subset L \rbrace$
- $\forall x \in \Sigma^\*, \forall \sigma \in \Sigma, \delta([x],\sigma) = [x\sigma]$

那么$M_L$在能接受L的FA中有最少的状态数量。

如果我们已经知道了一个FA可以接受L，那么我们可以通过如下方法来得到等价类：
对于每一个状态$q$,我们可以定义$L_q = \lbrace x \in \Sigma^\* \| \delta^\*(q_0, x) = q$。每一个$L_q$都是一个关于关系$I_L$的等价类的一个子集。

Myhill-Nerode同时也给了我们另一种方法来判断一个语言是否为正则语言（即存在对应该语言的FA）。而这种方法是一个比使用泵引理的更强的陈述。
我们可以对一个语言创建其等价类的集合，如果该集合为无穷集合，那么就无法对该语言创建对应的FA，因而该语言也不是正则语言。

### 创建最简状态机
假设我们有$M = (Q, \Sigma, q_0, A, \delta)$接受语言$L \subset \Sigma^\*$,定义$L_q = \lbrace x \in \Sigma^\* \| \delta^\*(q_0, x) = q \rbrace$

1. 移除所有的使得$L_q$为空的所有状态q，这些状态移除后对FA没有任何实质影响。
2. 在状态集$Q$上定义运算$\equiv$:$p \equiv q$意即所有$L_p$中的字符串与在$L_q$中的所有字符串无法被区分，即$L_p$,$L_q$都是关于$I_L$的等价类的一个子集
3. 对于所有的$p \not \equiv q$，在状态$\delta^\*(p, z), \delta^\*(q, z)$中，有且仅有唯一一个状态属于状态集$A$
4. 定义无序二元状态对集合$S_M$，使得其中的所有二元状态对满足$p \not \equiv q$
5. 我们可以用如下的方法来寻找$S_M$:
    - 对于状态对$(p, q)$，如果仅$p$或者仅$q$属于接受状态集$A$,那么$(p, q) \in S_M$
    - 对于状态对$(p, q)$，如果对于所有的符号$\sigma$，都有$(\delta(p, \sigma), \delta(q, \sigma)) \in S_M$，那么$(p, q) \in S_M$

我们可以用如下的算法来寻找满足关系$p \not \equiv q$的二元对$(p, q)$：
（注：感觉理解还不是很到位，把ppt原文放上来）
An algorithm to identify the pairs $(p, q)$ with $p ≢ q$ :

- List all unordered pairs $(p, q)$ of distinct states.
- Make a sequence of passes through these pairs:
- On the first pass, mark each pair $(p, q)$ so that exactly
one of the two states is in A
- On each subsequent pass, and each unmarked pair
$(r, s)$, if $\delta(r, \sigma) = p$ and $\delta(s, \sigma) = q$ for
some$\sigma \in \Sigma$ , and$(p, q)$ is marked, then mark $(r, s)$
- After a pass in which no pairs are marked, stop
- The marked pairs are the pairs (p, q) for which p ≢ q


- 列出所有的无序二元对$(p, q)$
- 建立一系列的通道来连接这些二元对
- 在第一通道，标记所有的二元对$(p, q)$使得有且只有一个在接受状态集$A$中
- 对于所有的子通道，以及所有的未标记的二元对$(r, s)$，如果对于某些$\sigma \in \Sigma$，如果$\delta(r, \sigma) = p$以及$\delta(s, \sigma) = q$，且$(p, q)$已经被标记，那么标记$(r, s)$
- 如果在一条通道上没有被标记的二元对，则停止。
- 所有的被标记的二元对有关系$p \not \equiv q$

当该算法停止时，未被标记的二元对$(p, q)$表示两个可以被合成一个的状态。


# Nondeterministic Finite Automata

非确定有限状态机(Nondeterministic Finite Automata)的定义是将原来的确定有限状态机的单个转换函数扩展成一个
转换函数集，每次运行时，使用平行(parallel)的思路运行不同的转换函数，只
要有一个返回接受，那么该状态机就接受。


我们定义$\delta(q, \sigma)$为在状态$q$的NFA对于输入$\sigma$可以移动到的状态集合
对于NFA而言，$\delta^\*$的定义略有不同。由于$\delta\*(q, x)$是一个集合，
对于任意的前一集合中的$p$，$U \lbrace \delta(p, \sigma) | p \int \delta^\*(q,
x) \rbrace$是$\delta\*$的第一步（不理解……）

## $\Lambda$闭包

我们同样需要考虑$\Lambda$转换，它可以发生在任何状态。假设$M = (Q,
\Sigma, q_0, A, \delta)$是一个NFA,$S \subset Q$是一个状态的集合。
那么，$S$的$\Lambda$闭包是一个集合$\Lambda(S)$，这个集合可以被递归地定
义如下：

- $S \subset \Lambda(S)$
- 对于所有的$q \in \Lambda(S), \sigma(q, \Lambda) \subset \Lambda(S)$

构建$\Lambda$闭包的方式也很简单，根据定义，令$T = S$，对于任意的$q \in
T$，向$T$中加入所有的$\delta(q, \Lambda)$直到$T$不再发生改变。最终的结
果$T$就是$\Lambda(S)$。

## 消除NFA的不确定性

 
