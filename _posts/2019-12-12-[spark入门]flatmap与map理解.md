## spark 中 map 和 flatMap 的理解
**函数原型**

**data.map(function)**

该函数是data的方法，传入的参数为一个函数（function）,作用：对data中的每一个项进行function操作，并返回RDD，该RDD的项的数目等于原data的项的数目。

**data.flatMap(function)**

flatMap方法和map方法类似，但是每个输入项可成为0个或多个输出项，实际上是在map的基础上进行了扁平化处理。

---
**形象化理解map和flatMap**

![image.png](https://i.loli.net/2019/12/12/ZRkPlgALy76u34T.png)

**理解** 

读取文件是一行一行读的，flatmap是先map后flat。map(_.split(" "))后将每行分割为一个字符串数组，也即是map后是一个二维的字符串数组。flat一般称为扁平化，flat可以理解为再将这个二维数组片扁平为一个一维数组。

## java stream 的 map，scala iterator 的map 与 spark RDD 的 map 区别

**spark RDD.map源码***
```scala
  def map[U: ClassTag](f: T => U): RDD[U] = withScope {
    val cleanF = sc.clean(f)
    new MapPartitionsRDD[U, T](this, (context, pid, iter) => iter.map(cleanF))
  }

  def flatMap[U: ClassTag](f: T => TraversableOnce[U]): RDD[U] = withScope {
    val cleanF = sc.clean(f)
    new MapPartitionsRDD[U, T](this, (context, pid, iter) => iter.flatMap(cleanF))
  }
```
可以看出了RDD 底层就是iterator

