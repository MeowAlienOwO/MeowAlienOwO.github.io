---
layout: post
title: "机器与语言"
modified:
description:
tags: []
categories: [ cs, language]
image:
  feature:
  credit:
  creditlink:
---

Machines and Languages感觉难度比较大，这里记一下笔记来让自己记忆一下，以后复习的时候有一个可以参考的东西。

# Basic
在深入其他内容之前，我们需要掌握一下语言的概念。

关系：对于集合$A$与集合$B$, *从A到B的关系(A relation from A to B)*是$A$与$B$的一个笛卡尔积$A \times B$的子集。一个在集合$A$上的关系是从$A$到$A$的关系，或者说是$A \times A$的一个子集。

我们可以将关系表述为：
定义$R$表示一个在某集合上的关系，我们可以将"A与B相关"写作：

$aRb$

或者

$(a, b) \in R$

一个在集合$A$上的关系$R$如果满足如下条件，我们称之为*等价关系(equivalence relation)*：


1. $R$具有*自反性(reflexive)*：对于所有的$x \in A, xRx$.

2. $R$具有*对称性(symmetric)*: 对于所有的$x, y \in A$, 如果$xRy$，那么$yRx$.

3. $R$具有*传递性(transtive)*: 对于所有的$x, y, z \in A$, 如果$xRy, yRz$，那么$xRz$.

对于一个在集合$A$上的等价关系$R$，以及一个元素$x \in A$，包含$x$的*等价类(equivalence class)*定义为：

$[x]_R = { y \in A \| yRx } $

对于等价类与等价关系，我们有如下定理：

> 如果$R$是一个A上的等价关系，关于R的等价类将A分割成若干子集。A内的两个元素当且仅当他们属于同一等价类时，他们有等价关系。

*字母表(Alphabet)*是若干符号的一个有限集，比如`{a, b}`,`{0, 1}`.我们使用希腊字母$\Sigma$来表示一个字母表。一个在字母表$\Sigma$之上的*字符串(String)*定义为$\Sigma$内符号的一个有限序列。对于一个字符串$x$,$\|x\|$表示字符串的长度。另外，我们有空字符串$\Lambda$是在任意的字母表$\Sigma$之上，且$\|\Lambda\| = 0$

$n_a(X)$表示$a$在字符串$X$中的出现次数。

我们用$\Sigma^*$来表示所有在字母表$\Sigma$之上的字符串。而一个*语言(language)*则是$\Sigma^*$的一个子集。

我们用$xy$来表示字符串$x$与$y$的*连接(concatenation)*，这也是对字符串最基本的操作。它有着如下的特性：

- 对于任意的$x$,$x \Lambda = \Lambda x = x$
- $\|xy\| = \|x\| + \|y\|$

对于在$\Sigma$之上定义的语言$L_1, L_2$, $L_1 \cup L_2, L_1 \cap L_2, L_1 - L_2$都是在$\Sigma$之上定义的语言。

如果$L$是在$\Sigma$上定义的语言，那么$\L^*$表示将$L$中任意数目的任意字符串连接起来的语言。我们把这种操作称为*Kleene星号(Kleene Star)*操作。

$L^* = \cup  \{L^k \| k \in \mathbb{N}\}$


# Finite Automata


# Pumpling Lemma

# Myhill-Nerode theorem

