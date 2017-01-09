---
layout: post
title: "Machine Learning Review: Neural Network"
date: "2017-01-09 18:36:10 +0800"
categories: [Computer Science]
tags: [Machine Learning]
image: 
  feature: http://og78s5hbx.bkt.clouddn.com/60827595.jpg
  credit: 2017 謹賀新年 | おたけやん [pixiv] 
  creditlink: http://www.pixiv.net/member_illust.php?mode=medium&illust_id=60827595
comments: 
---

呼……终于到最后一篇了，也是开学学的内容。

今年也请多多指教。

# 神经网络（Neural Network）

神经网络是一种很古老，但是到现在依然有很广泛的用途的机器学习算法。包括
现在火的深度学习，其基础也是神经网络。

神经网络的定义（来自西瓜书，引用T.Kohonen）：

> 神经网络是由具有适应性的简单单元组成的广泛并行互联的网络，其组织能
> 够模拟生物神经系统对真实世界作出的交互反应。

## 神经元模型(Neuron Model)

如上述的简单单元就是神经网络的最基本组成部分--神经元。一个神经元可以接
受若干个来自其他神经元的输入信号，这些信号通过带权重的连接进行传递，总
输入值与神经元的阈值进行比较，然后通过激活函数处理，形成神经元的输出。

神经元的数学形式可以表示如下：

$$
y = f(\sum\limits_{i=1}^{n}w_ix_i - \theta) 
$$

其中，$f$表示激活函数，$w_i$表示权重，$x_i$表示属性值，$\theta$表示阈
值。

一种比较基本的激活函数是**阶跃函数**（signal function），即等于或超过阈值则为1，反之为0。
但是这个函数不方便求导与计算误差，我们在实际中比较常见的函数有sigmoid
函数：

$$
sigmoid(x) = \frac{1}{1 + e^{-x}}
$$

神经元具有学习功能，会根据输出值与真实值的误差对权重进行调整，从而达到
泛化的目的。表示神经元的学习方式的函数叫做**训练函数**(training function)

## 感知机（Perceptron）

感知机是一种最基本的神经网络，其包含两层神经元，输入层接受外界的信号，
传递给输出神经元。输出神经元对输入的数据作加权处理，然后与阈值
（threshold）做比较，判断神经元是否被激活。

感知机可以被认为是一种线性分类器，即在样本空间中寻找一个超平面，使得样
本能够分布在超平面的两端。这需要我们的样本是**线性可分**的。这也是我们
对应用感知机场景的一个基本假设。例如，XOR问题就不是线性可分的，因此无
法应用感知机。

感知机会根据输出值与目标分类值之间的误差更新权重，这就是感知机的**学习
**过程。

基本的感知机表示如下：

$$
R = \theta + \sum\limits_{i=1}{m}w_ix_i \\
o = sign(R) = \lbrace +1; if~R > 0 \\ -1; otherwise
$$
其中，阈值$\theta$可以看做一个输入值恒为-1（或者-1）的"哑节点"（dummy
node），那么感知机的表达方式就可以统一为权重的学习。

感知机的训练函数为：

$$
w_i \gets w_i + \eta (d - o) x_i, i = 1,2,...,n
$$

其中，$w_i$表示权重，$\eta$表示学习率。学习率是一个常数，用于控制学习
的速度。太低会导致学习过程缓慢，太高则有可能导致学习失败：感知机无法收
敛到一个比较适当的区间。$d$表示类别的值，$o$表示感知机的输出，我们也可
以将$d - o$统一成为误差。

我们不加证明地给出收敛性定理：

> 如果样本是线性可分的，那么感知机将会一定可以在有限的步骤内收敛到一个
> 解。

## 自适应线性神经元（Adaptive Linear Elements）

感知机由于采用了阶跃函数作为激发函数，容易出现难以收敛的情况。同时在
样本集不是线性可分的情况下，感知机难以找出一个恰当的近似。为此，我们引
入自适应线性神经元。

简单地说，自适应线性神经元取消了阶跃函数，直接以输入的加权求和（包括阈
值，或者说哑输入）作为输出值。

$$
o = \theta + \sum\limints_{i=1}{n} w_i x_i
$$

我们的误差函数也需要从原来的简单相减进行改变：

$$
Err(W) = \frac{1}{2} \sum\limits_{k = 1}^{K}(d_k - o_k)^2
$$

其中，k用于表示第k个训练样本，$d_k$表示样本的目标分类，$o_k$表示输出值。

这里常数1\2是用来处理求导后产生的常数。我们从误差函数中可以看出，如果
误差函数越小，神经元就有更好的近似。


## 梯度下降法（Gradient Decent）


对于自适应神经元，我们的训练目标是在样本空间中，对于给定的训练集，使其
误差最小。为此，我们需要引入梯度下降法(Gradient Decent)。

在高维的情况下，同斜率等效的一阶导数称作[梯度](https://en.wikipedia.org/wiki/Gradient)(gradient)。我们知道，二维
的情况下函数的极小值是“山谷”的位置，即斜率为0且左右领域函数值皆大于
极小值。推广至高维，高维函数的极小值同样是梯度为0的点。
我们如果要使误差向极小值移动，我们需要判定其移动方向。在二维的情况下，
我们选取**斜率减小**的方向，即函数值减小的防线。

同样的，我们在高维需要选取**梯度减小**的方向。对于权重的某个取值
$\mathbf{w}$，我们可以求其梯度：

$$
\nabla F(w_1, w_2,...,w_m)
$$

符号$\nabla$是一个用来表示向量微分的算子。为了更新权重，我们更加关注的
是，权重向量在某一维度上的**分量**的改变趋势。为此，我们需要求取函数在
某一维度上的导数，即为[偏导数](https://en.wikipedia.org/wiki/Partial_derivative)：

$$
\frac{\partial}{\partial{w = w_i}} Err(w)
$$

梯度可以写作:

$$
\nabla Err(\mathbf{w}) = [ \frac{\partial}{\partial{w_1}}, \frac{\partial}{\partial{w_2}},...,\frac{\partial}{\partial{w_m}}]
$$

对于单个分量$w_i$而言，我们的训练函数改写如下：

$$
w_i \gets w_i - \eta \frac{\partial E}{\partial{w_j}}
$$

因此，我们需要计算误差函数的偏导数。对于有K个样本的训练集，求总的
偏导数：

$$
\frac{\partial Err}{\partial w_i} = \frac{\partial}{\partial w_i}\frac{1}{2}\sum\limits_{k=1}^{m}
 (\mathbf{d} - \mathbf{o})^2
$$

提取常数项

$$

= \frac{1}{2} \frac{\partial}{\partial w_i} \sum\limits_{k=1}^K
(\mathbf{d} - \mathbf{o})^2 
$$

提取和式

$$
= \frac{1}{2} \sum\limits_{k=1}^K \frac{\partial}{\partial w_i}
(\mathbf{d} - \mathbf{o})^2\\

$$

考虑到$(\mathbf{d} - \mathbf{o})^2$是关于$w_i$的函数，应用链式法则并消去常数项

$$
= \sum\limits{k=1}^K (\mathbf{d} - \mathbf{o})
\frac{\partial}{\partial{w_i}} (\mathbf{d} - \mathbf{o})
$$

接下来，求$\mathbf{d} - \mathbf{o}$的偏导数。我们可以很容易地看出，这是一个线性函数，这意
味着其他分量的导数为0（参考偏导数定义），有作用的只有$w_ix_i$这一项。保留符号，我们有

$$
= -\sum\limits{k=1}^K(\mathbf{d} - \mathbf{o})x_i(k)
$$

于是我们的训练函数更改为：

$$
w_i \gets w_i + \eta \sum\limits_{k=1}{K}(\mathbf{d} - \mathbf{o}) x_i(k)
$$

这被称为Delta法则(Delta Rule)

我们同样可以迭代求梯度，区别在于不是一次求取所有训练集的误差与更新值，
而是每次计算一个训练样本。但是，这两者实际的结果会有所差异。
每次训练的时候，我们迭代所有的训练样本一次，称作一个epoch。每次迭代样
本的排序一般而言会改变。

在满足以下两个条件之一的时候，停止训练：

1. 当预设的epoch数量运行完毕时
2. 当误差小于某个预设值


## 神经网络
由于线性神经元只能识别线性可分的情况，不能寻找非线性决策平面。于是，人
们将若干神经元通过某些方式组合起来，形成神经网络。
下图展示了神经网络的一种基本形式，其拓扑结构为单向向前输出的神经网
络，后一层的输出是下一层的输入。

![](https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Colored_neural_network.svg/300px-Colored_neural_network.svg.png)



在神经网络中，激发函数一般使用sigmoid函数。它有一个很好的数学性质：

$$
f'(x) = f(x)(1 - f(x))
$$

应用sigmoid函数计算偏导数如下：

$$
\frac{\partial}{\partial w_i} Err(w) = -\sum\limits_{k=1}^K (d_k - o_k)
\frac{\partial}{\partial w_i}sigmoid(net(\mathbf{w}\mathbf{x}))
$$

其中$net(k)$是神经网络的对样本k的输出，即权重与输入的加权求和式。原来
的函数无法一步求导到位，应用
链式法则拆成两个变量相同的函数：

$$
\frac{\partial}{\partial w_i} sigmoid(net(k)) = \frac{\partial
o_k}{\partial net(k)} \frac{\partial sum(k)}{w_i}
$$

根据sigmoid函数的特征，我们有

$$
\frac{\partial sigmoid(net(k)}{\partial sum(k)} = sigmoid(sum(k))(1 -
sigmoid(net(k))) = o_k(1 - o_k)
$$

则我们的偏导数为：

$$
\frac{\partial Err}{\partial w_i} = \sum\limits_{k=1}^K x_i(k) o_k
(o_k - d_k)(1 - o_k)
$$


## BP算法

我们以简单的三层神经网络（输入，隐层,输出）来讨论整个神经网络的权重更
新算法：反向传播法(back propagation)

BP算法大致可以描述如下：
1. 输入训练样本，计算其误差
2. 根据误差，计算梯度，更新权重
3. 根据上一步的梯度改变值，计算上一层的权重改变量，更新权重
4. 重复直到获得满意成果或者epoch用完

考虑步骤2,3，我们不难发现，在应用上面的偏导数的前提下，需要知道如何**
递归地**求取前面层级的权重更新量。

我们记

$$
\delta = - \frac{\partial Err}{\partial o} \frac{\partial o}{net}= o (o - d)(1 - o)
$$

其中$net$表示该神经元的输入，即上一层的输出向量与权重的加权。

令输出层的某个神经元为l,隐层的某个神经元为m,输入层某个神经元为n。
则，对于连接输出层与隐层的权重$w_{lm}$个，我们的更新公式可以写成:

$$
w_{lm} = w_{lm} + \eta \delta_l x_m 
$$

其中$\delta_l$是根据输出神经元l计算的值；$x_m$指的是输入向量的值。

连接输入层与隐层的权重的更新公式表示如下:

$$
w_{mn} = w_{mn} - \eta \Delta w_{mn}\\
 = w_{mn} - \eta \frac{\partial Err}{\partial w_{mn}}\\
$$

注意到$x_m$是隐层的输入也是输入层的输出，用链式法则拆分偏导数：

$$
- \frac{\partial Err}{\partial w_{mn}} = - \frac{\partial
Err}{\partial x_m} \frac{\partial x_m}{\partial w_{mn}} \\
= - \frac{\partial Err}{\partial x_m} \frac{\partial x_m}{w_{mn}}
$$

使用sigmoid函数的特性，有

$$
= -\frac{\partial Err}{\partial x_m} x_m(1 - x_m)
$$

对于前面部分的偏导数，我们有

$$
- \frac{\partial Err}{\partial x_m} = -\sum\limits_{i = 1}^{l}
\frac{\partial Err}{\partial net} \frac{\partial net}{\partial x_m}\\
= \sum\limits_{i=1}{l} w_{im}g_{i}
$$

于是输入层的更新函数就为：

$$
w_{mn} \gets w_mn - \eta x_m(1-x_m)\sum\limits_{i=1}^l w_{im}g_{i} x_n
$$

注：此处限于本人数学水平，对为何要求和没有很好的理解，只能模糊地认
为需要汇总所有的输出层的改变量，方向大致是全微分但是还是没能很好理解，
待有识之士指导。

以下是一个演示图：

![](http://og78s5hbx.bkt.clouddn.com/08135834-8e9b8ff2212545c0aeb1d68103ef3d64.gif)



# Reference
1. 周志华(2015) 《机器学习》（西瓜书）, 2016年1月第一版
2. M.Bishop(2006), __Pattern Recognition and Machine Learning__
3. Lecture Material 
4. 郭兰哲，BP算法，https://jlunevermore.github.io/2016/06/25/10.BP%E7%AE%97%E6%B3%95/
5. daniel-D's blog，BP算法之一种直观的解释 http://www.cnblogs.com/daniel-D/archive/2013/06/03/3116278.html
6. daniel-D's blog，BP算法之向后传导 http://www.cnblogs.com/daniel-D/archive/2013/06/06/3121742.html

7. 大量的网络资料（记不清了- -）
