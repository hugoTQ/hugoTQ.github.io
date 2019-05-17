# Docker之控制cpu使用率

## 限制CPU可用个数
命令：` --cpu=   `

docker run -it --rm --cpus=1.5 u-stress:latest /bin/bash

这种方法其实是平均到所有CPU，并没有绑核

我们先来看看 docker stats 命令的输出：

![img](https://images2017.cnblogs.com/blog/952033/201712/952033-20171217163517202-62045189.png)

容器 CPU 的负载为 200%，它的含义为单个 CPU 负载的两倍。我们也可以把它理解为有两颗 CPU 在 100% 的为它工作。
再让我们通过 top 命令看看主机 CPU 的真实负载情况：

![img](https://images2017.cnblogs.com/blog/952033/201712/952033-20171217163457514-1473983991.png)

## 容器绑核
因为现在的多核系统中每个核心都有自己的缓存，如果频繁的调度进程在不同的核心上执行势必会带来缓存失效等开销。

​	命令：`--cpuset-cpus=`
`docker run -it --rm --cpuset-cpus="1" u-stress:latest /bin/bash` 		绑CPU
`docker run -it --rm --cpuset-cpus="1,3" u-stress:latest /bin/bash`	绑定多个CPU

![img](https://images2017.cnblogs.com/blog/952033/201712/952033-20171217164009218-1499882618.png)

Cpu1 和 Cpu3 的负载都达到了 100%。
容器的 CPU 负载也达到了 200%：

![img](https://images2017.cnblogs.com/blog/952033/201712/952033-20171217164032296-1942575599.png)

--cpuset-cpus 选项的一个缺点是必须指定 CPU 在操作系统中的编号，这对于动态调度的环境(无法预测容器会在哪些主机上运行，只能通过程序动态的检测系统中的 CPU 编号，并生成 docker run 命令)会带来一些不便。由此可见公有云容器并没有采用该选项

## 设置使用CPU的权重
当 CPU 资源充足时，设置 CPU 的权重是没有意义的。只有在容器争用 CPU 资源的情况下， CPU 的权重才能让不同的容器分到不同的 CPU 用量。--cpu-shares 选项用来设置 CPU 权重，它的默认值为 1024。我们可以把它设置为 2 表示很低的权重，但是设置为 0 表示使用默认值 1024。

命令：`--cpu-shares=`

下面我们分别运行两个容器，指定它们都使用 Cpu0，并分别设置 `--cpu-shares `为 512 和 1024：

`docker run -it --rm --cpuset-cpus="0" --cpu-shares=512 u-stress:latest /bin/bash`
`docker run -it --rm --cpuset-cpus="0" --cpu-shares=1024 u-stress:latest /bin/bash`

此时主机 Cpu0 的负载为 100%：

![img](https://images2017.cnblogs.com/blog/952033/201712/952033-20171217164142218-723091322.png)

容器中 CPU 的负载为：

![img](https://images2017.cnblogs.com/blog/952033/201712/952033-20171217164255702-1003240099.png)

两个容器分享一个 CPU，所以总量应该是 100%。具体每个容器分得的负载则取决于 --cpu-shares 选项的设置！我们的设置分别是 512 和 1024，则它们分得的比例为 1:2。在本例中如果想让两个容器各占 50%，只要把 --cpu-shares 选项设为相同的值就可以了。

