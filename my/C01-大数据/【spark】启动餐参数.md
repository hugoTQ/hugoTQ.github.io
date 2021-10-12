```shell
time /MFS/Dataone/BICommon/FIClient_C70SPC282/Spark2x/spark/bin/spark-submit \
--class com.huawei.fuxiOffline.feature.RunFeatureEngineering \
--master yarn \ #集群的master地址。如：spark://host:port，mesos://host:port， yarn-client，yarn-cluster，local[k]本地以k个worker线程执行， k一般为cpu的内核数，local[*]以尽可能多的线程数执行。
--deploy-mode cluster \ #driver运行的模式，client或者cluster模式，默认为client
--driver-cores 5 \  #driver的内核数，默认为1。**（仅用于spark standalone集群中）
--driver-memory 50G \ #driver节点的内存大小。如2G，默认为1024M。
--executor-memory 50G \ #每个excutor的执行内存。
--num-executors  20 \ #executor的数量。**（仅yarn）
--executor-cores 5 \	#分配给每个executor的内核数。（仅用于spark standalone或者yarn集群中）
--files $base_path/config/spark/exposure/ftrl_common_jar/feature_engineering/hiad_ftrl_base22.json \
#--conf spark.authenticate=true \
#--conf spark.yarn.security.credentials.hive.enabled=true \
#--conf spark.authenticate=true \
#--principal spark2x/hadoop.hadoop.com@HADOOP.COM \
#--keytab /opt/huawei/Bigdata/FusionInsight_Spark2x_V100R002C70SPC200/install/FusionInsight-Spark2x-2.1.0/keytab/spark2x/SparkResource/spark2x.keytab \
```

使用格式: 

./bin/spark-submit \

  --class <main-class> \

  --master <master-url> \

  --deploy-mode <deploy-mode> \

  --conf <key>=<value> \

  ... # other options

  <application-jar> \

  [application-arguments]

 

 

参数名 格式 参数说明

--master MASTER_URL 如spark://host:port, mesos://host:port, yarn,  yarn-cluster,yarn-client, local

--deploy-mode DEPLOY_MODE Client或者master，默认是client

--class CLASS_NAME 应用程序的主类

--name NAME 应用程序的名称

--jars JARS 逗号分隔的本地jar包，包含在driver和executor的classpath下

--packages 包含在driver和executor的classpath下的jar包逗号分隔的”groupId:artifactId：version”列表

--exclude-packages 用逗号分隔的”groupId:artifactId”列表

--repositories 逗号分隔的远程仓库

--py-files PY_FILES 逗号分隔的”.zip”,”.egg”或者“.py”文件，这些文件放在python app的PYTHONPATH下面

--files FILES 逗号分隔的文件，这些文件放在每个executor的工作目录下面

--conf PROP=VALUE 固定的spark配置属性，默认是conf/spark-defaults.conf

--properties-file FILE 加载额外属性的文件

--driver-memory MEM Driver内存，默认1G

--driver-java-options 传给driver的额外的Java选项

--driver-library-path 传给driver的额外的库路径

--driver-class-path 传给driver的额外的类路径

--executor-memory MEM 每个executor的内存，默认是1G

--proxy-user NAME 模拟提交应用程序的用户

--driver-cores NUM Driver的核数，默认是1。这个参数仅仅在standalone集群deploy模式下使用

--supervise Driver失败时，重启driver。在mesos或者standalone下使用

--verbose 打印debug信息

--total-executor-cores NUM 所有executor总共的核数。仅仅在mesos或者standalone下使用

--executor-core NUM 每个executor的核数。在yarn或者standalone下使用

--driver-cores NUM Driver的核数，默认是1。在yarn集群模式下使用

--queue QUEUE_NAME 队列名称。在yarn下使用

--num-executors NUM 启动的executor数量。默认为2。在yarn下使用

 

 

试例：

\# Run application locally on 8 cores(本地模式8核)

./bin/spark-submit \

  --class org.apache.spark.examples.SparkPi \

  --master local[8] \

  /path/to/examples.jar \

  100

 

\# Run on a Spark standalone cluster in client deploy mode(standalone client模式)

./bin/spark-submit \

  --class org.apache.spark.examples.SparkPi \

  --master spark://207.184.161.138:7077 \

  --executor-memory 20G \

  --total-executor-cores 100 \

  /path/to/examples.jar \

  1000

 

\# Run on a Spark standalone cluster in cluster deploy mode with supervise(standalone cluster模式使用supervise)

./bin/spark-submit \

  --class org.apache.spark.examples.SparkPi \

  --master spark://207.184.161.138:7077 \

  --deploy-mode cluster \

  --supervise \

  --executor-memory 20G \

  --total-executor-cores 100 \

  /path/to/examples.jar \

  1000

 

\# Run on a YARN cluster(YARN cluster模式)

export HADOOP_CONF_DIR=XXX

./bin/spark-submit \

  --class org.apache.spark.examples.SparkPi \

  --master yarn \

  --deploy-mode cluster \  # can be client for client mode

  --executor-memory 20G \

  --num-executors 50 \

  /path/to/examples.jar \

  1000

 

 

\# Run on a Mesos cluster in cluster deploy mode with supervise(Mesos cluster模式使用supervise)

./bin/spark-submit \

  --class org.apache.spark.examples.SparkPi \

  --master mesos://207.184.161.138:7077 \

  --deploy-mode cluster \

  --supervise \

  --executor-memory 20G \

  --total-executor-cores 100 \

  http://path/to/examples.jar \

  1000

 

在公司使用最多的是spark on yarn模式，下面主要讲spark on yarn

 

 

资源参数调优

所谓的Spark资源参数调优，其实主要就是对Spark运行过程中各个使用资源的地方，通过调节各种参数，来优化资源使用的效率，从而提升Spark作业的执行性能。

以下参数就是Spark中主要的资源参数，每个参数都对应着作业运行原理中的某个部分，我们同时也给出了一个调优的参考值。

 

num-executors

 

参数说明：

该参数用于设置Spark作业总共要用多少个Executor进程来执行。Driver在向YARN集群管理器申请资源时，YARN集群管理器会尽可能按照你的设置来在

集群的各个工作节点上，启动相应数量的Executor进程。这个参数非常之重要，如果不设置的话，默认只会给你启动少量的Executor进程，此时你的

Spark作业的运行速度是非常慢的。

参数调优建议：

每个Spark作业的运行一般设置50~100个左右的Executor进程比较合适，设置太少或太多的Executor进程都不好。设置的太少，无法充分利用集群资源；

设置的太多的话，大部分队列可能无法给予充分的资源。

 

executor-memory

参数说明：

该参数用于设置每个Executor进程的内存。Executor内存的大小，很多时候直接决定了Spark作业的性能，而且跟常见的JVM OOM异常，也有直接的关联。

参数调优建议：

每个Executor进程的内存设置4G~8G较为合适。但是这只是一个参考值，具体的设置还是得根据不同部门的资源队列来定。可以看看自己团队的资源队列

的最大内存限制是多少，num-executors乘以executor-memory，是不能超过队列的最大内存量的。此外，如果你是跟团队里其他人共享这个资源队列，

那么申请的内存量最好不要超过资源队列最大总内存的1/3~1/2，避免你自己的Spark作业占用了队列所有的资源，导致别的同学的作业无法运行。

 

executor-cores

参数说明：

该参数用于设置每个Executor进程的CPU core数量。这个参数决定了每个Executor进程并行执行task线程的能力。因为每个CPU core同一时间只能执行一个

task线程，因此每个Executor进程的CPU core数量越多，越能够快速地执行完分配给自己的所有task线程。

参数调优建议：

Executor的CPU core数量设置为2~4个较为合适。同样得根据不同部门的资源队列来定，可以看看自己的资源队列的最大CPU core限制是多少，再依据设置的

Executor数量，来决定每个Executor进程可以分配到几个CPU core。同样建议，如果是跟他人共享这个队列，那么num-executors * executor-cores不要超过

队列总CPU core的1/3~1/2左右比较合适，也是避免影响其他同学的作业运行。

 

driver-memory

参数说明：

该参数用于设置Driver进程的内存。

参数调优建议：

Driver的内存通常来说不设置，或者设置1G左右应该就够了。唯一需要注意的一点是，如果需要使用collect算子将RDD的数据全部拉取到Driver上进行处理，

那么必须确保Driver的内存足够大，否则会出现OOM内存溢出的问题。

 

spark.default.parallelism

参数说明：

该参数用于设置每个stage的默认task数量。这个参数极为重要，如果不设置可能会直接影响你的Spark作业性能。

参数调优建议：

Spark作业的默认task数量为500~1000个较为合适。很多同学常犯的一个错误就是不去设置这个参数，那么此时就会导致Spark自己根据底层HDFS的block数量

来设置task的数量，默认是一个HDFS block对应一个task。通常来说，Spark默认设置的数量是偏少的（比如就几十个task），如果task数量偏少的话，就会

导致你前面设置好的Executor的参数都前功尽弃。试想一下，无论你的Executor进程有多少个，内存和CPU有多大，但是task只有1个或者10个，那么90%的

Executor进程可能根本就没有task执行，也就是白白浪费了资源！因此Spark官网建议的设置原则是，设置该参数为num-executors * executor-cores的2~3倍

较为合适，比如Executor的总CPU core数量为300个，那么设置1000个task是可以的，此时可以充分地利用Spark集群的资源。

 

spark.storage.memoryFraction

参数说明：

该参数用于设置RDD持久化数据在Executor内存中能占的比例，默认是0.6。也就是说，默认Executor 60%的内存，可以用来保存持久化的RDD数据。根据你选择

的不同的持久化策略，如果内存不够时，可能数据就不会持久化，或者数据会写入磁盘。

参数调优建议：

如果Spark作业中，有较多的RDD持久化操作，该参数的值可以适当提高一些，保证持久化的数据能够容纳在内存中。避免内存不够缓存所有的数据，导致数据只

能写入磁盘中，降低了性能。但是如果Spark作业中的shuffle类操作比较多，而持久化操作比较少，那么这个参数的值适当降低一些比较合适。此外，如果发现

作业由于频繁的gc导致运行缓慢（通过spark web ui可以观察到作业的gc耗时），意味着task执行用户代码的内存不够用，那么同样建议调低这个参数的值。

 

spark.shuffle.memoryFraction

参数说明：

该参数用于设置shuffle过程中一个task拉取到上个stage的task的输出后，进行聚合操作时能够使用的Executor内存的比例，默认是0.2。也就是说，Executor

默认只有20%的内存用来进行该操作。shuffle操作在进行聚合时，如果发现使用的内存超出了这个20%的限制，那么多余的数据就会溢写到磁盘文件中去，此时

就会极大地降低性能。

参数调优建议：

如果Spark作业中的RDD持久化操作较少，shuffle操作较多时，建议降低持久化操作的内存占比，提高shuffle操作的内存占比比例，避免shuffle过程中数据过多

时内存不够用，必须溢写到磁盘上，降低了性能。此外，如果发现作业由于频繁的gc导致运行缓慢，意味着task执行用户代码的内存不够用，那么同样建议调低

这个参数的值。

 

资源参数的调优，没有一个固定的值，需要根据自己的实际情况（包括Spark作业中的shuffle操作数量、RDD持久化操作数量以及spark web ui中显示的作业gc情况），

合理地设置上述参数。

 

资源参数参考示例

以下是一份spark-submit命令的示例，大家可以参考一下，并根据自己的实际情况进行调节：

 

./bin/spark-submit \

  --master yarn-cluster \

  --num-executors 100 \

  --executor-memory 6G \

  --executor-cores 4 \

  --driver-memory 1G \

  --conf spark.default.parallelism=1000 \

  --conf spark.storage.memoryFraction=0.5 \

  --conf spark.shuffle.memoryFraction=0.3 \

|      |      |
| :--: | :--: |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |
|      |      |