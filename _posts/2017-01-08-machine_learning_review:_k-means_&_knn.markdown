---
layout: post
title: "Machine Learning Review: K-means & KNN"
date: "2017-01-08 23:09:34 +0800"
categories: [Computer Science]
tags: [Machine Learning]
image: 
  feature: http://og78s5hbx.bkt.clouddn.com/56118124.jpg
  credit: 4.1 | およよよよよ [pixiv] 
  creditlink: http://www.pixiv.net/member_illust.php?mode=medium&illust_id=56118124
comments: 
---

啊……感觉要加快点节奏，不然来不及……

# 聚类学习
聚类学习(clustering)是无监督学习(unsupervised learning)的一种。训练样
本的标记信息是未知的，目的是通过无监督学习的算法来揭示数据的内部联系。
聚类学习的目的是，将原有的数据集合划分成若干个不相交的子集。每个子集被
称为一个簇(cluster)。但是，这些簇对于聚类算法而言具体代表什么意义是未
知的，需要使用者去标记。

## K-Means

K-Means是一个典型的聚类学习算法。给定样本集$D = \{x_1, x_2,...,x_m\}$，
K-Means的目标是产生k个簇$C = \{C_1, C_2,...,C_k\}$，使得其平方误差最小：

$$
E = \sum\limits_{i=1}^{k}\sum\limits_{x \in C_i} \|\mathbf{x} - \mu_i\|^2
$$

其中，$\mu$是划分为该簇的向量的均值，类似物理学中的质心。

K-means的算法可以大致描述如下：

1. 随机选取k个初始均值向量$\mu_1,\mu_2,...,\mu_k$，用来表示簇的中心
2. 对于所有样本，根据样本数据与均值向量之间的距离$dst = $\|\mathbf{x} - \mu$\|$,将样
   本划分至最近的簇中
3. 划分完后，对于所有的簇，根据现有的样本，重新计算其均值向量并且更新。
4. 重复步骤2,3，直到所有的均值向量不变或者变动范围小于某个阈值

K-Means可以看做是不断地更新质心的过程。

## 对距离的处理

K-Means处理距离的时候常使用闵可夫斯基距离(Minkowski distance)。

$$
dst_mk(\mathbf{x_i}, \mathbf{x_j}) = (\sum\limits_{u=1}^{n}\|x_{iu} - x_{ju}\|^p)^{\frac{1}{p}}
$$

在p值取2的时候，闵可夫斯基距离就是普通的欧几里得距离(Euclidean
distance)：
$$
dst_eu(\mathbf{x_i}, \mathbf{x_j}) =
\sqrt{\sum\limits_{u=1}^{n}\|x_{iu} - x_{ju}\|^2}
$$

p值取1的时候，闵可夫斯基距离变成曼哈顿距离。


# 竞争学习
## 竞争神经网络(Competitive Network)

竞争神经网络是无监督学习的一种，即训练集中的样本没有给出最终的分类结果。
神经网络同样也可以用于无监督学习。其处理方式为增加了一道"竞争"机制。

竞争学习的神经网络通常只有两层：输入层与单层输出节点，输出神经元与输入
节点完全相连。

对于每次输入，只有一个输出神经元会被激活并更新权重。竞争神经网络采取
“赢家通吃”的方法来决定，即只有输出值最大的神经元得到激活并且更新权重。如果下一次
有相近的输入，那么该神经元也会有更大的概率被激活。

## 最小距离分类(minimun distance classifier)

最小距离首先计算每一个已知类别的平均点，然后对于新的样本，分别计算其到
类别平均点的距离，选取距离最近的那个类别进行分类并且更新平均点。


# K邻近算法

K邻近算法(K-nearest neighbour)是一个简单的分类算法。其具体思想是，将样
本同训练集中的元素进行一一比较，取前k个最近的元素，选取这$k$个中最多的
类别进行分类。

K邻近算法没有学习过程，被称之为懒惰学习。

具体算法如下：
1. 将数据集划分为测试集与训练集，并且保证其均匀分布
2. 保存训练集数据
3. 对每一个测试集中数据，计算其与所有的训练集之间的距离，取前K个。K值
   预先指定
4. 取K个最近距离中类别最多的一项，标记类别

K邻近算法虽然简单，但是泛化效率很高。但是，对大的数据集而言，它的效率
不太让人满意。

# Reference
1. 周志华(2015) 《机器学习》（西瓜书）, 2016年1月第一版
2. M.Bishop(2006), __Pattern Recognition and Machine Learning__
3. Lecture Material 
4. liangdas,最小距离分类法介绍, http://blog.csdn.net/liangdas/article/details/17039583
5. 51to.com, 7.6 竞争网络和竞争学习（1）, http://book.51cto.com/art/201302/380106.htm

