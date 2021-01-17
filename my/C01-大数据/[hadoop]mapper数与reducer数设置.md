## 1. 背景

### 1.1 问题

spark特征工程，报错java.lang.IllegalArgumentException: Size exceeds Integer.MAX_VALUE

![img](../../../../projectdocsmyimages/0C0B27DC-F6CA-4263-85E1-4B4FA25796F0.png)



### 1.2. 原因

rdd 分区大小超过2G，分区数是map输入分片数，尽管每个分片200MB，spark过程的rdd运算超出了2G。



### 1.3 解决

1. 方法1：在上一个 reduce 过程增加 reduce  task数从而增加输出分片数，也即增加后续MapReduce输入的分区数。
   1. 设置 reduce task数：`set mapred.reduce.tasks=90` （实测最终输分桶并没有90个？？？）
   2. 使用 `distribute by rand()` map输出平均发到每个reduce 节点去处理。（distribution by 直接放到SQL最后？貌似会对性能有大影响，如果不加distribution，输出的分桶数一样的吗？）
2. 方法2：指定分桶数：当`set hive.enforce.bucketing=ture`开启分桶支持后，MapReduce运行时会根据bucket个数自动分配reduce task个数。
3. 方法3：spark 调用`repartition()`，增加分区数。（待试验最终输出是否就是那么多）
4. 方法4：spark-submit --conf spark.sql.shuffle.partitions=300 --conf spark.default.parallelism=300 (未测试，修改每个分区上限，解决不够彻底)



## 2. 疑问，待分析

- hive的分区与分桶机制

- reduce task 数多少合适？

- map task 数多少合适？

- reparation 多少合适？

- 没有加 distribute by 输出分桶数一样吗？

- distribute by 对性能有什么影响吗？

  

## 参考

[[Hive学习之路 （二十一）Hive 优化策略](https://www.cnblogs.com/qingyunzong/p/8847775.html)](https://www.cnblogs.com/qingyunzong/p/8847775.html#_label7)

[Hive分桶](https://blog.csdn.net/fantasticqiang/article/details/80769316)

[HIve 性能优化](https://blog.csdn.net/s294878304/article/details/100581397)

[hive 高级查询 distribute by等](https://www.cnblogs.com/huxinga/p/7688376.html)