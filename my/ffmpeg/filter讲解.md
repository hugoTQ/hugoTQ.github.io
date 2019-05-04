## 1. filter使用，关于filter，filterchain，filtergraph

1. 最简单的filter，演示动态画中画

   1. 语法：[in_link_1]…[in_link_N]filter_name=parameters[out_link_1]…[out_link_M]

   `ffmpeg -i input.mp4 [input_lable1][input_lable2] crop=iw:ih/2:0:0 output.mp4`

   `ffmpeg -i video.avi`

   `-filter_complex 'extractplanes=y+u+v[y][u][v]' -map '[y]' y.avi -map '[u]' u.avi -map '[v]' v.avi`

2. 多个filter组成一个filterchain

   1. 它是多个filter的组合，以逗号分隔，并且每个filter是输入是前一个filter的输出。"filter1, filter2, ... filterN-1, filterN"
   2. 

3. 多个filterchain组成一个filtergraph

   1. 它是多个filterchain的组合，以分号";"分隔。"filterchain1;filterchain2;...filterchainN-1;fiterchainN"
   2. `ffmpeg -i INPUT -filter_complex "split [main][tmp]; [tmp] crop=iw:ih/2:0:0, vflip [flip]; [main][flip] overlay=0:H/2" OUTPUT`
      1. 第一个 filterchain：`split [main][tmp]` 有一个默认输入，即INPUT解码后的frame，有两个输出，以`[main]和[tmp]`标识
      2. 第二个filterchain：`[tmp] crop=iw:ih/2:0:0, vflip [flip] `，由两个filter组成，即crop和vfilp；第一个输入[tmp]，第二个输出[flip]
      3. 第三个filterchain：`[main][flip] overlay=0:H/2`，由一个filter组成，即overlay，由两个输入，一个默认输出
   3. 讲解时，分别写出含义，让大家想像效果，再验证

4. 注意点

   1. >In a filter description, if the input label of the first filter is not specified, "in" is assumed; if the output label of the last filter is not specified, "out" is assumed.

      ​	这里第一个filter的缺省输入和最后一个filter的缺省输出lable分别为"in"和"out"，在对应代码里面AVFilter *buffersrc 和AVFilter *sinkbuff？

## 2.AVsFilter代码

### 2.1 大致讲下所有filter和filter类别

filter结构体

![20160512160533458](https://ws4.sinaimg.cn/large/006tNc79ly1g2o631oyagj31fi0tlaom.jpg)

### 2.2 初始化

### 2.3 filter流程

1. 多个filter，filter->filterchain->filtergraph

### 2.4 自己加一个filter



## Referemce 

[ffmpeg的filter分析](https://blog.csdn.net/xiaojun111111/article/details/52806367)

[FFmpeg-4.0 的filter机制的架构与实现.之一 Filter原理](https://blog.csdn.net/fireroll/article/details/85316881)

[FFmpeg filter的使用介绍](https://www.jianshu.com/p/b16835da62ab)