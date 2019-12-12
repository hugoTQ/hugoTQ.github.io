## spark map 与 mapPartitions 理解

**函数定义**

```scala
  /**
   * Return a new RDD by applying a function to all elements of this RDD.
   */
  def map[B](f: A => B): Iterator[B] = new AbstractIterator[B] {
    def hasNext = self.hasNext
    def next() = f(self.next())
  }
```
 >>Return a new RDD by applying a function to all elements of this RDD.
对一个RDD做map，就是map把一个函数作用于一个RDD的所有元素，最后返回一个新的RDD

```scala
  /**
   * Return a new RDD by applying a function to each partition of this RDD.
   *
   * `preservesPartitioning` indicates whether the input function preserves the partitioner, which
   * should be `false` unless this is a pair RDD and the input function doesn't modify the keys.
   */
  def mapPartitions[U: ClassTag](
      f: Iterator[T] => Iterator[U],
      preservesPartitioning: Boolean = false): RDD[U] = withScope {
    val cleanedF = sc.clean(f)
    new MapPartitionsRDD(
      this,
      (context: TaskContext, index: Int, iter: Iterator[T]) => cleanedF(iter),
      preservesPartitioning)
  }
```
>>Return a new RDD by applying a function to each partition of this RDD.
对一个RDD做mapPartitions，就是mapPartitions把一个函数作用于一个RDD下的每个分区，最后返回一个新的RDD。

**区别**
1. 用法

可以看出，map是对RDD foreach得到每个元素做函数处理，mapPatitions foreachpartition得到每个分区做函数处理。所以区别就是f，map的f函数的输入是单个元素A输出也是单个元素B。而mapPartitions的f函数输入是集合（Iterator）输出也是集合（Iterator）。

2. 性能

map:10个分区100条数据，f函数执行1000次

mapPartitions：10个分区100条数据，f函数执行10次

总结：

若f中有耗资源操作，则mapPartitions效率更高。

mapPartitions中f需要读到内存数据更多，OOM风险更大。


