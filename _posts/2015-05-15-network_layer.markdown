---
layout: post
oldpage: true
title: "Network Layer"
date: "2015-05-15 16:41:05 +0800"
modified: 
description: "notes for network layer"
categories: [Computer Science, Network]
tags: [network layer, cs, notes]
image:
  feature: 50136576.jpg
  credit: ぱすた | 椿木 かえ [pixiv]
  creditlink: http://www.pixiv.net/member_illust.php?mode=medium&illust_id=50136576
comments: 
---

关于网络层的复习资料，T劣也要单纵干……听说放图能出船？总之捞到了云龙……


# 因特网协议(Internet Protocal)

数据流被分成包，包含一个头部储存需要的信息；包在网络传输中是被单独传输的，因此，传输的方向性往往由头部决定。
网络节点有可能暂时储存包，当然包也有可能会丢失，损坏，乱序。在目标处，信息被重新构建。

同时，分包有如下好处：

- 数据传输是间歇性的
- 不会浪费带宽
- 容易多元化，不同的数据可以在同一个连接中传输
- 包可以被几乎所有的载体输送

当然，分包也带来了头部信息冗余的负担。

对于IP服务而言，它不需要提供一些额外的服务。

- 不需要错误检查/校正，这是其他层级的功能
- 同一来源/同一数据源的包不一定遵循同一路径，只要包可以被顺利接受即可
- 数据可以乱序输送，接收方负责将其重新排序
- 包可以被丢失或者任意地延迟，接收方可以要求重新发包。
- 没有对网络拥挤的控制，发送方可以减慢发送频率，延迟，或者丢包。


## 头部的格式

在包中每32个比特作为一个单词(word)，包括头部跟数据。头部包含如下内容：

* Version(4)，现在是4
* Hlen(4)，头部中32字节长度单词的数量
* TOS(8)，服务种类，不常用
* Length(16)，数据段(报文，datagram)中的字节数量
* Ident(16)，被分割所使用
* Flags/Offset(16)，同样是分割所用
* TTL(8)，生存时间
* Protocal(8)，协议种类，比如说TCP = 6,UDP = 17
* Checksum(16)，头部的校验和
* DestinationAddr & SourceAddr(32)，源地址与目标地址

括号内表示比特位数

# IP地址

## IPv4
每32比特地址被分成两个部分，分别是前缀与后缀。

- 前缀(prefix):表示主机的物理网络
- 后缀(suffix):指定的物理网络的主机

前缀同全球有关，而后缀同本地有关。

前/后缀的大小决定了网络的数量与某个特定网络的主机数量。同样，不同的前后缀长度也决定了不同的网络层级数量。
前四位的比特为决定了地址的层级。

我们通常使用点表达法来表示IP地址。
比如：
10000001 00110100 00000110 00000000 为 129.52.6.0



### 五种层级

- A: 0+7位前缀+24位后缀
- B: 10+14位前缀+16位后缀
- C: 110+21位前缀+8位后缀
- D: 1110+多点传播地址
- E: 1111+储存供未来使用

### 无类别域间路由(Classless Inter-Domain Routing, CIDR)


CIDR（无类别域间路由，Classless Inter-Domain Routing）是一个在Internet上创建附加地址的方法，这些地址提供给服务提供商（ISP），再由ISP分配给客户。CIDR将路由集中起来，使一个IP地址代表主要骨干提供商服务的几千个IP地址，从而减轻Internet路由器的负担。

获取前缀的方法，通常是将IP地址与子网掩码按位AND。

通过子网掩码，我们可以把一些路由字段给分配到同一个空间下，比如说100.100.1.1,100.100.2.1，使用子网掩码255.255.0.0，我们可以将其看作一个路由地址100.100.0.0，从而达到了扩展路由空间，减轻路由器负载的效果。

## 32位地址的限制

32位地址本身有着极大的限制，$2^32$只有大约4亿的数量，而某些地址又被使用在特殊范围,在当前不同移动设备乃至物联网入网的情况下，IP地址的数量远远不够。

短期解决方案：

- Network Address Translation (NAT)
- Dynamically-assigned addresses(DHCP)

长期解决方案：

使用IPv6标准扩展地址空间

## IPv6

IPv6同IPv4一样是无连接的，拥有128位地址大小。但是IPv6的地址模式有所不同，有单播(unicast)，复播(multicast)，从(cluster)等。

IPv6的头部是扩展的，并且拥有额外的安全性。

## 分割(fragmentation)

每一个网络都有一些最大传输单位(Maximum Transmission Unit, MTU)。 Ethernet：1500 FDDI：4500

当路由接受到一个大小大于最大传输单位的报文时，需要进行分割处理。
段(fragment)在接收主机进行重编译(reassembly)，而所有的段在Ident部分有着相同的区分标记。
段是自包含(self-contained)的数据包。同样的,IP也不检测丢失的段。

通过调整头部的偏移量(offset)以及记录开始的比特位来确定段的分割。

## 动态主机配置协议(Dynamic Host Configuation Protocal, DHCP)

特殊的DHCP服务器为主机分配IP地址

新登录的机器广播一个DHCP发现(DISCOVER)包，然后DHCP服务器返回一个IP地址。

### 步骤：

1. 用户打开有DHCP客户端的机器，客户端机器广播一个DHCP DISCOVER包来寻找DHCP服务器，路由器将这个包传输到对应的DHCP服务器
2. 服务器接收到发现包，确定一个合适的地址，临时分配该地址给客户端。确定地之后，返回一个包含地址信息的OFFER包
3. 客户端发送REQUEST包，令服务器知道它要使用该地址
4. 服务器发送ACKNOWLEDGE包，确认该客户端可以在服务器所确定的时间内使用该地址

# 路由

## 发送(Forwarding) vs 路由 (Routing)

发送：

- 基于目标地址与路由表选择一个输出端口
- 发送表的一行包含一个从网络数字(networking number)到输出接口的映射，同时也有一些MAC信息

路由：

- 路由表是根据路由算法所构建的，作为发送表的准备
- 一般来说包含从网络数字到下一个跳转的映射

### 计算路由表

路由器需要知道如下两个东西：

- 哪个路由器来达到目标前缀
- 哪个接口连接该路由器

转换器解包到连接层，而路由器解压到网络层

路由算法往往是图的寻找任意两个节点之间的最短链接算法。
令c(x, y)为从节点x到y的成本，当他们不是邻居时，为无穷大

Dikstra算法， S是当前最短的路径，D(v)是从源地址到v的已知最短路径，C(w,v)是已知从w到v的成本
```python

Initialization:
  S = {u}
  for all nodes v
    if (v is adjacent to u)
      D(v) = c(u,v)
    else
      D(v) = infinity

Loop:Do
  find w not in s with the smallest D(w)
  add w to S
  update D(v) for all v adjacent to w and not in S:
    D(v) = min{D(v), D(w) + c(w,v)}
until all nodes in S

```

## 连接状态路由(link state routing)

每个路由追踪它的对应的路由，包括路由是上/下，以及连接的成本；广播当前的连接状态；运行Dijkstra算法来计算最短路径并且创建发送表。

### Bellman-Ford算法

1. 初始化：将除源点外的所有顶点的最短距离估计值 d[v] ←+∞, d[s] ←0;
2. 迭代求解：反复对边集E中的每条边进行松弛操作，使得顶点集V中的每个顶点v的最短距离估计值逐步逼近其最短距离；（运行|v|-1次）
3. 检验负权回路：判断边集E中的每一条边的两个端点是否收敛。如果存在未收敛的顶点，则算法返回false，表明问题无解；否则算法返回true，并且从源点可达的顶点v的最短距离保存在 d[v]中。 --百度百科

松弛操作：


单源最短路径算法中使用了松弛（relaxation）操作。对于每个顶点v∈V，都设置一个属性d[v]，用来描述从源点s到v的最短路径上权值的上界，称为最短路径估计（shortest-path estimate）。



## 距离矢量路由(distance vector routing)

每一个节点x维护如下状态：

c(x, v) = 从x到邻居v的直接连接成本
对于所有的节点y, 距离矢量Dx(y)（从x到y的最少成本）
对于所有的邻居节点，Dv(y)

节点x周期性的发送距离矢量Dx到邻居y，y据此更新他自己的距离矢量。

$Dv(y) = minx{c(v,x) + Dx(y)}}, for\ each\ node\ y \in N$

当要去节点m时，当前节点询问自己的邻居是否能达到m，当任意一节点收到询问请求时，检查自己的路由表，如果不能到达，同样询问邻居。
当有多个邻居返回时，取最小值。当自己的路由表根据以上信息更新时，通知自己的邻居。
