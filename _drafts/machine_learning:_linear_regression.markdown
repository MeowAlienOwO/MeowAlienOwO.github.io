---
layout: post
title: "Machine Learning: Linear Regression"
categories: ['ML', 'algorithm']
tags: 
image: 
  feature: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=60323285
  credit: 和武はざの | シールダー
  creditlink: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=60323285
comments: 
---

Linear regression is one of the oldest method for statistics, also regarded as an guide algorithm for machine learning.
In this article, I will follow what I've learned in MLPR, with content talking about the algorithm itself, regularization, logistics regression (sigmoid function), Raditional Basis Function(RBF). Besides, I'll talk about some topic that we will come through all algoritms: overfitting, measure of performance.

# Introduction

Linear regression is a typical regression task and supervised learning method. 
According to Andrew Ng, there we have 2 definitions:

1. **Supervised Learning**: Give the dataset of right answers, the system is used to make more "correct" answers
2. **Regression**: Predict _continuous_ value output

Example: Given a set of past house price, trying to predict the price in future.

Linear regression is a system that predict the relations, and assume them as linear, with input dataset $\mathbf{x}$ and the result dataset $\mathbf{y}$. Here, $\mathbf{x}$ and $\mathbf{y}$ are column vectors, that is: $\mathbf{x}_d_ = \[ x_1, x_2, x_3 ... x_d\]$
We have a system $f$ which gives a predicted value $f((\mathbf{x}))$. Since we predict that $\mathbf{x}$ and $\mathbf{y}$ has linear relationship, we have 




# Reference

1. [Machine Learning online course](https://www.coursera.org/learn/machine-learning) , Andrew Ng.

