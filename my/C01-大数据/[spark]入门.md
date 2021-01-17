## spark输出hdfs文本文件

```scala
val textFileRdd = sc.textFile("hdfs://192.168.0.100:9000/test/1.txt")
 textFileRdd.map(line => line.toString)
textFileRdd.foreach(println(_))
```



## 打印

```scala
rdd2.foreach(println)
```





## spark常用算子

### **wordCount例子**

```scala
sc.textFile("input").flatMap(_.split(" ")).map((_,1))).reduceByKey(_+_)	
```





### **glom**

聚合每个分区的元素为一个数组。也即最后输出一个二维数组。二维数组的包含的数组个数是分区个数。

```scala
val listrdd: RDD[Int] = sc.makeRDD(List(1,2,3,4,5,6,9), 3) // 分区个数为3
val listGlomRdd = listrdd.glom()

listGlomRdd.collect().foreach(array => println(array.mkString(",")))

/*
1,2
3,4
5,6,9
*/
```



### **groupBy(func)**

以func的返回值作为key分组，其中value是分组的元素集合的迭代器

```SCALA
val rdd1: RDD[Int] = sc.makeRDD(List(1,2,3,4,5,6,9))
val rdd2: RDD[(Int, Iterable[Int])] = rdd1.groupBy(i=>i%2)

rdd2.foreach(println)
/*
(0,CompactBuffer(2, 4, 6))
(1,CompactBuffer(1, 3, 5, 9))
*/
```



### **filter(func)**

以func的返回值为true则保留

```SCALA
val rdd1: RDD[Int] = sc.makeRDD(List(1,2,3,4,5,6,9))
val rdd2: RDD[Int] = rdd1.filter(i=>i%2 == 0)

rdd2.foreach(println)
/*
3
5
6
9
2
1
4
*/
```



### **sample(withReplacement, fraction, seed)**

withReplacement：true抽取放回，false抽取不放回。

fraction：
 1）false抽取不放回的情况下，每个抽取的概率（0-1）。
 0-全不抽
 1-全抽
 2）true抽取放回的情况下，抽取的次数。

seed：随机数种子。



### **distinct**

去重。

会shuffle，可以重组分区：disctin(i)，去重后重组为i个分区。



### **coalesce(numPartitions: Int, shuffle: Boolean = false)**

缩减分区。当大数据做处理后边小数据，可以缩减分区，提高效率。

默认没有shuffle=false打乱，可以提高效率，那shuffle=true有什么好处？

```SCALA
val rdd1: RDD[Int] = sc.makeRDD(List(1,2,3,4,5,6,9),5) // 分区(1)(2)(3,4)(5)(6,9)
val rdd2: RDD[Int] = rdd1.coalesce(3)// 分区：（1）（2,3,4）(5,6,9)
```



### **pairRDD方法**

注意pairRDD中必须是key-value数据



### **partitionBy(partitioner: Partitioner)**

key按照Partitioner重分区

```scala
val rdd1: RDD[(Int, String)] = sc.makeRDD(List((1,"aaa"),(2,"bbb"),(3,"ccc"), (4,"ddd")),4)
rdd1.saveAsTextFile("output1")
val rdd2: RDD[(Int, String)] = rdd1.partitionBy(new HashPartitioner(2)) // 2个分区，key与分区数取模得到分区号
rdd2.saveAsTextFile("output2")


// 自定义分区器
class MyPartitioner (num: Int) extends org.apache.spark.Partitioner {
  override def numPartitions: Int = num			// 总共有num个分区
  override def getPartition(key: Any): Int = 1	// 分区结果都是1，即所有元素都放到分区1
}
```



### **reduceByKey(func, partitionNum)**

按照key聚合，func定义聚合后value处理。注意，输入元素必须是key-value

func：聚合函数

partitionNum ：分区数，也即并行数，缺省不改变原分区数



### **groupByKey()**

按照Key分组



### **aggregateByKey(zeroValue: U, partitioner: Partitioner)(seqOp: (U, V) => U,    combOp: (U, U) => U): RDD[(K, U)]**

分区内与分区间不同的处理。

zeroValue：给每个key一个初值

seqOp：分区里相同key对value的处理函数

combOp：分区间相同key对value的处理函数

例子：每个分区中同一个key的最大值，再将分区间同一个key的最大值相加。

![image.png](https://i.loli.net/2019/12/12/YNTuB2t51cDL8Xq.png)









### **combineByKey[C]**

参数：(createCombiner: V => C,  mergeValue: (C, V) => C,  mergeCombiners: (C, C) => C)

1. 作用：对相同K，把V合并成一个集合。

2. 参数描述：

   （1）createCombiner: combineByKey() 会遍历分区中的所有元素，因此每个元素的键要么还没有遇到过，要么就和之前的某个元素的键相同。如果这是一个新的元素,combineByKey()会使用一个叫作createCombiner()的函数来创建那个键对应的累加器的初始值

   （2）mergeValue: 如果这是一个在处理当前分区之前已经遇到的键，它会使用mergeValue()方法将该键的累加器对应的当前值与这个新的值进行合并

   （3）mergeCombiners: 由于每个分区都是独立处理的， 因此对于同一个键可以有多个累加器。如果有两个或者更多的分区都有对应同一个键的累加器， 就需要使用用户提供的 mergeCombiners() 方法将各个分区的结果进行合并。

例子：创建一个pairRDD，根据key计算每种key的均值。（先计算每个key出现的次数以及可以对应值的总和，再相除得到结果）



![image.png](https://i.loli.net/2019/12/12/ZgqyfETsCDeoWnV.png)

```SCALA
    val rdd1: RDD[(String, Int)] = sc.makeRDD(List(("a",88),("b", 95),("a",91), ("b",93), ("a", 95), ("b",98)), 2)

    val rdd2: RDD[(String, (Int, Int))] = rdd1.combineByKey((_, 1), (acc: (Int, Int), v) => (acc._1 + v, acc._2 + 1),
      (acc1: (Int, Int), acc2: (Int, Int)) => (acc1._1 + acc2._1, acc1._2 + acc2._2))

    val rdd3: RDD[(String, Double)] = rdd2.map {
      case (k, v) => (k, v._1 / v._2.toDouble)
        
    rdd3.foreach(println)
结果：
(b,95.33333333333333)
(a,91.33333333333333)
```

