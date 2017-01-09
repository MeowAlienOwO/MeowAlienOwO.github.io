---
layout: post
title: "Machine Learning Review: SVM & PCA"
date: "2016-12-31 14:23:05 +0800"
categories: [Computer Science]
tags: [Machine Learning]
image: 
  feature: http://og78s5hbx.bkt.clouddn.com/60319234_p0.jpg
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
\frac{1}{2}\|\mathbf{w}\|^2 +\sum\limits_{i=1}^{m}\alpha_i(1 -
y_i(\mathbf{w}^T\mathbf{x}_i + b))
$$

令函数$L$对$\mathbf{w}$与$b$的偏导数为0：

$$
\mathbf{w} = \sum\limits_{i=1}{m}\alpha_i y_i \mathbf{x}_i\\
0 = \sum\limits_{i=1}^{m}\alpha_i y_i
$$

将上述两式代入原来的函数$L$得到函数$L'$:

$$
L' = \sum\limits_{i=1}^{m} - \frac{1}{2}
\sum\limits_{i=1}^{m}\sum\limits_{j=1}{m} \alpha_i \alpha_j y_i y_j
\mathbf{x}_i \mathbf{x}_j
$$

从而，问题也转换成了原问题的拉格朗日对偶问题(Lagrange dual problem)：
求$\alpha$,使得函数$L'$有最大值，并且符合约束条件$\sum\alpha_i y_i = 0$
另外，我们还需要该函数满足KKT条件：

$$
\alpha_i \geq 0; \\
y_i f(\mathbf{x}_i) - 1 \geq 0;\\
\alpha_i(y_i f(x_i) -1) = 0.
$$

解出该二次规划后，我们可以得到模型：

$$
f(x) = \mathbf{w}^T\mathbf{x} + b \\
= \sum\limits_{i=1}^{m}\alpha_i y_i \mathbf{x}_i^T \mathbf{x} + b
$$

其中，每一个非零的$\alpha_i$都对应一个支持向量$x_i$。

对于支持向量机的开销，我们要记住以下几点：
1. 我们要计算支持向量与所有测试点$x$的内积
2. 我们要计算所有的样本点$x$的模

这两点使得支持向量机的开销在面对大量的数据点时会变得比较糟糕。


## 软间隔与正则化

在理想情况下，支持向量机应当能够对所有的样本正确分类；但实际上这并不一
定能够做到。解决的方法是，我们“容忍”一些样本点不被正确分类，即一些样
本点不满足：

$$
y_i(\mathbf{w}^T\mathbf{x}_i + b) \geq 1
$$

将原来的优化目标重写为：

$$
\min\limits_{\mathbf{x}, b} \frac{1}{2} \|\mathbf{w}\|^2 +
C\sum\limits_{i=1}^{m}lost(y_i (\mathbf{w}^T \mathbf{x}_i + b) - 1)
$$

其中，$lost$ 是一个损失函数，有多种定义。如果采用hinge损失，即将损
失函数定义为：
$$
lost_{hinge}(z) = max(0, 1-z)
$$
![多种损失函数](http://www.csuldw.com/assets/articleImg/4DFDU.png)

引入松弛变量$\xi$(slack vairable),我们可以将其改写为：

$$
L(\mathbf{w}) = \mathbf{w}^T\mathbf{w} + C\sum\xi_{i} \\
y_i(\mathbf{w}^T\mathbf{x}_i + b) \geq 1 - \xi{i}, \xi_i \geq 0 
$$

其中，常数C可以被认为是一个用于控制过拟合与正确率之间的参数。由于每个
样本都有一二对应的松弛变量，我们同样需要类似地引入另一个拉格朗日算子来
化简变量。

## 非线性SVM，核函数与升维方法

我们之前讨论的SVM有一个前提：样本空间是线性可分的。但是，我们存在很多
问题是**线性不可分**的，比如说异或。对于这种问题，我们通常将其映射到一
个更高维的特征空间，使其线性可分。如果原始空间是有限维，那么一定存在一
个高维特征空间，使得样本可分。

![](http://img.my.csdn.net/uploads/201304/03/1364952814_3505.gif)

注意到线性分类器依赖于向量的内积：$K(\mathbf{x}_i, \mathbf{x}_j)$，我
们有升维变换
$\varphi\mathbf{x}\rightarrow\varphi(\mathbf{x}_i)^T\varphi(\mathbf{x}_j)$
。由于升维后的特征空间维数可能很高，我们直接计算这个升维变换会变得比较
困难。

**核函数**(kernel function)是一个等价于
$\varphi(\mathbf{x_i})^T\varphi(\mathbf{x_j})$ 的函数。通过直接应用核
函数，我们就不需要去计算高维乃至无穷维特征的内积。核函数隐式地将低维空
间的点映射到高维空间，就不需要显式地计算高维空间的内积了。

如果我们知道映射$\varphi$的具体形式，我们就可以很容易地找到核函数。但
是，我们常常不知道具体的映射方式。同时，单纯地用原始的映射构造高维空间
有可能导致维数爆炸（比如July在他的文章里写的，两个同心圆分布+噪声的数
据的映射有可能是2维到5维，维度更高的会更加糟糕）。

我们有如下定理：

> 令$\chi$为输入空间，$k$是定义在$\chi * \chi$上的对称函数，则函数$k$
> 是核函数，当且仅当对于任意数据$D = {x_1, x_2,...,x_m}$, 核矩阵
> (kernel matrix)总是半正定(semi-positive)的。

(矩阵见PPT)

也就是说，只要一个对称函数所对应的核矩阵半正定，它就能作为核函数使用。

一些常见的核函数：
1. 线性核：$k(x_i, x_j) = x_i^T x_j$
2. 多项式核：$k(x_i, x_j) = (x_i^Tx_j)^d$
3. 高斯核：$k(x_i, x_j) = exp(-\frac{\|x_i - x_j \|^2}{2\sigma})$

# 主成分分析(PCA)

同升维方法相反，PCA是一种降维方法<del>二向箔</del>。比如在面部识别的时
候，常用的方法是用一个遮罩(mask)对当前图像的像素进行逐一扫描。这时特征
空间的维度会非常高，以至于难以处理。在这种情况下，我们需要缩减特征的数
量，也就是进行降维处理。

复习一下矩阵，我们要将一个高维向量(N维)缩减成低维(n维)：

$$
Y = AX
$$

其中$Y$是转换后的低维向量，$A$是n*N转换矩阵。

PCA的数学定义：

> 一个正交化线性变换，将数据变换到一个新的坐标系统中，使得这个数据的任
> 何投影的第一大方差在第一个坐标（第一主成分）上，第二大方差在第二个坐
> 标（第二主成分）上...

我们可以想象一个超平面，在这个超平面上，样本的投影能分开，这样，我们就
只需要关心超平面上的样本就行了--这意味着，我们不需要处理更高维的样本空
间了。于是，我们关心两个性质：
1. 最近重构性：所有的样本点尽量靠近超平面
2. 最大可分性：样本点在这个超平面上的投影尽可能分开

两种方式都可以推出主成分分析，但是我们主要从最大可分性的角度入手。我们
要使得投影点分得最开，就要让方差最大。

## 协方差矩阵

在统计学上，计算不同变量之间的方差叫做**协方差**。假设我们有两个变量
$x$，$y$，我们希望探索他们之间的相关程度：

$$
cov(x, y) = \frac{\sum\limits_{i=1}^{n}(x_i - \overline{x})(y_i -
\overline{y})}{n - 1}
$$

容易看出，方差就是协方差的一种特殊形式。

对于一个m*n的样本矩阵$M$，每行为一个样本，每列为一个维度，我们定义协方差矩
阵$C$，使得矩阵中一个元素$C_{ij}$有：

$$
C_{ij} = cov(M_{:,i}, M_{:,j}) \\
= \frac{\sum(M_{:,i} - \overline{M_{:,i}})(M_{:,j} - \overline{M_{:,j}})}{m - 1}
$$

特别注明一下，协方差矩阵计算的是**维度**之间的协方差，不是单个数据的。

在实际应用的时候，我们会先对样本矩阵进行处理：对于每一个数据，减去该
列的均值。我们称这种方法为中心化处理。经过中心化处理后，不难看出，协方
差矩阵是样本矩阵及其转置的乘积，再除以标量$m-1$，即样本数量。

## 求解转换矩阵

// 这一部分主要翻译PPT,西瓜书，网上博客都各种各样的推导方法，我很好奇

// <del>好骑</del>

我们可以看出，如果我们想尽量的让维度之间无关（分得更开），我们应该将矩
阵的协方差部分（非对角线部分）尽量为0，为此，我们需要将协方差矩阵**对
角化**（注，这里对为什么要对角化以及特征值的意义很模糊……有懂的人教教
我）

令$P$表示转换矩阵，推导如下：

$$
S_y = \frac{1}{n - 1} YY^T = \frac{1}{n-1}(PX)(PX)^T \\
    = \frac{1}{n-1}P X X^T P^T \\
    = \frac{1}{n-1}P (X X^T) P^T \\
    = \frac{1}{n-1}P A P^T \\
    where A = XX^T
$$

这里，我们要让最终转换后的协方差矩阵成为**对角矩阵**，即各个维度之
间协方差为0。

考
虑[特征值分解](https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors)矩
阵：$A = P'DP'^T$，我们可以发现，中间的$D$显然是一个对角矩阵。将
$A=XX^T$进行特征值分解，我们得到：

$$
S_y = \frac{1}{n-1} PP'DP'^TP^T 
$$

显然，当$P = P'^T$的时候，我们有$S_y = \frac{1}{n-1}D$。鉴于我们在做PCA的时候认为所有的基础向量都是正交的
(PCA assumes all basis vectors are orthonormal)，我们的结果是，问题转换
成了求矩阵$P'^T$。于是，PCA的步骤如下：

1. 将样本矩阵中心化
2. 计算样本的协方差矩阵$XX^T$
3. 对$XX^T$做特征值分解
4. 取若干个最大的特征值所对应的特征向量，组成转换矩阵。其他特征值小的
   被认为不是“主成分”，被丢弃。




# Reference
1. 周志华(2015) 《机器学习》（西瓜书）, 2016年1月第一版
2. M.Bishop(2006), __Pattern Recognition and Machine Learning__
3. Lecture Material 
4. 知乎 “拉格朗日乘子法如何理解？”，https://www.zhihu.com/question/38586401
5. July(2012) 支持向量机通俗导论，http://blog.csdn.net/v\_july\_v/article/details/7624837
6. D.W's Notes, 机器学习-损失函数，http://www.csuldw.com/2016/03/26/2016-03-26-loss-function/
7. 古剑寒 PCA详解，https://my.oschina.net/gujianhan/blog/225241
8. 进击的马斯特 再谈协方差矩阵之主成分分析http://pinkyjie.com/2011/02/24/covariance-pca/
