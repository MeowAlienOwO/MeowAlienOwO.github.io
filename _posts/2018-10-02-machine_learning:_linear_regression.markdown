---
layout: post
title: "Machine Learning: Linear Regression"
categories: ['ML', 'algorithm']
tags: 
image: 
  feature: http://og78s5hbx.bkt.clouddn.com/60323285_p0.jpg
  credit: 和武はざの | シールダー
  creditlink: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=60323285
comments: 
---

Linear regression is one of the oldest method for statistics, also regarded as an guide algorithm for machine learning.

In this article, I will follow what I've learned in MLPR, with content talking about the algorithm itself, regularization, logistics regression (sigmoid function), Raditional Basis Function(RBF). Besides, I'll talk about some topic that we will come through all algoritms: overfitting, measure of performance.

### music
<del>Finally I got somewhere to make audio for the blog ;P</del>
<audio controls><source src="http://mp3.flash127.com/music/47306.mp3" type="audio/mpeg">您的浏览器不支持音频格式</audio>

_脱獄　Datsugoku_

`Producer`: Neru(押入p)

`Origin Vocaloid`: 鏡音りん Kagamine Rin

`Singer`: まふまふ　mafumafu

<p style="color: orange">エンジンがヒートして　機体がどうしたって</p>

<p style="color: orange">気にもしない程に　トリップしてしまう大空は偉大さ</p>

# Introduction 
Linear regression is a typical regression task and supervised learning method. 
According to Andrew Ng, there we have 2 definitions:

1. **Supervised Learning**: Give the dataset of right answers, the system is used to make more "correct" answers
2. **Regression**: Predict _continuous_ value output

Example: Given a set of past house price, trying to predict the price in future.

## Main task

Linear regression is a system that predict the relations, and assume them as linear, with input data $\mathbf{x}$ and the result data $y$. Here, $\mathbf{x}$ is a row vector: $\mathbf{x}_d = [ x_1, x_2, x_3 ... x_d]^T$.
We have a learning function $f$ which gives a predicted value $f(\mathbf{x})$. Since we predict that $\mathbf{x}$ and $\mathbf{y}$ has linear relationship, we have:

$$
\begin{aligned}
f(\mathbf{x}) &= (w_1 x_1 + w_2 x_2 + ... + w_d x_d) + b \\

&= \mathbf{w}^T\mathbf{x} + b \\
&= [\mathbf{w} \ b]^T [\mathbf{x} \ 1] \\
&= \mathbf{w}'^T \mathbf{x}'

\end{aligned}

$$

Consider the input dataset of size $n$, we could re-organize our input and output data into more general matrix form:

$$

 \mathbf{y} = [y_1\ y_2\ ...\ y_n]^T \\
 
 \mathbf{x} = [\mathbf{x}_1^T\ \mathbf{x}_2^T\ ...\ \mathbf{x}_n^T]^T

$$


we can extend our predict function into:

$$

\begin{aligned}

\mathbf{f} &= \begin{bmatrix}

                  f(\mathbf{x}_1) \\
                  f(\mathbf{x}_2) \\
                  ... \\
                  f(\mathbf{x}_n)
                  \end{bmatrix}
              &= \mathbf{w}^T\mathbf{x}

\end{aligned}

$$

Where $\mathbf{w}$ is a $1 * (m+1)$ matrix, $\mathbf{x}$ is a $(m +1) * n$ matrix, $m$ is the number of features, $n$ is the number of dataset.

## Cost function

The task is to find a "best" linear function that could predict the future value. The question here is: how can we found the "best" linear function?
To solve this problem, we need to define a cost function (or error function) and minimize it. Here the cost is defined as the bias between predicted value and target value. It is very natural that we use the Euclid distance between predition and target value as the "cost" or "error" we want:

$$
  Cost(n) = | y^n - f(\mathbf{x}^(n)) |^2
$$

If we look at the whole feature space, we could extend the function into:

$$
  Cost(\mathbf{x}) = (\mathbf{y} - f(\mathbf{x}))^T(\mathbf{y} - f(\mathbf{x}))
$$

By simple linear algebra, we could easily tell that the square of a column vector, as matrix, is the transpose of vetor times itself.

Consider a dataset with $N$ data, we could extend the cost function into a more general mode:

$$
\begin{align}
  Cost(\mathbf{x}) &= \sum_{i=1}^{n} |y^{i} - f(\mathbf{x}_{i})|^2 \\
                   &= (\mathbf{y} - \mathbf{f})^T(\mathbf{y} - \mathbf{f})
  

\end{align}
$$







# Reference

1. [Machine Learning online course](https://www.coursera.org/learn/machine-learning) , Andrew Ng.



