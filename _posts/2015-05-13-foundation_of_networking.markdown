---
layout: post
title: "Foundation of Networking"
date: "2015-05-13 16:59:52 +0800"
modified: 
description: "Note for network module 1"
categories: [Computer Science, Network]
tags: [network, cs]
image: 
  feature: 46203097.jpg
  credit: 「新しい北上…それがアタシ」 | 青い人 [pixiv]
  creditlink: http://www.pixiv.net/member_illust.php?mode=medium&illust_id=46203097
comments: 
---


考砸了不开心…………………………………………食我酸素鱼雷啦

这个照旧是网络的笔记……John个大坑比……




# 网络基础

## 何为网络(Network)

网络是在节点之间传输数据的一种结构。

- 节点是多种多样的
- 节点的数量必须多余两个

网络由如下设备组成：

- 计算设备(computing devices)：主机，终端系统。主要用于运行网络应用。
- 传输连接(communication links)：光纤，卫星，广播器等。
- 分组交换器(packet switches)：用于传输信息，有路由器(router)与交换器
  (switch)两种。

互联网：网络的网络，由协议与标准来定义信息的传输。

## 互联网协议(protocals)

互联网协议控制网络信息的发送与接受。协议定义了网络实体之间的信息传输*格式*，
*顺序*与对信息传输的*行动*。

## 主机(host)

主机以包(packets)的形式传输信息。算法如下：

1. 取得需要传输的信息
2. 将其截成定长为$L$的小段(chunks)，称之为包(packet)
3. 将包以某个传输比率(transmission rate)$R$传输至网络

传输比率又称连接容量(link capacity)，连接带宽(link bandwidth)，计算公式如下：

$time\ need\ to\ transmit\ L\ bit\ packet\ into\ link = \frac{L(bits)}{R(bits/sec)}$

## 物理媒体(Physical Media)

比特(bit)：在发送者与接收者之间传输

物理链接(physical link)：连接发送者与接收者的物理材料

导向媒体(guided media)：传输信号的固体媒体，比如铜导线，光纤，同轴电缆

无导向媒体(unguided media)：信号可以自由传播。比如广播。

## 网络核心(network core)

网络核心由一些互相链接的路由器所构成。当主机将应用层的信息转换成包后，将其传输至网络，交给路由器处理，
路由器将收到的包传到下一个路由器。每个包的传输都使用全部的带宽。


## 网络结构

终端系统通过网络服务提供商(Internet Serveice Providers)连接到网络。所有的ISP必须互相之间链接，
这样才能做到路由器之间的通讯。

我们不能将所有的ISP一一相连，这样我们会有$O(n^2)$的连接数目，难于管理。于是出现了ISP的ISP。
但是，不同的高阶ISP又会带来竞争，为了防止竞争造成无法链接的情况，出现了广域网交换点$Internet Exchange Point, IXP$。
同样的，在连接到高阶ISP之前，ISP们之间先组成各种局域网(Regional Network),再通过这些局域网同广域网相连接。同时，如Google, Microsoft之类的内容提供商可以自己组建自己的网络，
使得他们的服务更加快捷地同终端用户相连接。这些网络被称作内容提供网络(content provider network)。

网络的层级如下：

1. 一级网络服务提供商(Tier 1 ISP)与内容提供网络(Content Provider Network)
2. 广域网交换点(IXP)
3. 区域ISP
4. 入口ISP



## 封包交换/分组交换(Package switching)

分组是由一块用户数据和必要的地址和管理信息组成，保证网络能够将数据传递到目标。类似于从邮局发送的包裹上注明的地址一样,只有提供给网络这些信息，网络（邮局）才能把分组（包裹）往正确的地址传送。

分组通过最佳路径(取决于 路由算法)路由到目标。但并不是所有在相同两个主机之间传送的分组（即使是来自同一消息的那些分组）一定要沿着相同的路径传送。

一个数据连接通常传送数据的分组流，它们将不必全部以相同的方式路由过物理网络。目的计算机把收到的所有报文按照适当的顺序重新排列，就能合并恢复出原来的内容。

存储与传输(store-and-forward)：整个包必须在传输到下一个连接之前到达一个路由器。
终端-终端延迟在理想状况下为$2L / R$。

### 队列与丢包

如果路由器的包到达速率超过了其传输速率，那么会发生两种情况：

- 包被存储在队列中等待，或者
- 当队列存储容量满了以后，包会丢失(dropped)


### 两个关键的的网络核心功能

路由(routing):决定包的源地址路由器

传输(forwarding):将包从路由的输入转换到正确的输出

### 另一种核心：电路交换(circuit switchingaohu)

根据
[维基百科](http://zh.wikipedia.org/wiki/%E7%94%B5%E8%B7%AF%E4%BA%A4%E6%8D%A2
"电路交换")的解释，电路交换是在两个通信终端之间建立起一个连接，
双方通过这条通道进行信息的交换。这个连接一直保留到双方的通信结束，在通
信结束之前，连接将始终被占用。这种方式常用在传统的电话网络中。

#### 电路交换的频分多路复用(FDM)与时分多路复用(TDM)

频分多路复用(Frequency-division multiplexing)指的是将不同的信息编码至
不同的频率段，从而使得同时可以有多个用户进行通信的技术。频分多路复用在
现代的通信中应用相对较少

时分多路复用(Time-Division Multiplexing)指的是将时间域分成固定的小段，每个小段分配给某个固定的用户
进行通信的技术。典型应用有GSM。

### 封包交换 vs 电路交换

电路交换的最大缺陷是能够服务的用户数量有限，而封包交换往往可以服务更广的用户。


封包交换的优势在于可以共享通信资源以及更加简单(不需要初始化连接)。
但是，封包交换同样存在着延迟与丢包的问题，在需要可信的数据传输的时候，这种方式并不是最好选择。


### 丢包与延迟的来源

#### 丢包

路由器使用队列来储存包的请求，当接受速率大于传输速率时，包会被储存进路由器的队列中。当队列容量满时，这时候便无法接受数据包，造成丢包。

#### 延迟

对于单路由节点而言，延迟的来源有四个：

- 节点处理过程(nodal processing)：包含比特错误校验(check bit errors)，确定输出连接等，通常小于毫秒量级
- 队列延迟(queueing delay)：等待输出连接的传输时间，由当前连接的拥挤程度而决定
- 转换延迟(transmission delay)：将数据输入传输连接的时间，计算方式为$d_{trans} = L / R$,$L$表示包长度，$R$表示带宽
- 传输延迟(propagation delay):数据在连接媒体之间传输的时间，计算方式为$d_{prop} = d / s$，$d$表示物理连接的长度，$s$表示传输速度的中位数

计算延迟的公式为：

$d_{nodal} = d_{proc} + d_{queue} + d_{trans} + d_{prop}$


## 层级

### 网络协议层级栈

1. 应用层(application)：支持网络应用，如FTP, SMTP, HTTP等
2. 传输层(transport)：进程-进程(process-process)之间的数据传输，TCP，UDP
3. 网络层(network)：路由相关，如IP，路由协议
4. 连接层(link)：在相邻网络元素之间的数据传输，如以太网(Ethernet),802.111协议，PPP等
5. 物理层(physical)：二进制数据

### ISO/OSI七层模型

在网络协议层级的应用层与传输层之间加入了表示层与会话层。

1. 表示层(presentation)：允许应用解释数据的意义，比如加密，压缩，机器特定的约定，等
2. 会话层(session)：同步，校验点(checkpoint)，从数据交换中恢复等等

一般而言，这两个层级被认为并非绝对必要，且属于应用层的实现。


