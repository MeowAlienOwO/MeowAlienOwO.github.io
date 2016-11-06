---
layout: post
title: "linux"
date: "2016-11-06 10:09:07 +0800"
categories: [linux]
tags: [linux]
image:
  feature: http://og78s5hbx.bkt.clouddn.com/59740832_p0_press.jpg
  credit: 【FGO】「赤王」Nero ネロ② | @CLare [pixiv] 
  creditlink: http://www.pixiv.net/member_illust.php?mode=medium&illust_id=59740832
comments: 
---

相信很多同学在第一次<del>抽</del>听到要用linux写程序的时候是懵逼的：

- 诶命令行？好像很高大上的样子(*´・ω・)ノ
- 开始菜单在哪里？程序都装哪里了？桌面上怎么什么都没有？(＊´д｀)??
- 命令记不住啊……o(￣ヘ￣o＃).
- （不小心进了vim）诶诶诶诶怎么回事我怎么没法退出了！！！(╯°Д°）╯︵  w(ﾟДﾟ)w 
- gedit好丑……emacs是什么？可以吃吗？（学长/学姐用的sublime好帅ヾ(*ΦωΦ)ﾉ）
- <del>程序又写错了!!!| ｀Д´|ﾉД´|ノД´|ノД´|ノД´|ノД´|ノｺﾞﾙｧｱｱｱｱｱｱ!!</del>

![一脸懵逼.jpg](http://img.doutula.com/production/uploads/image//2016/04/10/20160410266693_nATirm.gif)

相信我，我一开始和你们一样懵逼，但是经过一段时间的摸<span class="heimu">折</span>索<span class="heimu">腾</span>和练<span class="heimu">作</span>习<span class="heimu">死</span>之后，
我终于<del>学会了yooo♂泳</del>
能够在linux下面搞定大部分学习与工作任务，<del>并且能够熟练地装逼</del>。
写这篇文章，主要是为了分享一点微小的人生经验，帮助大家在linux的环境下
续上一秒。<del>其实是为了抽SSR攒人品</del>

//题图:永远抽不到的呆毛其之一

# 我到河北省来，俺来不是为了蛋疼

![](http://og78s5hbx.bkt.clouddn.com/hebeisheng.jpg)

大部分童鞋现在在linux下的痛点是：如何搞定C语言的学习与CourseWork. 然而，
对于以前用惯了windows的童鞋，在linux下写程序就像走进了<del>新♂日暮里</del>
幻想乡一样，被水淹没，不知所措。尤其是，在机房windows系统有code blocks的情况
下，在linux下还要自己搞定编译，两相比较确实很难让人有学习的欲望。

![](http://og78s5hbx.bkt.clouddn.com/asswecan.jpg)

为了保证在linux下生存，我们必须了解几个跟linux相关的基本概念：

1. terminal 终端
简单地来说，在这个时候你只需要知道终端是linux下的一个命令行工具，跟
windows下的cmd类似就可以了。当然，terminal远比cmd这种渣渣强大百倍。
2. directory 目录
一些用mac的同学可能已经熟悉了目录这个概念，目录就像windows下面的文件夹，
里面存放工作文件或者下一级目录。但是，linux不存在不同的盘符。所有的目
录都是从根目录`/`开始，一层一层地往下展开。
3. working directory 工作目录
这是一个很特殊的概念。在windows下，我们可能习惯了打开多个文件夹，在不
同的文件夹里对不同的文件进行操作。但是，linux下，同一时间只能存在一个
主工作目录。有些人可能会发现在linux下也可以打开多个文件，或者打开多个
终端。其实他们本质上是不同的进程，在同一进程下只能存在一个主工作目录。
至于什么是进程，大家可以在大三的操作系统课中学到。
4. compiling 编译
把程序码转换成二进制码的过程，至少对C语言是如此。详细的编译概念请回顾C
语言课程。在linux下，我们不能像code blocks中一样一键搞定工具，所以我们
要使用linux下的工具进行编译。
5. 文件类型
linux下的文件有两种类型：文本文件，以及二进制文件。文本文件我们可以理
解成可以用记事本打开的文件，二进制我们可以理解成exe文件。这只是粗略的
分类，也有可执行的文本文件与单纯用于存储的二进制文件。
6. 文件权限
所有的文件的权限都有三个种类：可读，可写，可执行。分别用rwx字母来表示。
而文件权限又分成三个层级：持有者，同用户组，所有人。在linux中，文件采
用10个字符串表示文件的权限。第一个字符表示文件类型，后面⑨个字符每3个
为一组，表示文件的权限。比如，`-rwx------`表示仅所有者可以读写执行，而
`-r--r-----`表示仅所有者与同组的用户可以读取。有的时候文件执行不了，就
需要考虑是不是权限出了问题。权限同样可以用二进制表示，比如说
`-rwxrwxr--`就可以看作是`-111111100`，每三位算一个数字可以表示成
<del>水树</del>774
7. 文本编辑器与集成环境
文本编辑器就是用于编辑文本文件的东西（包括但不限于.txt），比如windows
下的记事本，gedit，sublime之类。集成环境通常是将编辑，代码补全，编译等
等一起搞定的东西，比如code blocks。集成环境的好处是可以不用关心编译等
等细节，而且往往对代码补全，项目管理等处理更加完善。但是，这并不表示文
本编辑器就一无是处。文本编辑器的优势在广度，一个文本编辑器往往可以编辑
许多种语言，有更好的灵活性。

了解了以上概念以后，我们就可以很容易地解决如何在坑爹的linux下，在作业
的炮火中生存下来了。

1. 首先，我们登录学校的linux环境。可以通过图形界面，如果对自己的命令行能
力有自信的话也可以通过putty登录。
2. 登录进去之后，如果是图形界面打开Terminal。执行命令：
```bash
pwd
```
我们可以获取到当前的工作目录。比如，`/home/your-user-name`。在学校的机
子上，一般第一个工作目录就是你的家目录，所有的文件都得存放在这个目录下
面。

3. 让我们创建一个文件夹：
```bash
mkdir my-directory
```
执行命令，就可以创建一个名为`my-directory`的文件夹。接下来，我们要在这
个文件夹里进行我们的编程任务。
```bash
cd my-directory
```
这个命令可以将你的工作目录转换到`my-directory`下面。我们理所当然的知道，
我们新建的目录应当是空的。但是，当我们执行命令`ls`来查看目录下的文件时：
```bash
ls -al
```
我们会看到如下输出：
```bash
~/my-directory$ ls -al
总用量 8
drwxr-xr-x  2 meow meow 4096 Nov  7 00:53 .
drwx------ 55 meow meow 4096 Nov  7 00:53 ..
```
那这里的两个文件是怎么回事呢？这里的一个点`.`表示的是你的当前目录，而
两个点`..`表示的是上级目录。如果我们想要回到家目录，我们可以执行：
```bash
cd ..
```
而我们要是想执行某个文件，我们可以:
```bash
./your-program # 在linux下通常可执行文件没有后缀
```
4.接下来，我们创建一个文件：
```bash
touch program.c
ls -al
```
我们可以看到输出增加了 program.c,说明文件已经创建成功。接下来，打开这
个文件，我们就可以进行编辑了。
```bash
gedit program.c # 图形界面
emacs program.c # 命令行，或者
vim program.c
```
5. 写完程序以后，我们要将C源文件编译成可执行文件。
```bash
gcc program.c -o program # 编译
./program # 执行
```
但是，我们每次都要开两个东西：一个是gedit, 一个是terminal，出现编译错
误得自己手动去找，不是很累吗？
在emacs中，我们有命令：
```bash
Alt+x compile # 之后在下面的小窗口中，会有编译命令，改成：
gcc program.c -o program
```
![](http://og78s5hbx.bkt.clouddn.com/compile.jpg)

然后，我们就可以直接使用快捷键：
```bash
Ctrl+`
```
![](http://og78s5hbx.bkt.clouddn.com/compile-error.jpg)

来进行编译错误之间的跳转，一下子就节省了很多时间。
顺带一提，在emacs中，`Ctrl+f`是打开文件，`Ctrl+x s`是保存文件，
`Ctrl+x c`是退出。

我们再进行ls:
```bash
 $ ls -al
总用量 24
drwxr-xr-x  2 meow meow 4096 Nov  7 01:33 .
drwx------ 55 meow meow 4096 Nov  7 01:33 ..
-rwxr-xr-x  1 meow meow 8392 Nov  7 01:33 program
-rw-r--r--  1 meow meow   80 Nov  7 01:33 program.c
```
我们可以很清晰地看到，我们的program是有执行权限的。我们改变它的权限，
让其不能被执行：`
```bash
chmod a-x program # 或者，二进制方式
chmod 644
ls -al
./program
```
这里，我们会获得一个权限错误。这意味着我们没有了可执行权限。通常在写脚
本的时候，由于linux文本文件默认是不可执行的，如果没有打开权限，在执行
的时候就会出错。

以上的步骤基本能保证完成编辑+编译工作，也意味着你可以在linux环境中生存
下来了。当然，为了能够真正地在linux中存活，你还需要一些别的命令，以及
学习能力与搜索技巧。
我们来总结一下生存所必须的linux命令：

```bash
pwd          # 当前工作目录的绝对路径，从/开始
cd           # 切换目录
cd ..        # 返回上一级
cd ~         # 返回用户的家目录。关于家目录的概念请自行查证

mkdir        # 创建目录
touch        # 创建一个空文件

ls           # 列出当前工作目录下的所有文件与目录
             # -a 指包含隐藏文件，-l 指打印出文件的权限，所有者等信息。

gedit        # 一个图形界面下的文本编辑器
emacs        # 一个文本编辑器，有图形界面以及命令行
vim          # 另一个文本编辑器，图形界面版本是gvim，操作的方法对初学者比较复杂
             # hjkl控制光标上下左右移动，:w是写入，:q是退出，:e是打开文件，要输
             # 入文字需要先按i键进入编辑模式，回到命令模式需要Esc

gcc          # GNU C Compiler的缩写。是linux下自带的C语言编译器，
             # -o用于指定输出文件名

man          #查看帮助
--help 或 -h # 许多命令可以通过追加这两个flag获得一些常用的用法以及解
释
```

# 来到两军阵前，必有高论



# 你为什么这么熟练啊？!

