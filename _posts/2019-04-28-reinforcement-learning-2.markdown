---
layout: post
title: "强化学习（二）：动态规划，蒙特卡洛法，时间差分"
categories: 
tags: 
image: 
  feature: 
  credit: 
  creditlink: 
comments: 
---

强化学习第二部分


# 动态规划

动态规划的基本思路是：将问题划分为可存储的子优化问题，通过解决子问题来最终解决父问题。
在强化学习中，由于MDP的贝尔曼方程的存在，我们可以很容易地将问题递归表示。

## 策略迭代

基本的动态规划算法为策略迭代。策略迭代分为两大部分：
1. 对策略的价值估计
2. 对策略的优化

具体而言，就是先用当前的策略进行价值估计得到$v_t$, 然后根据估计的价值来更新$\pi_t$，在下一时刻，使用更新后的策略继续估算价值。
价值估计与优化问题合起来被称为控制问题，这两部分是强化学习所重点关注的地方。

### Iterative Policy Evaluation 迭代策略估计

利用贝尔曼方程我们可以递归的计算$v_\pi$:
$$
v_{k+1}(s) = \sum_a \pi(a|s) \sum_{s', r} p(s' r | s, a)[r + \gamma v_k(s')]
$$

基本的算法为:

```
input policy pi
init array V[s]=0 for s in S

Repeat 
  delta := 0
  for each s in S:
    v := V(s)
    V(s) := sum_a(pi(a|s) * sum_s',r(p(s', r| s,a)[r + gamma V[s']]))
    delta := max(delta, |v - V(s)|)
until delta < theta
return V

```
TODO: 收敛性证明

### 策略优化
我们首先给出策略优化原理：

> 对于一个策略$\pi'$，如果对于所有的状态$s$都有$\sum_a \pi'(a|s) q_\pi(s, a) \geq \sum_a \pi(a|s) q_\pi(s, a) $


那么，策略$\pi'$就不坏于策略$\pi$。
对于任意的$v_\pi(s)$, 数值上，有$v_\pi(s) \leq q_\pi(s,\pi'(s)) \leq v_{\pi'}(s)$
后者可以通过期望式展开成序列形式为：$\leq \mathbb{E}[R_{t+1} + \gamma v_\pi(S_{t+1})|S_t = s] \leq \mathbb{E}_{\pi'}[R_t+1 + \gamma q_\pi(S_{t+1}, \pi'(S_{t+1}| S_t = s))]$
TODO: 详细证明

策略优化算法如下：

```
init V[s] in R and pi(s) in A(s) arbitrarily, for all s in S

# policy evaluation
Repeat 
  delta := 0
  for each s in S:
    v := V[s]
    V[s] := sum_s',r(p(s', r|s, a)[r + gamma * V[s']])
  until delta < theta
  
# policy improvement
Repeat
  policy-stable := true
  for each s in S:
    a := pi(s)
    pi(s) := argmax_a sum_s,r(p(s', r|s, a)[r + gamma V[s']])
  
    if a != pi(s) then policy-stable := false
  if policy-stable == true then stop; else goto evaluation
```

## 价值迭代

价值迭代与策略迭代的不同在于：策略迭代每次先进行evaluation,然后根据evaluation的结果选择动作，而价值迭代直接计算每一个动作的期望，根据期望来选取动作。

算法如下:


```
init array V abitrarily

Repeat
  delta := 0
  for each s in S:
    v := V[s]
    V[s] := max_a sum_s,r(p(s', r| s, a)[r + gamma * V(s')])
    delta := max(delta, |v - V[s])
  until delta < theta
  
  output deterministic policy pi, where
    pi(s) = argmax_a sum_s,r(p(s', r|s, a)[r + gamma*V[s']])
    
```


# Monte-Carlo Methods蒙特卡洛法

动态规划成立的前提是，我们知道环境动态函数$p$，而蒙特卡洛法是为了解决在没有环境动态函数的情况下进行强化学习的问题的统计学方法。

蒙特卡洛法是一种通过经验学习价值函数的方法，其中的经验有两种：
1. 实际经验，从环境中真实学习的经验。
2. 模拟经验，使用一个模型来近似真实的环境

在蒙特卡洛法中，价值$v_\pi$被定义成对回报的采样的平均数。

$$
v_\pi(s) \circeq \mathbb{E}[\sum_{k=0}^{T-1}\gamma^kR_{k+1}] \sim \frac{1}{\Epsilon(s)} \sum_{t_i \in \Epsilon(s)}\sum_{k=t_i}^{\gamma^{k-1}R^i_{k+1}}
$$

## 蒙特卡洛估计

蒙特卡洛有两种计算方法，当每个状态，动作的访问次数趋于无穷时，它们是等价的:
1. first-visit MC: 只考虑每个episode第一次访问到的(S, A) 对
2. every-visit MC: 对所有的(S, A)对进行采样

我们这里给出first-visit 的算法：

$$
Init:
  pi := policy to be evaluated
  V := arbitrarily init
  Returns[s] := [] for all s in S

Repeat forever:
  Generate an episode using pi
  for each state s in episode:
    G := return following first occurence of s
    Append G to Returns[s]
    V[s] := average(Return[s])
$$

蒙特卡洛法同样可以对动作价值进行估计：
$$
q_\pi(s, a) \circeq \mathbb{E}[G_t | S_t = s, A_t = a]
$$



## MC控制

采取贪婪策略进行动作选择满足策略优化定律，我们假设MC的迭代是无限的，给出蒙特卡洛控制算法：

```
Init 
  for all s in S, a in A:
    Q(s, a) := arbitrarily
    pi(s) := arbitrarily
    Returns(s, a) := []

Repeat forever:
  Choose S_0 in S, A_0 in A[S_0] as start point s.t all pairs have prob > 0
  Generate an episode according to pi
  For (s, a) in episode:
    G := return of s, a
    Append G to Returns(s, a)
    Q(s, a) := average(Returns(s, a))
  For each s in episode:
    pi[s] <- argmax_a Q(s, a**
`****

单纯的贪婪会使得更新参数变得很慢--很可能陷入某个局部最优然后不断强化，忽视探索其他动作，我们通常使用e-soft 策略来保证探索。e-greedy不改变期望。


## Off-policy 蒙特卡洛

estimate的时候的策略$$ 与目标策略$pi$ 不完全相等时，我们称该方法为off-policy方法。

使用蒙特卡洛法时，对于off-policy方法，我们的estimate期望将不基于目标Policy, 而是基于我们的估计策略的policy.
在这种情况下，我们可以将整个采样过程看做一个重要性采样，采样的分布是基于估计策略$u$的分布。
我们需要用**重要性系数**来修正期望：

$$
\rho_{t:T} = \prod_{k=t}^{T-1}\frac{\pi(A_k|S_k)}{u(A_k)|S_k}
$$

在重要性系数修正下：

$$
\mathbb{E}[\rho_{t:T}G_t|S_t = s] = v_\pi(s)
$$

由于重要性采样会导致方差存在上升至无限大的可能性(将重要性采样看做是在某一区间特别密集地取值)，我们还需要对采样的平均长度进行修正：

$$
\eta^{-1} = \sum_{t_i in \Epsilon(s)}\rho_{t:T}
$$

# 时间差分算法(Temporal-Difference)

最基本的时间差分算法(TD(0))可以看做每次仅仅往前方看一步进行evaluation。由于这种情况下我们没有办法获得整个序列的回报，我们用当前估计的期望来作为我们的Target。

## TD Evaluation 

最基础的TD Evaluation 算法(TD(0))如下，可以看出同MC方法相比，TD(0)最重要的改变是将更新公式中的累计回报换成了当前的奖励信号与当前估计的下一状态的期望之和:

```
input policy pi
step size 0 < alpha <= 1
init V[s] for all s in S, arbitrarily except V(terminal) = 0

for each episode:
  init S
  for each step in episode:
    A := action from pi(S)
    take action, observe R, S'
    V[s] := V[s] + alpha[R + gamma * V[S'] - V[S]]
    S := S'
  until S is terminal
```


TD算法的好处：首先，每次都要进行更新，避免了蒙特卡洛法需要迭代完整的一个episode再进行更新的问题，其次，需要的计算力与空间更少

## TD Control
根据是否on-policy, 我们可以将TD Control 分成两种算法:
1. SARSA: on-policy control
2. Q-learning: off-policy control

### SARSA

我们给出SARSA算法如下

```
Init 
  Q[s, a] for s in S, a in A, arbitrarily, Q[terminate, :] = 0

Repeat for each episode
  Init S
  Choose A from S using policy derived from Q
  Repeat for each step in episode
    Take action A, observe R, S'
    Choose A' fomr S' using policy
    Q[S, A] := Q[S, A] + alpha[R + gamma * Q[S', A'] - Q[S, A]]
    S := S'
    A := A
  Until S is terminal
```

SARSA有一种变种：不使用`Q[S', A]` 来进行更新，而是使用下一步状态的期望`sum_a (pi(S')Q(S', a))`来进行更新，其思路主要是通过期望计算来降低方差，从而提升学习效率。

### Q-learning 

Q-learning 使用 算法如下：

```
Init 
  Q[s, a] for s in S, a in A, arbitrarily, Q[terminate, :] = 0


Repeat for each episode
  Init S
  Choose A from S using policy derived from Q
  Repeat for each step in episode
    Take action A, observe R, S'
    Choose A' fomr S' using policy
    Q[S, A] := Q[S, A] + alpha[R + gamma * max_a (Q[S']) - Q[S, A]]
    S := S'
  Until S is terminal
```
注意，同MC Off-policy相比，这个方法不需要重要性系数。其原因是动作a此处是确定的(argmax(Q[S]))，而非随机变量。

## N-Step TD

N-Step TD 是在单步TD与MC方法中间的桥梁：

$$
G_{t:t+n} = \sum_{k=1}^{n}\gamma^{k-1}R_{t+k} + \gamma^n V_{t+n-1}(S_{t+n})
$$

在n-step TD的情况下，我们需要使用重要性系数来修正我们的off-policy算法的价值估计。
$$

Q_{t+n}(S_t, A_t) = Q_{t+n-1}(S_t, A_t) + \alpha \rho_{t+1:t+n}[G_{t:t+n} - Q_{t+n-1}(S_t, A_t)]

\rho_{t:h} = \prod_{k=t}^{\min(h,T-1)} \frac{\pi(A_k|S_k)}{u(A_k|S_k)}
$$


