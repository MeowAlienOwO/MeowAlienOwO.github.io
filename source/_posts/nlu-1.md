---
title: "复习NLU:Introduction, Language Model"
date: 2019-05-04 21:13:03
tags: ['nlu']
categories: ['note']
# cover:
#   image: 'https://via.placeholder.com/728x546.png'
#   author: 'nlu1-author'
#   source: 'https://baidu.com'
---

# Introduction

Natural Language Understanding:

> Any computational problem that input is natural language, output is structured information of a computer can store/execute


## Computational Linguists with Deep Learning

> “Although current deep learning research tends to claim to
> encompass NLP, I’m (1) much less convinced about the strength of the results, compared
> to the results in, say, vision; (2) much less convinced in the case of NLP than, say, vision,
> the way to go is to couple huge amounts of data with black-box learning architectures.”
> Michael Jordan

目前而言，深度学习在比较 high-level 的 NLP 任务中，没有能够如同在视觉领域一样大幅度减小错误率(e.g. 25-50%)，而且似乎只有在相对纯粹的信号处理中，应用深度学习能够大幅度提高性能。    



## Language Model:

我们把语言模型认为是一种关于字符串的概率模型：

1. 语音识别：给定语音信号为条件
2. 机器翻译：给定另一种语言
3. 自动补全：给定一句话的前面若干词
...

> 给定一个有限的词汇表$V$, 我们定义一个概率分布：`$V^*\rightarrow\mathbb{R}_{+}$`

1. What is sample space? `$V*$`
2. What might be some useful random variables? sentence, i.e. sequence of words, each word is variable
3. What constrains must `$P$` satisfy? sequence of words <= product of prob of each word ,non-negative,sum to 1

### N-gram Model

我们令`$w$`为一个单词序列（句子），`$|w|=n$`表示这个序列的长度，`$w_i$` 表示第 i 个单词。这个序列的概率可以被
定义为(`$W_i$`表示单词在位置i处的随机变量)：

$$
\begin{align}
P(w) &= P(w_1, w_2, ... w_{n}) \\
     &= P(W_1 =w_1) \times \\
     &~~~P(W_2 = w_2|W_1 = w_1) \times\\
     &~~~ ...\\
     &~~~ P(W_n = w_n|W_{n-1}=w_{n-1}...)\\
     &= \prod_{i=1}^{n}P(W_i = w_i|W_{i-1}=w_{i-1}, W_{i-2}=w_{i-2}...W_1=w_1)\\
     &= \prod_{i=1}^{n}P(w_i|w_{i-1},w_{i-2}...w_1)\\
\end{align}
$$

这个式子使用条件概率定义了一个在无限空间上的联合分布，可以取的句子长度为任意值，但是我们仍然可以用条件概率来定义这个分布，每一个都有着有限的采样空间。

n-gram 模型是基于马尔科夫假设定义的语言模型：它假定在 i 处的单词的概率分布仅由之前的 n 个单词所决定：

$$
P(w_i|w_{i-1}, w_{i-2} ... w_1) = P(w_i|w_{i-1}, w_{i-2} ... w_{i-n})
$$

我们可以使用计数的方式来估计 n-gram 模型的分布：
$$
P(w_i | w_{i-1}, w_{i-2} ... w_{i-n}) = \frac{C(w_{i-n},...w_{i-1}, w_i)}{C(w_i)}
$$

由于单词的分布往往有着长尾特性，我们使用加一平滑 (add-one smoothing) 或者加`$\alpha$`平滑 (add-alpha smooting) 来处理计数，来保证所有的样本空间上的概率都不为0:

$$
P(w_i | w_{i-1}, w_{i-2} ... w_{i-n}) = \frac{C(w_{i-n},...w_{i-1}, w_i) + \alpha}{C(w_i) + \alpha|V|}
$$

其中当平滑系数`$\alpha$`取1的时候，为加一平滑。我们通常取一个相对数量级比较小的平滑系数来处理。其他的处理方法还有插值法等，暂时不讨论。

当我们有了一个语言模型后，我们可以根据之前的序列，使用最大似然(maximum likelihood)来推断下一个单词出现的概率:


$$
\hat{w}_{k+1} = \underset{w_{k+1}}{\operatorname{argmax}}P{w_{k+1}|w_1 ... w_k}
$$


### Language Model in translation

n-gram 模型尽管是一种经典的语言模型，在翻译上，它不起作用:

给定英文序列`$e =e_1,e_2...e_n$`，预测中文序列`$f=f_1,f_2...f_m$`, 我们会发现 n-gram 模型会遗忘以前的内容，但是这些内容很显然对翻译是非常重要的。就算我们将序列穿插：`$w = f_1 e_1 f_2 e_2 ...$`， 仍然有两个问题：1. 语言的顺序不一定一一对应 2. 长度未必相等。为了解决这个问题，人们提出了**对齐模型** (word alignment model)

#### IBM Model 1

$$
p(f, a|e) = p(I|J) \prod_{i=1}^{I} p(a_i | J) p(f_i |e_{a_i})
$$

其中，f 表示目标语言，e 表示源语言， a 表示目标语言对应的对齐目标， I 表示目标语言句子的长度， J 表示源语言的句子长度。我们可以将其看做一个零阶的 HMM 模型:`$p(a_i|J)$` 可以看做是状态转换概率，`$p(f_i|e_{a_i})$` 可以看做是触发概率，由于模型的转换概率不基于历史记忆(前一个状态)，这个马尔科夫链是0阶的。这个模型基于如下假设：

1. 目标句中，每个单词都由原句的某个单词产生
2. 对应关系作为隐变量 (latent variable)
3. 给定对齐 a，翻译的决策是独立的

注意这里我们对对齐的定义为：一个向量存储了位置的对应关系。对齐有如下几种关系：
1. Reorder 顺序不同
2. Word dropping 某些单词不翻译
3. Word Insertion 原句中需要一个 null token 来表示目标句中不存在的对应单词的情况
4. one-to-many 一个单词对应多个目标单词
5. many-to-one 一个目标单词对应多个源单词

举个例子：
> 虽然 北 风 呼啸，但 天空 仍然 十分 清澈。
> However, the sky remained clear under the strong north wind.

\(However-虽然， "," - ","， the-天空， sky-天空， remained-仍然, clear-\(十分，清澈\)， under-null， the-null， strong-呼啸， north-北， wind-风， "."-"。"\)

对齐向量为：\(1, 5, 7, 7, 8, \(9, 10\), 0, 0, 4, 3, 2, 11\)


我们模型的参数为：任意一组源语言-目标语言单词对的概率, 比如说`$p(north|北)$`，其期望一般用"北"与"north"对齐的次数与"北"与所有单词的对其次数的比值来表示。


我们可以用 EM 算法来训练对齐模型：
1. 随机初始化模型的参数
2. 使用现有的参数计算每种对齐的概率 
3. 使用期望，通过MLE计算新的参数
4. 迭代以上两步直至收敛

举例：
1. 大 房子 - big house
2. 清理 房子 - cleaning house

我们首先用均匀分布初始化参数，即源语言-目标语言对概率:

|          | 大  | 房子 | 清理 |
|----------|----|------|------|
| big      | 1/3 | 1/3 | 1/3 |
| house    | 1/3 | 1/3 | 1/3 |
| cleaning | 1/3 | 1/3 | 1/3 |

第一步E计算对齐的概率：
1. 大-big, 房子-house: 1/3 × 1/3 = 1/9
2. 大-house, 房子-big： 1/3 × 1/3 = 1/9
3. 清理-cleaning, 房子-house: 1/3 × 1/3  = 1/9
4. 清理-house, 房子-cleaning: 1/3 × 1/3 = 1/9

这一步，我们可以看出每种对齐的概率都是相等的1/2

第一步M, 我们需要根据给定的数据来计算参数矩阵。
首先，我们根据数据与对齐概率，计算每个单词对的期望

$$
\begin{align}
p(f_i|e_i) &= \frac{\sum_a p(a|f, e) * C(f_i, e_i)}{\sum_a p(a|f, e) C(f_i, \cdot)} \\
 &= \frac{\mathbb{E}[C(f_i, e_i)]}{\mathbb{E}[C(f_i, \cdot)]} 
\end{align}
$$

归一化后我们得到

|          | 大  | 房子 | 清理 |
|----------|----|------|------|
| big      | 1/2 | 1/2 | 0    |
| house    | 1/4 | 1/2 | 1/4 |
| cleaning | 0 | 1/2 | 1/2 |

第二步，我们使用上一步得到的矩阵进行进一步的E:

1. 大-big, 房子-house: 1/2 × 1/2 = 1/4 => 2/3
2. 大-house, 房子-big： 1/4 × 1/2 = 1/8 => 1/3
3. 清理-cleaning, 房子-house: 1/2 × 1/2  = 1/4 => 2/3
4. 清理-house, 房子-cleaning: 1/4 × 1/2 = 1/8 => 1/3

然后进行M：


|          | 大  | 房子 | 清理 |
|----------|----|------|------|
| big      | 2/3 | 1/3 | 0    |
| house    | 1/6 | 2/3 | 1/6 |
| cleaning | 0 | 1/3 | 2/3 |

可以看出， 大-big， 房子-house, 清理-cleaning 的概率是递增的，也就是最后会收敛到三个1


# Ref
http://www.shuang0420.com/2017/05/01/NLP%20%E7%AC%94%E8%AE%B0%20-%20Machine%20Translation/