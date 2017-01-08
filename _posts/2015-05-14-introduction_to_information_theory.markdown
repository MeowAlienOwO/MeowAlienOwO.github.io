---
layout: post
oldpage: true
title: "Introduction to Information Theory"
date: "2015-05-14 23:23:43 +0800"
modified: 
description: "Notes on Information Theory"
categories: [Computer Science]
tags: [information theory, huffman coding, notes, cs]
image:
  feature: 49154861.jpg
  credit: 偶然ではない必然 | junk [pixiv] 
  creditlink: http://www.pixiv.net/member_illust.php?mode=medium&illust_id=49154861
comments: 
---

肯德基居然打烊……说好的24小时呢……啊啊……好想给吃撑喂食play……(另外多少弹药可以钓一个打伞的大姐姐……)


# 简介

The fundamental problem of communication is that reproducing at one
point either exactly or approximately a message selected at another
point.



# 信息熵与信息

## 信息冗余

> The quick brown fox jumps over the lazy dog

这句句子中包含了所有的英文字母。我们可以很明显的看到其中有一些冗余字母，
比如说空格之类。移除所有空格可以使得我们依然能保持原有的意思，
但是移除所有的t,h,e字母则不行。这意味着，我们不能移除所有的冗余。

## 熵

我们使用熵(Entropy)来度量某个特殊的随机变量的平均不确定性。

在信息编码方面，熵用于度量描述一个随机变量的平均必须比特数量，
或者被认为是度量信息内容的量。

通常而言，熵可以表示表述一个随机变量所需平均比特数量的下界，
但是在实际的应用中，这往往无法实现。

计算公式：

$H(X) = - \Sigma_x p(x) \log_2 p(x)$

## 偏离(bias)

当随机变量存在偏离时，熵的计算公式依然成立。比如在一个有8匹马参加的比赛中，
它们赢的概率分别为1/2, 1/4/, 1/8, 1/16, 1/64， 1/64。
熵值为2，这意味着我们仍然可以用平均长度为2的编码方法来编码所有的信息。

## 霍夫曼编码

### 前缀码(prefix codes)

对于前缀码而言，没有任何元素可以成为另一个元素的开头。这导致了其的唯一性，也就是无歧义性。

霍夫曼编码是前缀码的一种。

### 创建霍夫曼编码

霍夫曼编码由符号的相对出现频率决定。霍夫曼算法可以保证平均符号长度的最优化。

> 例子：e 0.15, a 0.19, d 0.30, s 0.36

将所有的未编码符号按照出现频率升序排列：

> e a d s

从小到大将两个频率之和相加直到和为1

> e+a, (e+a)+d, ((e+a)+d)+s

通过如上求和，构建霍夫曼树(可以看作构建语法树)

>              1 
>              |
>           s  +  0.64
>                   |
>                d  +  0.34
>                        |
>                     a  +  e
 
从上到下，左边取0, 右边取1，最终编码为：

> s 0
> d 10
> a 110
> e 111
