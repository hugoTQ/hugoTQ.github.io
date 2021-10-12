## 1. 背景

1. appName
2. file
3. log



## 2. 原理



1. **Spark 程序的日志分为 driver 日志和 executor 日志**

   在 yarn-client 模式下，driver 日志即是 spark-submit（或 spark2-submit）运行时的打印日志，这个日志是我们排查问题首先要拿到的。在 yarn-cluster 模式下 driver 日志在某个 container 上。

2. **Spark 程序的日志根据 spark 程序所在的阶段需要去不同的地方查看**

   比如程序正在运行时可以通过程序本身的 web UI 查看运行时的日志，程序结束后，web UI 就退出了，Spark 会将日志移动到 Spark History。Spark程序结束后，就无法从 web UI 查看日志了，因为此时 driver 已经退出，而日志被移动到 spark history server，而 history server 保留日志是有时间和数量限制的；如果中 history server 中找不到，则需要从 HDFS的 /tmp/logs 目录下载 或者通过 yarn logs -applicationId 命令查看。

3. **Spark Client 和 Spark Cluster的区别:**

   理解YARN-Client和YARN-Cluster深层次的区别之前先清楚一个概念：Application Master。在YARN中，每个Application实例都有一个ApplicationMaster进程，它是Application启动的第一个容器。它负责和ResourceManager打交道并请求资源，获取资源之后告诉NodeManager为其启动Container。从深层次的含义讲YARN-Cluster和YARN-Client模式的区别其实就是ApplicationMaster进程的区别。

   YARN-Cluster模式下，Driver运行在AM(Application Master)中，它负责向YARN申请资源，并监督作业的运行状况。当用户提交了作业之后，就可以关掉Client，作业会继续在YARN上运行，因而YARN-Cluster模式不适合运行交互类型的作业。

   YARN-Client模式下，Application Master仅仅向YARN请求Executor，Client会和请求的Container通信来调度他们工作，也就是说Client不能离开。

##  3. 解决







