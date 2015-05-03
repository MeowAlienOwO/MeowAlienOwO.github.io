---
layout: post
title: "MAL-下推自动机与上下文无关语言"
date: "2015-05-03 14:49:02 +0800"
modified: 
description: "notes on pushdown automata and context free language"
categories: [computer science, math]
tags: [context free language, pushdown automata computer science]
image:
  feature: 29807463.jpg
  credit: 「「うぉーあいにー！」」 | ふらすこ@お仕事募集なう [pixiv]
  creditlink:  http://www.pixiv.net/member_illust.php?mode=medium&illust_id=29807463
comments: 
---

考前复习+Course work复习, 下推自动机与上下文无关语言部分……土狼：people die if they are killed。

MD还要躺着……戴了护裆都能中招真是……

<embed height="452" width="544" quality="high" allowfullscreen="true"
type="application/x-shockwave-flash"
src="http://share.acg.tv/flash.swf" flashvars="aid=382643&page=1"
pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash"
/>

# 上下文无关语言

## 上下文无关文法(Context-Free Grammar)

上下文无关文法由一个四元组$G=(V, \Sigma, S, P)$来描述。其中：

* $V$ 是变量集合，或者说非停止符号集
* $\Sigma$ 是停止符号集
* $S$ 是起始变量
* $P$ 是语法规则集(rule/productions)，$P$中的元素通常是如下的形式：$A \to
  \alpha, A \in V, \alpha \in (V \cup \Sigma)$
* $S \in V$, $V$ 与 $\Sigma$无交集。$V$, $S$, $P$都是有限的。

我们使用如下的符号来表示一些推导规则：

* $\to$ 表示在语法中的一个生成规则(production), $\Rightarrow$表示根据语法
  规则的一步推导(derivation)
* $\alpha \Rightarrow^n \beta$ 表示$n$步推导，$\alpha \Rightarrow^*
  \beta$ 表示0或者多步推导。
* $\Rightarrow_G$ 表示根据语法$G$的推导。

$\alpha \Rightarrow \beta$ 表示存在字符串$\alpha_1, \alpha_2$, $\gamma \in (V
\cup \Sigma)^*$, 以及生成规则$A \to \gamma \in P$, 使得$\alpha = \alpha_1 A
\alpha_2$, $\beta = \alpha_1 \gamma \alpha_2$


当如上的推导规则可以对于任意可能的$\alpha_1,\alpha_2$都成立时，我们认为该规则是
上下文无关的(context-free)


## 上下文无关语言(Context-Free Language)

假设存在一个上下文无关文法(CFG)$G=(V, \Sigma, S, P)$, 由$G$生成的语言
为：
$ L(G) = \lbrace \chi \in \Sigma^* \| S \Rightarrow_G^* \chi \rbrace $

当存在一个语言$L$,使得$L = L(G)$, 我们可以说这个语言是上下文无关语言(Context-Free Language)。

## 联合，连接与Kleene星号运算
如果$L_1$, $L_2$都是定义在$\Sigma$上的上下文无关语言，那么$L_1 \cup
L_2, L_1 L_2, L_1^*$都是上下文无关语言。

令$G_1, G_2$分别表示$L_1, L_2$的语法，假设他们之间没有公共变量。$S_1,
S_2$分别是起始变量。

令$S_u, S_c, S_k$分别表示联合，连接与Kleene星号的起始变量，$G_u, G_c,
G_k$表示对应的语法，我们可以创造如下规则使前述定理成立：

* 对于$G_u$, 向$G_1, G_2$添加规则$S_u \to S_1 \| S_2$
* 对于$G_c$, 向$G_1, G_2$添加规则$S_c \to S_1 S_2$
* 对于$G_k$, 向$G_1$添加规则$S_k \to \Lambda \| S_k S_1$

## 上下文无关语言的泵引理

CFL同样有泵引理的应用。令$L$为CFL，那么必然存在一个正整数$n$,使得对于任意的$u
\in L, \| u \| \geq n$, $u$可以被写成$u=vwxyz$, 而且满足：


* $\| wy \| > 0$
* $\| wxy \| \leq n$
* $\forall m \geq 0, vw^mxy^mz \in L$

（证明待补充）

## 泵引理的应用

我们以$L = \lbrace a^nb^nc^n \| n \geq 0 \rbrace$作为例子说明泵引理在证明某个语
言非上下文无关中的应用。



令$u$是一个形如$a^nb^nc^n$的字符串且$\| u \| \geq n$

我们有$u=vwxyz$满足泵引理之条件。$\| wy \| > 0$说明字符串$wy$至少有一个符号。$\|
wxy \| \leq n$说明$wxy$至多含有两个不同的符号。假设$\sigma_1$是一个出现在$wy$中
的符号，$\sigma_2$是不在$wy$中的符号。那么字符串$vw^0xy^0z$同样可以保持$u$的特性，
但是显然$\sigma_1$的数目小于$n$,而$\sigma_2$的数目等于$n$，这与泵引理的第3条特性
矛盾。

