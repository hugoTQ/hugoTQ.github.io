## spark map 与 mapPartitions 理解

**函数定义**

```scala
  def flatMap[B](f: A => GenTraversableOnce[B]): Iterator[B] = new AbstractIterator[B] {
    private var cur: Iterator[B] = empty
    private def nextCur() { cur = f(self.next()).toIterator }
    def hasNext: Boolean = {
      // Equivalent to cur.hasNext || self.hasNext && { nextCur(); hasNext }
      // but slightly shorter bytecode (better JVM inlining!)
      while (!cur.hasNext) {
        if (!self.hasNext) return false
        nextCur()
      }
      true
    }
    def next(): B = (if (hasNext) cur else empty).next()
  }
```

```scala
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

```scala
  def map[B](f: A => B): Iterator[B] = new AbstractIterator[B] {
    def hasNext = self.hasNext
    def next() = f(self.next())
  }
```


**映射函数的区别**
