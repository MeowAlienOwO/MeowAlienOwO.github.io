---
layout: post
title: "强化学习（三）"
categories: 
tags: 
image: 
  feature: 
  credit: 
  creditlink: 
comments: 
---

强化学习导论第三部分，planning, value function approximation, eligibility traces, policy gradient methods

# Planning

之前我们涉及到的强化学习方法中，DP是在$p$函数已知的情况下，其余的MC，TD都是通过统计方法来近似价值函数的期望，不需要一个先验的模型(model-free)。但是，在
许多情况下，我们有很多对模型的先验知识，如果抛弃这些先验知识可能会使得训练时间过长从而不实际。我们通过引入一个包含先验知识的模型来解决这个问题。

我们定义`计划`(planning)为使用模型，进行一系列动作规划的过程，根据这个定义，动态规划就是一种计划，因为其使用了$p$函数来描述环境模型。

对于模型而言有两种主要的分类：
1. 分布模型(distributional model): 解析地表示出给定的分布函数$p$
2. 模拟模型(simulation model): 生成一系列从模型的分布中采样的数据

实际而言，很多问题的分布模型很复杂或者无法用解析方法表示，在这种情况下，我们选用模拟模型。

## Dyna-Q
Dyna-Q 算法是一种将planning 与 learning结合起来的算法。其具体流程如下：

```
Init
  Q(s, a), Model(s, a) for s in S, a in A

Repeat forever:
  S := current state
  A := e-greedy(S, Q)
  Execute action A, observe R, S'

  # this step is direct RL:
  Q(S, A) := Q(S, A) + alpha[R + gamma * max_a(Q(S',a)) - Q(S, A)]

  # learning model
  Model(S, A).update(R, S') 

  # use model planning
  Repeat n times:
    S := random previously observed state
    A := random action previously taken in S
    R, S' := Model(S, A)
    Q(S, A) := Q(S, A) + alpha[R + gamma * max_a(Q(S', A)) - Q(S, A)]

```

Dyna-Q 算法的关键步骤大致分为三步：第一步，正常的通过RL方法更新动作价值函数$Q$；第二步，根据历史的经验，更新模型，这里单纯地记忆当前的模型的下一步的反馈；第三步，将过去的经验中，已经经历过的(s,a)对提取出来，使用模型计算该(s, a)对的下一状态与奖励，然后更新$Q$函数。

这里，我们重复一下模型，价值函数，策略之间的关系:
0. 通过价值函数与策略我们可以生成当前需要进行的动作
1. 在环境中执行动作(action)我们可以得到经验(experience)
2. 我们可以通过经验来优化我们的价值函数，或者策略
3. 经验同样地可以被用来进行模型的学习(model learning)
4. 根据学习后的模型，通过计划，我们同样可以得到价值函数或者策略


![](/images/3-planning-learning-relation.png)

Dyna-Q 相比普通的Q-learning，其提升在于: Q-learning一开始只会对经验过的policy进行更新；但是Dyna-Q利用的planning,可以继续生成一系列模拟的经验，从而有着更好的更新覆盖率。如果用机器人走迷宫的例子来说，第一个episode，只有终点的奖励，Q-learning只会更新终点前一格的价值；但是另一方面，通过planning，我们可以生成一系列的(s, a)对，从而对前面若干步的格子的价值函数进行更新。


另一方面，模型有可能是错的：环境可能改变，先验的知识也不一定符合现状。环境变化有两种可能性：一种是，环境变“坏”了，即我们当前的策略在新的环境下没有办法获取或者只能获取低水平的奖励；第二种是，环境变“好”了，我们的解依然能够获取同样水平的奖励，但是存在一个更优的解。在环境变坏的情况下，通过planning我们一般不能得到最优的policy，但是通过不断的exploit，模型能够发现这个这个解不是最优，从而慢慢找到更新的解。但是在环境变好的情况下，模型很难去发现更优的解法，而是会陷入在原有的策略中不断exploit。为了解决这个问题，我们需要平衡探索与exploit。

Dyna-Q+是一个变种的Dyna-Q算法。在这个算法中，我们用$R + k\sqrt{\tau}$来代替奖励信号，其中$\tau$是一个衡量上一次访问该状态距今的时间，$k$是控制平衡的系数。这种做法能够赋予那些长时间未访问的状态更高权重，从而让模型能够更新那些很久都没有访问过的状态的价值。

另一种Dyna-Q的变种Prioritized Sweeping Dyna-Q考虑从模型中选取状态的随机性问题。随机性容易产生很多无效的(s, a)对，在遍历这些状态的时候，我们的价值实际上不更新。换而言之，虽然planning扩展了更新价值的范围，但是这些扩展的范围仍旧局限在终点附近。对于每一步，我们将\[Target-OldEstimate\]这一项作为优先级，将我们的历史经验存储在优先级队列之中。选取模型的时候，我们从优先级队列中选取，并且将新生成的(s, a)对重新按照优先级放入优先级队列中。优先级系数有一个截断阈值$\theta$来控制。这种算法有着更优的模型收敛速度。


## Rollout Planning 
Dyna-Q的模型重用了历史经验，而rollout planning使用模型来模拟将来的轨迹(trajectory)。每个轨迹从当前状态出发来

我们给出前向更新的rollout算法：
```
Input 
  Model for simulation

Init Q(s, a) for all s, a

for t = (0, ...) do:
  S_t := current state
  for n times(n rollouts) do
    S := S_t
    while s non-terminal/within fixed length do:
      action A based on Q(S,:), with exploration # i.e. e-greedy
      (R, S') sample from Model(S, A)
      Q(S, A) := Q(S, A) + alpha[R + gamma * max_a(Q(S', a)) - Q(S, A)]
      S := S'

  Select action A_t greedly from Q(S_t, :)
```

这种算法下，如果模型是正确的且满足每个状态访问无限次，该算法能够学习到最优策略，反之如果模型不正确，则无法得到最优解。

我们给出反向更新的rollout算法，这个算法的目的是更好的利用奖励

```
Input 
  Model for simulation

Init 
  Q(s, a) for all s, a
  trace = [], stack

for t = (0, ...) do:
  S_t := current state
  for n times(n rollouts) do
    S := S_t
    # rollout
    while s non-terminal/within fixed length do:
      action A based on Q(S,:), with exploration # i.e. e-greedy
      (R, S') sample from Model(S, A)
      trace.push(S,A,R,S')
      S := S'

    # backprop
    while trace != [] do:
      (S,A,R,S') := trace.pop()
      Q(S, A) := Q(S, A) + alpha[R + gamma * max_a(Q(S', a)) - Q(S, A)]


  Select action A_t greedly from Q(S_t, :)
```

在走迷宫问题上，前向传播可以看做是这一次的奖励更新奖励点前最后一个状态与上一次的奖励更新前面所有状态的复合，而反向传播会直接用当前的奖励更新所有的状态。在这个意义上，反向传播有着较正向传播稍快的学习速度。

## Monte-Carlo Tree Search 蒙特卡洛树搜索

蒙特卡洛树搜索(MCTS)是一种更加通用，高效的rollout planner。
对于每一个状态，MCTS都被用于动作的选取。每次执行MCTS都是一个迭代过程，这个迭代过程模拟从当前状态触发到终止状态的轨迹/衰减率限制。
MCTS的核心是通过不断拓展当前状态的一部分在早期模拟中获得高回报(high evaluation)的轨迹，来集中在多个模拟上(原文比较难懂)
MCTS不保存从一个动作选取到下一个的近似价值函数或者策略。

自己的理解：MCTS存储一个部分的(partial)$Q$函数，每次MCTS会从最可能的那一个节点进行扩展。

![](/images/MCTS.jpg)


MCTS根据模拟的输出结果构造搜索树，由以下四个主要步骤组成：
1. 选择(selection): 从根节点开始，递归的选择最优的子节点直到叶节点(不同于终止状态)
2. 扩展(expansion): 如果选择的节点不是终止状态，则对这个节点进行扩展，创建这个节点的一个或者多个子节点
3. 模拟(simulation): 选取上步创建的一个子节点，从子节点开始使用默认的策略(default policy)来模拟，直到终止状态
4. 反向传播(back propagation):用模拟的输出结果，更新从根节点到扩展的子节点的价值

一般的MCTS算法如下：

```
Init
  S_0: init state 
  DefaultPolicy: default policy 
  Q: {v_0: S_0} MCTS tree with root node S_0

S := S_0
Repeat :
  v := node in Q s.t. state(v) = S
  while computationally possible:
    v_t := TreePolicy(v_0) # best polict by tree
    delta := DefaultPolicy(state(v_t))
    Backprop(v_t, delta)
  action A is BestChild(v_0)
  
```

在模拟这一部分，我们使用的是一个不同于Tree policy的策略。这个策略可以是最简单地随机策略，也可以使用一些启发式搜索或者多重模拟的平均。

### Upper Confidence Bounds for Trees(UCT) 上确界树
如果我们将选择步骤的每一层都看做多臂赌博机问题，我们可以选用不同的方法来平衡探索与收益。
UCT使用UCB来进行每一个子节点的选择。在这里，UCB公式可以写成如下形式:

$$
v_i + C \sqrt{\frac{\log N}{n_i}}
$$

其中$v_i$是节点的估计价值，$n_i$是节点被访问的次数，$N$是父节点被访问的次数，$C$是平衡系数。

## 在线/离线学习

RL同样有在线学习与离线学习两种。

在线学习:
1. 在真正的游戏执行之前，用MDP找到最优策略
2. 策略是完备的：对所有可能的状态,都能够找到最优策略
3. Use as much time as needed to find policy
Dyna-Q, DP
离线学习:
1. 在游戏中使用MDP寻找最优策略
2. 策略是不完备的：仅对当前的状态寻找最优策略
3. 有限的时间（e.g.下棋读秒）


# Value Function Approximation

对于非常巨大的状态空间而言，直接存储价值表是不现实的，我们自然就会想到使用一个函数$\hat{v}_\pi$来近似$v_\pi$，这样我们可以在有限的内存下仍然能够处理巨大的状态空间。
另一个问题是，相比较于状态空间，能获取的样本只是其中很小的一个部分，因此遍历所有的状态是不可能的。由这两个问题，我们引出近似价值函数。

我们的目标是，使用参数化的函数来近似价值表:

$$
\hat{v}(s, \mathbf{w}) \simeq v_\pi(s)
\hat{q}{s, a, \mathbf{w}} \simeq q_\pi(s, a)
$$

这带来两个好处：
1. 参数的数量一般而言远小于状态空间的大小
2. 泛化能力，一个参数的变化可以对应若干对应的状态/动作价值的变化

价值函数的学习一般而言通过有监督学习，我们使用一个状态-价值对来训练我们的函数：(S, U)
1. MC: U = G
2. TD(0): U = R + gamma * v(S', wt)
3. n-step TD: U = R + ... + gamma^n-1 Rn + gamma^n v(Sn, wn-1)

这种方法一般而言能够进行增量更新，以及能够处理噪音。

我们一般采取均方误差来作为我们的损失函数。

在损失函数可导的情况下，我们采用随机梯度下降来增量学习参数$w$
$$
\mathbf{w}_{t+1} = \mathbf{w}_t - \frac{1}{2}\alpha \nabla J(\mathbf{w}_t) = \mathbf{w}_t + \alpha [U_t - \hat{v}(S_t, \mathbf{w}_t) \nabla\hat{v}(S_t, ]\mathbf{w}_t)]
$$

对于MC而言，$\mathbb{E}[U|S]$是一个对$v_\pi$的无偏估计，我们可以放心使用；但是对于TD而言，由于其为bootstrap方法，$U$是一个有偏估计。
在这种情况下，我们使用半梯度(semi-gradient)。之所以叫半梯度是因为$U=R+\gamma\hat{v}(S,\mathbb{w})$跟$w$有关：

```
Input:
  pi: policy 
  v_hat: differenciable function , v_hat(terminal, :) = 0
  alpha: step size 
  w: weights, arbitrarily init

loop for each episode:
  init S
  for each step in episode:
    A chosen from pi(S)
    take action A, observe R, S'
    w := w + alpha[R+gamma v_hat(S', w) - v_hat(S, w)] d(v_hat(S,w))/dw
    S := S'
  until S terminal
  
```
在线性的情况下，只有一个最优：
- MC收敛至全局最优
- TD收敛至接近全局最优的不动点

我们通过coarse/tile coding 来抽取特征：
粗编码(coarse)将整个状态空间划分为重叠的若干子空间，每一个空间内的点点亮当前的子空间，并且同时点亮同该空间互相重叠的子空间--邻域，
在粗编码的情况下，我们可以仅仅对在状态空间内相邻的状态值进行更新。
片编码(tile)对状态点附近的一个方形区域进行切割，然后将该区域上下左右平移得到新的领域。


## 控制问题
同状态价值相似，我们可以直接写出动作价值的梯度表示，从而实现控制。在线性函数下，我们有:

1. SARSA: U = R + gamma q(S, A, w)
2. Q-learning: U = R + gamma max\_a q(S, a, w)
3. Expected SARSA: U = R + gamma sum\_a \pi(a|S) q(S, a, w)


# Eligibility Trace 资格迹

资格迹可以看做是另外一种MC/TD的插值方式。
在n-step中，我们逐步计算n步的奖励，之后的奖励用现在的v值近似。
n-step 存在的问题是：更新需要等待n步，有时太长了。
我们可以换一种思路：对不同的n的G值做加权平均，可以保证其价值函数的收敛性。

## TD(lambda)

TD(lambda)的基本思路是：对从当前时刻开始的所有G进行加权求和，使用一个指数权重来控制从当前时刻开始每一个时刻$t+k$的期望，我们称这个期望为lambda-return。

$$
G_t^{\lambda} = (1-\lambda)\sum_{n=1}^{\infty}\lambda^{n-1}G_{t:t+n}
$$

这个公式可以写成如下形式，以方便我们观察Termination：

$$
G_t^\lambda = (1-\lambda)\sum_{n=1}^{T-t-1}\lambda^{n-1}G_{t:t+n} + \lambda^{T-t-1}G_t
$$

我们可以认为这个式子截断了n步以后的情形，以后项来代替截断后的期望。可以看出，lambda项等于0的时候相当于TD(0), 等于1的时候相当于MC方法。
线下的lambda-return算法的更新公式为：$\alpha[G_t^\lambda-\hat{v}(S_t,\mathbb{w_t})]\nabla\hat{v}(S_t,\mathbb{w}_t)$

### 前向与后向解释
TD(lambda)的前向视角就是lambda-return的视角：向前看若干步，然后进行lambda加权平均。
> 对于每个访问到的state，我们都是从它开始向前看所有的未来reward，并决定如何结合这些reward来更新当前的state。每次我们更新完当前state，我们就到下一个state，永不再回头关心前面的state

我们来更形象地表述一下后向视角的过程：每次在当前访问的状态得到一个误差量的时候，这个误差量都会根据之前每个状态的资格迹来分配当前误差。这就像是一个小人，拿着当前的误差，然后对准前面的状态们按比例扔回去。
TD(λ)的后向视角非常有意义，因为它在概念上和计算上都是可行而且简单的。具体来说，前向视角只提供了一个非常好但却无法直接实现的思路，因为它在每一个timestep都需要用到很多步之后的信息，这在工程上很不高效。而后向视角恰恰解决了这个问题，采用一种带有明确因果性的递增机制来实现TD(λ)，最终的效果是在on-line case和前向视角近似，在off-line case和前向视角精确一致。


## 资格迹
引入一个同每个状态都相关的变量$z$，在每一个episode的时候初始化为0，以$\gamma\lambda$为衰减率，对每一个时刻的梯度进行加权:

$$
\mathbb{z}_{-1}=0
$$

$$
\mathbb{z}_t = \gamma\lambda\mathbb{z}_{t-1} + \nabla \hat{v}(S_t, \mathbb{w}_t)
$$

资格迹可以看做对权重更新的平滑：当参数更新时，其与历史累计的更新幅度加载一起；当没有激活参数的更新时，之前的更新会慢慢回落至0。
从另一种角度看，当资格迹不作用于参数化函数时，可以看做一个梯度恒为定值的函数。

根据前述的半梯度TD，我们引入Semi-Gradient TD(lambda)算法：
```
for each episode:
  Init S
  z := 0
  for each step in episode:
    A chosen by pi
    take action A, observe R, S'
    z := gamma * lambda * z + dv(S,w)/dw
    delta := R + gamma * v(S', w) - v(S, w)
    w := w + alpha * z *delta
    S := S'
  until S terminal
```
其中， lambda称为衰减率。

### Online算法

在线的lambda-return算法实际上使用截断的lambda-return：
$$
G_{t:h}^\lambda = (1-\lambda)\sum_{n=1}^{h-t-1}\lambda^{n-1}G_{t:t+n} + \lambda^{h-t-1}G_{t:h}
$$
这个算法可以看做是长度为定值的lambda-return算法，我们将整个轨迹在h处截断，后面的概率使用截断后一个时间点的期望$\lambda^{h-1}G_{t:h}$来替代





# Policy Gradient

同Value Approximation 类似，Policy Gradient 将策略参数化，从而学习到更优的策略。
$$
\pi(a|s, \theta) = Pr{A_t = a| S_t = s, \theta_t = \theta}
$$

Policy Gradient的优点:
1. 更容易收敛到局部最优
2. 在高维与连续的动作空间有更好的表现
3. 可以学习到随机策略


对于离散的动作空间，我们通常使用softmax来描述动作的概率；而对于连续的动作空间，可以使用高斯分布来描述。

我们优化的目标可以是初状态的价值期望：
$$
J(\theta) \circeq v_\pi_\theta(S_0)
$$
或者，如果是连续性的任务，可以优化平均奖励：
$$
J(\theta) \circeq \sum_s P_\pi(s) \sum_{a}\pi(a|s, \theta)\sum_{s', r}p(s',r|s,a)r
$$

## 策略梯度定理

对于任意的可微策略$\pi$，策略梯度为
$$
\nabla J(\theta) = \sum_s d_\pi(s) \sum_a q_\pi(s, a) \nabla \pi(a|s, \theta)
$$
其中，$d_\pi(s)$是在策略$\pi$下的on-policy分布。
- 对于初始状态而言我们有：$d_\pi(s)=\sum_{t=0}^{\infty}\gamma^t Pr\{S_t=s|s_0, \pi\}$
- 对于平均回报我们有：$d_\pi(s) = \lim_{t\rightarrow \infty} Pr\{S_t = s |\pi\}$

我们在这里不需要推导环境的动态函数$p$。

$$
\begin{aligned}
\nabla J(\theta) &= \sum_s d_\pi(s) \sum_a q_\pi(s, a) \nabla \pi(a|s, \theta) \\
                 &= \mathbb{E}_\pi[\sum_a q_\pi(s, a) \nabla \pi(a|s, \theta)] \\ 
                 &= \mathbb{E}_\pi[\sum_a \pi(a|s, \theta) q_\pi(s, a) \frac{\nabla \pi(a|s, \theta)}{\pi(a|s, \theta)} ]_\\
                 &= \mathbb{E}_\pi[q_\pi(S_t, A_t)\nabla \ln(\pi(A_t|S_t, \theta))]
\end{aligned}
$$
注意此处对不同的时刻取期望值，我们的更新迭代公式可以写成：

$$
\theta_{t+1} = \theta_{t} + \alpha(q_\pi(S_t, A_t)\nabla \ln\pi(A_t|S_t, \theta))
$$

在这里，我们有两个任务要完成：
1. 计算或者近似策略函数的导数
2. 近似策略$q$

为了避免选择无法反应状态之间的量级差异，我们有时会将其与baseline进行比较，在这里我们有：

$$
(q_\pi(S_t, A_t) - b(S_t))\nabla \ln \pi(A_t|S_t, \theta)
$$

这个baseline 不会改变期望，但是可以降低方差。

我们给出基于策略梯度定理与baseline的蒙特卡洛更新算法:

```
Var:
  pi(a|s, theta): differenciable policy
  v(s, w): differenciable state-value function
  a_t, a_w: step size parameters, greater than 0

init policy parameter and state-value weights randomly

for each episode(forever):
  generate episode by pi
  for each step in episode:
    G := sum_(k=t+1:T)(gamma^k R_k)
    delta = G - v(S_t, w)
    w := w + a_w * delta * dv(S_t, w)/dw
    theta := theta + a_t * gamma^t * delta * d(ln(pi(A_t|S_t, theta)))/dtheta
```

## Actor-Critic Methods
上述基本算法由于采用了蒙特卡洛法，同样会有蒙特卡洛法的问题：直到一个episode完了才能进行更新，导致学习很慢。
这里，我们使用同样的将蒙特卡洛换成TD的思路，给出Actor-Critic 方法。

$$
\theta_{t+1} = \theta_{t} + \alpha [R_t + \gamma v(S_{t+1}, w) - v(S_t, w)]\nabla \ln\pi(A_t|S_t, \theta)
$$

具体算法如下：

```
Var:
  pi(a|s, theta): differenciable policy
  v(s, w): differenciable state-value function
  a_t, a_w: step size parameters, greater than 0

init policy parameter and state-value weights randomly

for each episode:
  Init S
  I := 1
  for each step in episode:
    A from pi
    take action A, observe S', R
    delta := R + gamma * v(S', w) - v(S, w)
    w := w + a_w * delta * dv(S, w)/dw
    theta := theta + alpha * delta * I * d(ln(pi(A|S, theta)))/dtheta
    I := gamma I
    S := S'
  until S terminate

```

