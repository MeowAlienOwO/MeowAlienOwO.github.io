---
layout: post
title: "Machine Learning Review: SVM & PCA"
date: "2016-12-31 14:23:05 +0800"
categories: [Machine Learning]
tags: [SVM, PCA]
image: 
  feature: http://og78s5hbx.bkt.clouddn.com/60095827_p0.jpg
  credit: snow miku2017 | Lococo:p [pixiv] 
  creditlink: http://www.pixiv.net/member_illust.php?mode=medium&illust_id=60319234
comments: 
---

新年快乐，跨年也是元气满满地在机房～

就不按照上课顺序了，从自己搞不清楚的部分写起。在考SQM之前姑且看看能不
能再复习一遍决策树吧。

# 支持向量机 Support Vector Machine

## 线性分类器

分类学习的基本想法是，在训练集$D$的样本空间中，寻找到一个超平面
(hyperplane)，从而将数据分成两类。感知机(perceptron)就是一个典型的线性
分类器。

线性分类器的一般方程可以表示如下：

$\mathbf{w}^T\mathbf{x} + b = 0$

其中，$\mathbf{w}$是权重向量，$\mathbf{x}$是特征向量。另外，在数学意义上，
$\mathbf{w}$是由方程$\mathbf{w}^T\mathbf{x} + b = 0$所表示的超平面的法向量，
$b$为该超平面的截距。

## 支持向量机

应用线性分类器的时候，我们常常会碰到这样一种情况：

![best-svm](https://computersciencesource.files.wordpress.com/2010/01/svmafter_thumb.png?w=230&h=240)

线性分类器可能的取值在**训练**集上不止一个，那么我们如何寻找**最优**的
线性分类器呢？

注意到样本空间中任意一点$x$到超平面的距离为：

$r = \frac{\|\mathbf{w}^T\mathbf{x} + b\|}{\|\|w\|\|}$

复习一下解析几何：

在二维情况下的情形是点到直线的距离:

$r = \frac{ax + by +c}{\sqrt{a^2 + b^2}}$ 

三维情况下点到平面的距离：

$r = \frac{Ax +By + Cz + D}{\sqrt{A^2 + B^2 + C^2}}$

我们不难推广到高维，其中$\|\|w\|\|$表示向量的模。

另外，我们还有一个关于距离的定义：

> 两个非空集合间的距离为两者内各自的点之间的距离之下确界。

将直线看做点集，点看做只有一个元素的点集，就是点与直线的距离公式。同样，
我们可以将其应用于直线与直线，直线与平面...
这个定义在测试中的基于距离的自适应测试（DART）以及KNN算法里都有应用。

距离超平面最近的样本点为**支持向量**(support vector)。假定超平面可以将训练样本正确分类，
那么我们可以得到：对分类结果有明显影响的是**支持向量**，而样本中其他的
样本点可以忽略不计。定义**间距**(margin)为两个分别在超平面不同边的支持向量到超
平面的距离之和，那么，为了寻找一个**最好**的超平面，我们需要找到有**最大**间
距的超平面。

如果我们令样本分成两类$y = \{-1, 1\}$,我们可以得到：

$\mathbf{w}^T\mathbf{x}_i + b \geq \rho / 2, if y_i \geq 1$

$\mathbf{w}^T\mathbf{x}_i + b \leq - \rho / 2, if y_i \leq -1$

其中$\rho$为间距。由于在这种情况下，支持向量到超平面的距离可以表示为：

$r = \frac{\|(\mathbf{w}^T\mathbf{x}) + b\|}{\|\|\mathbf{w}\|\|}$

我们可以得到：

$\rho = 2r = \frac{2}{\|\|\mathbf{w}\|\|}$

于是我们的问题便可以转化为：求取超平面的法向量$\mathbf{w}$的模
的最小值，且使得所有的样本$(\mathbf{x}_i, y_i)$有
$y_i{\mathbf{w}^T\mathbf{x}_i + b > 1}$。这就是支持向量机的基本模式:

$min_{w,b}\frac{1}{2}\|\|w\|\|^2$

$s.t. y_i(\mathbf{w}^T\mathbf{x}_i+b) \geq 1, i=1,2,...,m$


于是，我们的问题转换成了一个二次规划(quadratic optimization)问题。

## 有约束的二次规划最优化问题，拉格朗日乘子

我们有许多程序包求解二次规划问题，通常而言不需要自己动手。但是了解一下
其中的数学意义还是非常有帮助的。

常用的解二次规划的方法之一，是应
用[拉格朗日乘子](https://en.wikipedia.org/wiki/Lagrange_multiplier)
(Lagrange Multiplier)。

首先我们来看一下二次规划问题的几何意义。

![](https://upload.wikimedia.org/wikipedia/commons/f/fa/Lagrange_multiplier.png)

我们有约束条件$g(x,y) = c$，在图中表示成一条曲线；二次函数$f(x,y)$如
图，描述了一个曲面。假设这个曲面是一座山，约束条件的曲线是我们可以沿着
走的路，我们的目的就变成了：在这条路上，我们要走到最高的地方。图中的圆
圈表示二次函数的[水平集](https://en.wikipedia.org/wiki/Level_set)（可
以直观地理解为等高线）。在**有解**的情况下，二次曲面与约束曲线会有交点。

我们可以容易看出，在（局部）最优的情况下,$f(x, y)$与$g(x,y)$的交点有且
仅有一个，即二者的**切线**相互平行。由于切线与梯度是垂直的，我们可以得
到：在最优点的情况下，二者的**梯度**相互平行。

我们引入一个未知标量--拉格朗日乘子$\alpha$。构建函数：

$$
L(\mathbf{w}, b, \mathbf{a}) = 
\frac{1}{2}\|\|\mathbf{w}\|\|^2 +\sum\limits_{i=1}{m}\alpha_i(1 -
y_i(\mathbf{w}^T\mathbf{x}_i + b))
$$

令函数$L$对$\mathbf{w}$与$b$的偏导数为0：

$$

$$

# Reference
1. 周志华(2015) 《机器学习》（西瓜书）, 2016年1月第一版
2. M.Bishop(2006), __Pattern Recognition and Machine Learning__
3. Lecture Material 
4. 知乎 “拉格朗日乘子法如何理解？”，https://www.zhihu.com/question/38586401
5. July(2012) 支持向量机通俗导论，http://blog.csdn.net/v\_july\_v/article/details/7624837

