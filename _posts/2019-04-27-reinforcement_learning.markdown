---
layout: post
title: "强化学习导论（一）"
categories: ['machine learning', 'RL']
tags: 
image: 
  feature: 
  credit: 
  creditlink: 
comments: 
---

强化学习导论的学习内容, 包含上课内容与其他自己找的资料，主要是复习用


# 什么是强化学习

> 通过与环境的持续交互学习，从而解决序列性的决策问题。

强化学习是机器学习的一个分支，其特点为：
1. 没有监督数据，只有奖励信号
2. 奖励信号不一定是实时的
3. 行为与环境交互 影响数据
4. 时间是一个重要因素 <- ?

我们定义智能体(agent) 作为强化学习的主体，其能通过动作(action)与环境(environment)交互，从而获取奖励信号(reward)，或者说反馈。
智能体在环境中进行序列性的决策，从而提高累计奖励(accumulate reward)

## 强化学习的一些挑战

1. 环境未知：有的时候我们无法解析地，或者无法有足够的数据来对环境的状态与奖励进行建模
2. 探索-采集(exploration-exploitation) 问题：我们需要平衡探索（通过交互获取更多的环境信息）与采集（e.g.贪婪获取更优的奖励）
3. 延迟奖励：有些奖励同历史动作相关联

# 多臂赌博机 Multi-Armed bandit problem

多臂赌博机问题是一个最基本的强化学习问题：给定$k$个赌博机，每个时刻$t$可以选择一个赌博机进行操作，从而获取一个标量奖励。每一个赌博机的奖赏分布都是独立的不同分布。
获取的奖励$R_t$是一个随机变量。我们定义$q_{*}(a)$为进行动作$a$的奖励期望：

$$
q_{*} = \mathbb{E}[R_t|A_t = a]
$$

为了求得该期望我们可以进行动作价值估计: $Q_t(a) = q_{*}(a)$。最基本的估计使用如下公式:

$$
Q_t(a) = \frac{1}{N_t(a)}\sum_{\tau=1}^{t-1}R_{\tau}[A_{\tau}= a]_1
$$

即选取动作$a$的时候，采样的相对应的奖励的平均值。我们可以将$Q$写成递归形式来方便之后的讨论：

$$
Q_{n+1} = Q_n + \frac{1}{n}[R_n - Q_n]
$$



根据我们的估计期望$Q$，我们有贪婪算法$A_t^{*} = \arg\max_a Q_t(a)$来选取最佳的动作。根据动作是否贪婪，我们可以将动作分成两部分：
1. 贪婪动作->采集
2. 非贪婪动作-> 探索
## $\epsilon$-greedy 
为了平衡搜索与采集，我们给定一个探索概率$\epsilon$, 即每次选取动作的时候我们有概率$\epsilon$随机选取概率，反之则采取贪婪算法。易得在该条件下，我们有$1-\epsilon + \frac{\epsilon}{|\mathcal{A}|}$的概率来选择贪婪动作。$\epsilon$ 用于调整探索与采集的平衡。

## 强化学习的一般更新规则

根据上述的递归形式，我们不假证明地给出一般的更新规则：

NewEstimate <- OldEstimate + StepSize[Target - OldEstimate]

其中，Target并不固定为单纯的奖励信号。

## 多臂赌博机算法
### e-greedy 单多臂赌博机算法
```
init, for a = 1 to k:
  Q(a) <- 0
  N(a) <- 0
loop forever:
  A <- 1. argmax_a Q(a) 1 - $\epsilon$
       2. random a      $\epsilon$
  R <- bandit(A)
  N(A) <- N(A) + 1
  Q(A) <- Q(A) + \frac{1}{N(A)}[R - Q(A)]
`****
### 非平稳过程
我们之前假设动作价值是不变的，但是在实际中，动作价值可能会随着时间的改变而改变(non-stationary)。在这种情况下，我们不能采样求平均，而是需要用step-size parameter 来控制取一段时间的平均
$$
Q_{n+1} = Q_n + \alpha[R_n - Q_n], \alpha \in (0, 1]
$$

### UCB
上确界动作选取(upper confidence bound, UCB法不对动作价值进行估计，而是估计动作价值的**上确界**来进行动作选取。该方法的好处是，将不确定性也一并纳入估计。
上确界的动作选取法如下：

```
A_t = 1. a if N_t(a) = 0,
      2. argmax[Q_t(a) + c Sqrt(log(t)/ N_t(a))]
``**
其中，平凡根项是对不确定性或者说方差的一个度量。c 是一个可控制的常量，用于控制不确定性影响的大小。

UCB 一般而言有更好的性能，但是对于非平稳过程的处理不像e-greedy那么简单。

### Gradient bandit 

梯度法是一种不通过直接估计动作价值$Q$，而是直接优化动作选取的策略(policy)的强化学习方法。

我们定义$\pi_t(a)$ 为时刻$t$的动作选取策略。$\pi_t(a)$是关于当前状态动作选取概率的分布，我们可以用随机梯度上升法来优化（前提是：策略是一个可微分的函数）。

定义策略为softmax函数:

$$
\pi_t(a) = \frac{e^{H_t(a)}}{\sum_{b=1}^{k} e^{H_t(b)}}
$$

其中$H_t(a)$ 定义为对动作的偏好度(preference)，从而影响动作的概率。
根据softmax函数的导数我们有:

$$
H_{t+1}(a) = H_t(a) + \alpha(R_t - avg R)([a = A_t] - \pi_t(a))
$$

# Markov决策过程

我们把交互的环境看作是一个马尔科夫链：时刻$t+1$的状态与奖励仅与前一个时刻$t$的状态与采取的动作有关。据此定义马尔科夫决策过程(Markov Decision Process, MDP):
1. 状态空间$\mathcal{S}$
2. 动作空间$\mathcal{A}$
3. 奖励空间$\mathcal{R}$

$$
Pr\{S_{t+1}, R_{t+1} | S_t, A_t, S_{t-1}, A_{t-1},...S_0, A_0\} = Pr\{S_{t+1}, R_{t+1} | S_t, A_t\}
$$

MDP是有限的当且仅当$\mathcal{S}$, $\mathcal{A}$, $\mathcal{R}$ 是有限的。

## 环境动态

我们定义函数$p:: \mathcal{S} \times \mathcal{A} \rightarrow \mathcal{S} \times \mathcal{R}$为MDP的环境动态(Environment Dynamic)。这个函数实际上定义为状态$s'$, 奖励$r$在给定状态$s$, 采取的动作$a$的条件概率分布，即MDP的状态之间是如何转化的。
$$
p(s', r|s, a) = Pr{S_{t+1}=s', R_{t+1}=r | S_t = s, A_t = a}
$$

根据动态函数p, 奖励$r$的边缘概率即为状态$s'$的概率分布
$$
p(s'|s, a) = \sum_{r\in \mathcal{R}} p(s', r|s, a)
$$

我们定义函数$r:: \mathcal{S} \times \mathcal{A} \rightarrow \mathcal{R}$ 为给定状态$s$, 动作$a$下的奖励期望:

$$
r(s, a) = \mathcal{E}[R_{t+1} | S_t = s, A_t = a] = \sum_{r\in\mathcal{R}} r\sum_{s'\in S} p(s', r| s, a)
$$

MDP可以被表示成一个有限状态自动机， 见 Sutton书Example 3.3

## 目标与奖励

如前面所述，强化学习的目标实际上是尽可能多的提升累计奖励(cumulative return)。这个目标建立在**奖励假设** (reward hypothesis)上：

> 强化学习目标是最大化标量奖励信号的累计期望

根据这个假设，我们认为奖励信号实际上定义了我们的目标。奖励信号不说明如何实现目标，但是如果奖励信号设计的好，我们的学习将会提速。
奖励信号与状态空间的设计都被认为是RL中的“工程”部分。

## 回报

我们定义 **回报** (return)为奖励信号序列$R_{t}, R_{t+1}, R_{t+2}...$的一个函数，通过最大化该函数来实现我们的目标。最简单的回报函数就是线性加和：

$$
G_t = R_{t+1} + R_{t+2} + ... + R_{T} = R_{t+1} + G_{t+1}
$$

其中$T$是中止时间。以上的定义在有限步骤的情况下是成立的，但是在连续(非停止)情况下，我们可以使用一个衰减概率来控制我们求和的范围:
$$
G_{t} = R_{t+1} + \gamma R_{t+2} + \gamma^2 R_{t+3} + ... = \sum_{k=0}^{\infty} \gamma^k R_{t+1+k}
$$

当$\gamma < 1$, 求和有上界:

$$
\sum_{k=0}^{\infty} \gamma^k R_{t+1+k} \leq r_{\max} \sum_{k=0}^{\infty}\gamma^k = r_{\max} \frac{1}{1-\gamma}
$$

## 价值函数

给定策略$\pi$, 我们可以计算在该策略下，每一个状态的价值$v_{\pi}(s)$:
$$
v_{\pi}(s) \circeq \mathbb{E}_{\pi}[G_t | S_t = s] = \mathbb{E}_\pi[\sum_{k=0}^{\infty} \gamma^k R_{t+k+1}| S_t = s]
$$
同理，我们可以计算给定状态的动作价值$q_\pi$:
$$
q_{\pi}(s, a) \circeq \mathbb{E}_{\pi}[G_t| S_t = s, A_t = a] = \mathbb{E}_{\pi}[\sum_{k=0}^{\infty}\gamma^k R_{t+k+1} | S_t = s, A_t = a]
$$

(PPT此处有一个直接求序列空间价值函数的东西，感觉没什么用就不写了，基本就是对每一个可能序列的概率进行求和，一个序列的概率是p函数与$\pi$函数的累乘)

## Bellman方程

根据Markov性质，下一时刻的状态-奖励对由且仅由这一时刻的状态与采取的动作决定，也就是说我们可以递归地更新我们的价值函数。我们将价值函数写成递归的形式:

$$
\begin{aligned}
v_\pi(s) & \circeq \mathbb{E}_\pi[G_t | S_t = s] \\
         & = \mathbb{E}_\pi[R_{t+1} + \gamma G_{t+1} | S_t = s]\\
         & = \sum_a \pi(a|s) \sum_{s', r} p(s', r | s, a)[r + \gamma \mathbb{E}_\pi[G_{t+1} | S_{t+1}=s']]\\
         & = \sum_a \pi(a|s) \sum_{s', r} p(s', r | s, a)[r + \gamma v_\pi(s') ]
\end{aligned}
$$


同理，我们可以写出动作价值函数的递归形式:

$$
\begin{aligned}
q_\pi(s, a) & \circeq \mathbb{E}_\pi[G_t | S_t = s, A_t=a] \\
            & = \sum_{s', r} p(s', r | s, a)[r + \gamma v_\pi(s')]
\end{aligned}
$$

以上两个函数被称为贝尔曼方程(bellman equation)

### 最优策略贝尔曼方程

我们用价值函数(期望)比较两个策略的好坏：当且仅当策略$\pi$每一个状态的期望价值都不低于另一个策略$\pi'$时，我们可以认为$\pi$有着更优的表现。如果存在一个策略，其对于所有可能的策略都是更优的，我们称该策略为最优策略(optimal policy)

一个策略$\pi$是最优的，当：

1. $v_\pi(s) = v_{*}(s) = \max_{\pi'}v_{\pi'}(s)$
2. $q_\pi(s, a) = q_{*}(s, a) = \max_{\pi'} q_{\pi'}(s, a)$

在最优策略下，我们可以用最优的动作来替代策略下的条件分布：

$$v_{*}(s) = \max_{a} \sum_{s', r} p(s', r|s, a)[r + \gamma v_{*}(s')]$$

$$q_{*}(s, a) = \sum_{s', r} p(s', r|s, a)[r + \gamma \max_{a'} q_{*}(s', a)]$$

对于有限的MDP与non-terminate episode而言，每个策略$\pi$都会遍历状态空间，空间中的每个状态理想情况下都会被访问无限次。
我们定义时间趋于无穷时，状态的分布为平稳状态分布$P_\pi(s) = Pr\{S_t = s, |A_0, ..., A_{t-1} \sim \pi \}$。 
此时，我们使用平均奖励(average reward)来评价策略的价值:

$$
\begin{aligned}

r(\pi) &= \lim_{h \rightarrow \infty} \frac{1}{h} \sum_{t=1}^{h} \mathbb{E}[R_t | S_0, A_0, ...]

       &= \sum_{s} P_{\pi}(s)\sum_a \pi(a|s) \sum_{s', r} p(s', r\|s, a) r

\end{aligned}
$$

最大化在平稳状态分布下的回报等同于最大化平均奖励。

# Ref

1. https://zhuanlan.zhihu.com/p/28084904
2. Sutton, An Introduction To Reinforcement Learning
