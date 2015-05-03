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

# 上下文无关文法(Context-Free Grammar)

## 定义

上下文无关文法由一个四元组$G=(V, \Sigma, S, P)$来描述。其中：

* $V$ 是变量集合，或者说非停止符号集
* $\Sigma$ 是停止符号集
* $S$ 是起始变量
* $P$ 是语法规则集(rule/productions)，$P$中的元素通常是如下的形式：$A \to
  \alpha, A \in V, \alpha \in (V \cup \Sigma)$
* $S \in V$, $V$ 与 $\Sigma$无交集。$V$, $S$, $P$都是有限的。

我们使用如下的 语言来

