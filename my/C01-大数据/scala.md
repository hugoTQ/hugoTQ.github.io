## Scala 数据类型

Scala 与 Java有着相同的数据类型，下表列出了 Scala 支持的数据类型：

| 数据类型 | 描述                                                         |
| :------- | :----------------------------------------------------------- |
| Byte     | 8位有符号补码整数。数值区间为 -128 到 127                    |
| Short    | 16位有符号补码整数。数值区间为 -32768 到 32767               |
| Int      | 32位有符号补码整数。数值区间为 -2147483648 到 2147483647     |
| Long     | 64位有符号补码整数。数值区间为 -9223372036854775808 到 9223372036854775807 |
| Float    | 32 位, IEEE 754 标准的单精度浮点数                           |
| Double   | 64 位 IEEE 754 标准的双精度浮点数                            |
| Char     | 16位无符号Unicode字符, 区间值为 U+0000 到 U+FFFF             |
| String   | 字符序列                                                     |
| Boolean  | true或false                                                  |
| Unit     | 表示无值，和其他语言中void等同。用作不返回任何结果的方法的结果类型。Unit只有一个实例值，写成()。 |
| Null     | null 或空引用                                                |
| Nothing  | Nothing类型在Scala的类层级的最底端；它是任何其他类型的子类型。 |
| Any      | Any是所有其他类的超类                                        |
| AnyRef   | AnyRef类是Scala里所有引用类(reference class)的基类           |

## 作用域保护

Scala中，访问修饰符可以通过使用限定词强调。格式为:

```scala
private[x] 

或 

protected[x]
```

这里的x指代某个所属的包、类或单例对象。如果写成private[x],读作"这个成员除了对[…]中的类或[…]中的包中的类及它们的伴生对像可见外，对其它所有类都是private。

这种技巧在横跨了若干包的大型项目中非常有用，它允许你定义一些在你项目的若干子包中可见但对于项目外部的客户却始终不可见的东西。

```scala
package bobsrockets{
    package navigation{
        private[bobsrockets] class Navigator{
         protected[navigation] def useStarChart(){}
         class LegOfJourney{
             private[Navigator] val distance = 100
             }
            private[this] var speed = 200
            }
        }
        package launch{
        import navigation._
        object Vehicle{
        private[launch] val guide = new Navigator
        }
    }
}
```

上述例子中，类Navigator被标记为private[bobsrockets]就是说这个类对包含在bobsrockets包里的所有的类和对象可见。

比如说，从Vehicle对象里对Navigator的访问是被允许的，因为对象Vehicle包含在包launch中，而launch包在bobsrockets中，相反，所有在包bobsrockets之外的代码都不能访问类Navigator。

## 方法与函数

Scala 有方法与函数，二者在语义上的区别很小。Scala 方法是类的一部分，而函数是一个对象可以赋值给一个变量。换句话来说在类中定义的函数即是方法。

Scala 中的方法跟 Java 的类似，方法是组成类的一部分。

Scala 中的函数则是一个完整的对象，Scala 中的函数其实就是继承了 Trait 的类的对象。

Scala 中使用 **val** 语句可以定义函数，**def** 语句定义方法。

```Scala 
class Test{
  def m(x: Int) = x + 3
  val f = (x: Int) => x + 3
}
```

**方法声明**

```scala
def functionName ([参数列表]) : [return type]
```



## 匿名函数

```scala
var inc = (x:Int) => x+1
```

上述定义的匿名函数，其实是下面这种写法的简写：

```scala
def add2 = new Function1[Int,Int]{  
    def apply(x:Int):Int = x+1;  
} 
```



## String 方法

下表列出了 java.lang.String 中常用的方法，你可以在 Scala 中使用：

| 序号 | 方法及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **char charAt(int index)**返回指定位置的字符                 |
| 2    | **int compareTo(Object o)**比较字符串与对象                  |
| 3    | **int compareTo(String anotherString)**按字典顺序比较两个字符串 |
| 4    | **int compareToIgnoreCase(String str)**按字典顺序比较两个字符串，不考虑大小写 |
| 5    | **String concat(String str)**将指定字符串连接到此字符串的结尾 |
| 6    | **boolean contentEquals(StringBuffer sb)**将此字符串与指定的 StringBuffer 比较。 |
| 7    | **static String copyValueOf(char[] data)**返回指定数组中表示该字符序列的 String |
| 8    | **static String copyValueOf(char[] data, int offset, int count)**返回指定数组中表示该字符序列的 String |
| 9    | **boolean endsWith(String suffix)**测试此字符串是否以指定的后缀结束 |
| 10   | **boolean equals(Object anObject)**将此字符串与指定的对象比较 |
| 11   | **boolean equalsIgnoreCase(String anotherString)**将此 String 与另一个 String 比较，不考虑大小写 |
| 12   | **byte getBytes()**使用平台的默认字符集将此 String 编码为 byte 序列，并将结果存储到一个新的 byte 数组中 |
| 13   | **byte[] getBytes(String charsetName**使用指定的字符集将此 String 编码为 byte 序列，并将结果存储到一个新的 byte 数组中 |
| 14   | **void getChars(int srcBegin, int srcEnd, char[] dst, int dstBegin)**将字符从此字符串复制到目标字符数组 |
| 15   | **int hashCode()**返回此字符串的哈希码                       |
| 16   | **int indexOf(int ch)**返回指定字符在此字符串中第一次出现处的索引 |
| 17   | **int indexOf(int ch, int fromIndex)**返回在此字符串中第一次出现指定字符处的索引，从指定的索引开始搜索 |
| 18   | **int indexOf(String str)**返回指定子字符串在此字符串中第一次出现处的索引 |
| 19   | **int indexOf(String str, int fromIndex)**返回指定子字符串在此字符串中第一次出现处的索引，从指定的索引开始 |
| 20   | **String intern()**返回字符串对象的规范化表示形式            |
| 21   | **int lastIndexOf(int ch)**返回指定字符在此字符串中最后一次出现处的索引 |
| 22   | **int lastIndexOf(int ch, int fromIndex)**返回指定字符在此字符串中最后一次出现处的索引，从指定的索引处开始进行反向搜索 |
| 23   | **int lastIndexOf(String str)**返回指定子字符串在此字符串中最右边出现处的索引 |
| 24   | **int lastIndexOf(String str, int fromIndex)**返回指定子字符串在此字符串中最后一次出现处的索引，从指定的索引开始反向搜索 |
| 25   | **int length()**返回此字符串的长度                           |
| 26   | **boolean matches(String regex)**告知此字符串是否匹配给定的正则表达式 |
| 27   | **boolean regionMatches(boolean ignoreCase, int toffset, String other, int ooffset, int len)**测试两个字符串区域是否相等 |
| 28   | **boolean regionMatches(int toffset, String other, int ooffset, int len)**测试两个字符串区域是否相等 |
| 29   | **String replace(char oldChar, char newChar)**返回一个新的字符串，它是通过用 newChar 替换此字符串中出现的所有 oldChar 得到的 |
| 30   | **String replaceAll(String regex, String replacement**使用给定的 replacement 替换此字符串所有匹配给定的正则表达式的子字符串 |
| 31   | **String replaceFirst(String regex, String replacement)**使用给定的 replacement 替换此字符串匹配给定的正则表达式的第一个子字符串 |
| 32   | **String[] split(String regex)**根据给定正则表达式的匹配拆分此字符串 |
| 33   | **String[] split(String regex, int limit)**根据匹配给定的正则表达式来拆分此字符串 |
| 34   | **boolean startsWith(String prefix)**测试此字符串是否以指定的前缀开始 |
| 35   | **boolean startsWith(String prefix, int toffset)**测试此字符串从指定索引开始的子字符串是否以指定前缀开始。 |
| 36   | **CharSequence subSequence(int beginIndex, int endIndex)**返回一个新的字符序列，它是此序列的一个子序列 |
| 37   | **String substring(int beginIndex)**返回一个新的字符串，它是此字符串的一个子字符串 |
| 38   | **String substring(int beginIndex, int endIndex)**返回一个新字符串，它是此字符串的一个子字符串 |
| 39   | **char[] toCharArray()**将此字符串转换为一个新的字符数组     |
| 40   | **String toLowerCase()**使用默认语言环境的规则将此 String 中的所有字符都转换为小写 |
| 41   | **String toLowerCase(Locale locale)**使用给定 Locale 的规则将此 String 中的所有字符都转换为小写 |
| 42   | **String toString()**返回此对象本身（它已经是一个字符串！）  |
| 43   | **String toUpperCase()**使用默认语言环境的规则将此 String 中的所有字符都转换为大写 |
| 44   | **String toUpperCase(Locale locale)**使用给定 Locale 的规则将此 String 中的所有字符都转换为大写 |
| 45   | **String trim()**删除指定字符串的首尾空白符                  |
| 46   | **static String valueOf(primitive data type x)**返回指定类型参数的字符串表示形式 |

## 处理数组

数组的元素类型和数组的大小都是确定的，所以当处理数组元素时候，我们通常使用基本的 for 循环。

以下实例演示了数组的创建，初始化等处理过程：

```scala
object Test {
   def main(args: Array[String]) {
      var myList = Array(1.9, 2.9, 3.4, 3.5)
      
      // 输出所有数组元素
      for ( x <- myList ) {
         println( x )
      }

      // 计算数组所有元素的总和
      var total = 0.0;
      for ( i <- 0 to (myList.length - 1)) {
         total += myList(i);
      }
      println("总和为 " + total);

      // 查找数组中的最大元素
      var max = myList(0);
      for ( i <- 1 to (myList.length - 1) ) {
         if (myList(i) > max) max = myList(i);
      }
      println("最大值为 " + max);
    
   }
}

// 二维数组
object Test {
   def main(args: Array[String]) {
      var myMatrix = ofDim[Int](3,3)
      
      // 创建矩阵
      for (i <- 0 to 2) {
         for ( j <- 0 to 2) {
            myMatrix(i)(j) = j;
         }
      }
      
      // 打印二维阵列
      for (i <- 0 to 2) {
         for ( j <- 0 to 2) {
            print(" " + myMatrix(i)(j));
         }
         println();
      }
    
   }
}
```

## Scala 数组方法

下表中为 Scala 语言中处理数组的重要方法，使用它前我们需要使用 **import Array._** 引入包。

| 序号 | 方法和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **def apply( x: T, xs: T\* ): Array[T]**创建指定对象 T 的数组, T 的值可以是 Unit, Double, Float, Long, Int, Char, Short, Byte, Boolean。 |
| 2    | **def concat[T]( xss: Array[T]\* ): Array[T]**合并数组       |
| 3    | **def copy( src: AnyRef, srcPos: Int, dest: AnyRef, destPos: Int, length: Int ): Unit**复制一个数组到另一个数组上。相等于 Java's System.arraycopy(src, srcPos, dest, destPos, length)。 |
| 4    | **def empty[T]: Array[T]**返回长度为 0 的数组                |
| 5    | **def iterate[T]( start: T, len: Int )( f: (T) => T ): Array[T]**返回指定长度数组，每个数组元素为指定函数的返回值。以上实例数组初始值为 0，长度为 3，计算函数为**a=>a+1**：`scala> Array.iterate(0,3)(a=>a+1) res1: Array[Int] = Array(0, 1, 2)` |
| 6    | **def fill[T]( n: Int )(elem: => T): Array[T]**返回数组，长度为第一个参数指定，同时每个元素使用第二个参数进行填充。 |
| 7    | **def fill[T]( n1: Int, n2: Int )( elem: => T ): Array[Array[T]]**返回二数组，长度为第一个参数指定，同时每个元素使用第二个参数进行填充。 |
| 8    | **def ofDim[T]( n1: Int ): Array[T]**创建指定长度的数组      |
| 9    | **def ofDim[T]( n1: Int, n2: Int ): Array[Array[T]]**创建二维数组 |
| 10   | **def ofDim[T]( n1: Int, n2: Int, n3: Int ): Array[Array[Array[T]]]**创建三维数组 |
| 11   | **def range( start: Int, end: Int, step: Int ): Array[Int]**创建指定区间内的数组，step 为每个元素间的步长 |
| 12   | **def range( start: Int, end: Int ): Array[Int]**创建指定区间内的数组 |
| 13   | **def tabulate[T]( n: Int )(f: (Int)=> T): Array[T]**返回指定长度数组，每个数组元素为指定函数的返回值，默认从 0 开始。以上实例返回 3 个元素：`scala> Array.tabulate(3)(a => a + 5) res0: Array[Int] = Array(5, 6, 7)` |
| 14   | **def tabulate[T]( n1: Int, n2: Int )( f: (Int, Int ) => T): Array[Array[T]]**返回指定长度的二维数组，每个数组元素为指定函数的返回值，默认从 0 开始。 |

## Scala 集合



| 序号 | 集合及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | [Scala List(列表)](https://www.runoob.com/scala/scala-lists.html)List的特征是其元素以线性方式存储，集合中可以存放重复对象。参考 [API文档](http://www.scala-lang.org/api/current/scala/collection/immutable/List.html) |
| 2    | [Scala Set(集合)](https://www.runoob.com/scala/scala-sets.html)Set是最简单的一种集合。集合中的对象不按特定的方式排序，并且没有重复对象。参考 [API文档](http://www.scala-lang.org/api/current/scala/collection/immutable/Set.html) |
| 3    | [Scala Map(映射)](https://www.runoob.com/scala/scala-maps.html)Map 是一种把键对象和值对象映射的集合，它的每一个元素都包含一对键对象和值对象。参考 [API文档](http://www.scala-lang.org/api/current/scala/collection/immutable/Map.html) |
| 4    | [Scala 元组](https://www.runoob.com/scala/scala-tuples.html)元组是不同类型的值的集合 |
| 5    | [Scala Option](https://www.runoob.com/scala/scala-options.html)Option[T] 表示有可能包含值的容器，也可能不包含值。 |
| 6    | [Scala Iterator（迭代器）](https://www.runoob.com/scala/scala-iterators.html) |



### Scala Array方法

下表中为 Scala 语言中处理数组的重要方法，使用它前我们需要使用 **import Array._** 引入包。

| 序号 | 方法和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **def apply( x: T, xs: T\* ): Array[T]**创建指定对象 T 的数组, T 的值可以是 Unit, Double, Float, Long, Int, Char, Short, Byte, Boolean。 |
| 2    | **def concat[T]( xss: Array[T]\* ): Array[T]**合并数组       |
| 3    | **def copy( src: AnyRef, srcPos: Int, dest: AnyRef, destPos: Int, length: Int ): Unit**复制一个数组到另一个数组上。相等于 Java's System.arraycopy(src, srcPos, dest, destPos, length)。 |
| 4    | **def empty[T]: Array[T]**返回长度为 0 的数组                |
| 5    | **def iterate[T]( start: T, len: Int )( f: (T) => T ): Array[T]**返回指定长度数组，每个数组元素为指定函数的返回值。以上实例数组初始值为 0，长度为 3，计算函数为**a=>a+1**：`scala> Array.iterate(0,3)(a=>a+1) res1: Array[Int] = Array(0, 1, 2)` |
| 6    | **def fill[T]( n: Int )(elem: => T): Array[T]**返回数组，长度为第一个参数指定，同时每个元素使用第二个参数进行填充。 |
| 7    | **def fill[T]( n1: Int, n2: Int )( elem: => T ): Array[Array[T]]**返回二数组，长度为第一个参数指定，同时每个元素使用第二个参数进行填充。 |
| 8    | **def ofDim[T]( n1: Int ): Array[T]**创建指定长度的数组      |
| 9    | **def ofDim[T]( n1: Int, n2: Int ): Array[Array[T]]**创建二维数组 |
| 10   | **def ofDim[T]( n1: Int, n2: Int, n3: Int ): Array[Array[Array[T]]]**创建三维数组 |
| 11   | **def range( start: Int, end: Int, step: Int ): Array[Int]**创建指定区间内的数组，step 为每个元素间的步长 |
| 12   | **def range( start: Int, end: Int ): Array[Int]**创建指定区间内的数组 |
| 13   | **def tabulate[T]( n: Int )(f: (Int)=> T): Array[T]**返回指定长度数组，每个数组元素为指定函数的返回值，默认从 0 开始。以上实例返回 3 个元素：`scala> Array.tabulate(3)(a => a + 5) res0: Array[Int] = Array(5, 6, 7)` |
| 14   | **def tabulate[T]( n1: Int, n2: Int )( f: (Int, Int ) => T): Array[Array[T]]**返回指定长度的二维数组，每个数组元素为指定函数的返回值，默认从 0 开始。 |

### Scala List 常用方法

下表列出了 Scala List 常用的方法：

| 序号 | 方法及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **def +:(elem: A): List[A]**为列表预添加元素`scala> val x = List(1) x: List[Int] = List(1)  scala> val y = 2 +: x y: List[Int] = List(2, 1)  scala> println(x) List(1)` |
| 2    | **def ::(x: A): List[A]**在列表开头添加元素                  |
| 3    | **def :::(prefix: List[A]): List[A]**在列表开头添加指定列表的元素 |
| 4    | **def :+(elem: A): List[A]**复制添加元素后列表。`scala> val a = List(1) a: List[Int] = List(1)  scala> val b = a :+ 2 b: List[Int] = List(1, 2)  scala> println(a) List(1)` |
| 5    | **def addString(b: StringBuilder): StringBuilder**将列表的所有元素添加到 StringBuilder |
| 6    | **def addString(b: StringBuilder, sep: String): StringBuilder**将列表的所有元素添加到 StringBuilder，并指定分隔符 |
| 7    | **def apply(n: Int): A**通过列表索引获取元素                 |
| 8    | **def contains(elem: Any): Boolean**检测列表中是否包含指定的元素 |
| 9    | **def copyToArray(xs: Array[A], start: Int, len: Int): Unit**将列表的元素复制到数组中。 |
| 10   | **def distinct: List[A]**去除列表的重复元素，并返回新列表    |
| 11   | **def drop(n: Int): List[A]**丢弃前n个元素，并返回新列表     |
| 12   | **def dropRight(n: Int): List[A]**丢弃最后n个元素，并返回新列表 |
| 13   | **def dropWhile(p: (A) => Boolean): List[A]**从左向右丢弃元素，直到条件p不成立 |
| 14   | **def endsWith[B](that: Seq[B]): Boolean**检测列表是否以指定序列结尾 |
| 15   | **def equals(that: Any): Boolean**判断是否相等               |
| 16   | **def exists(p: (A) => Boolean): Boolean**判断列表中指定条件的元素是否存在。判断l是否存在某个元素:`scala> l.exists(s => s == "Hah") res7: Boolean = true` |
| 17   | **def filter(p: (A) => Boolean): List[A]**输出符号指定条件的所有元素。过滤出长度为3的元素:`scala> l.filter(s => s.length == 3) res8: List[String] = List(Hah, WOW)` |
| 18   | **def forall(p: (A) => Boolean): Boolean**检测所有元素。例如：判断所有元素是否以"H"开头：scala> l.forall(s => s.startsWith("H")) res10: Boolean = false |
| 19   | **def foreach(f: (A) => Unit): Unit**将函数应用到列表的所有元素 |
| 20   | **def head: A**获取列表的第一个元素                          |
| 21   | **def indexOf(elem: A, from: Int): Int**从指定位置 from 开始查找元素第一次出现的位置 |
| 22   | **def init: List[A]**返回所有元素，除了最后一个              |
| 23   | **def intersect(that: Seq[A]): List[A]**计算多个集合的交集   |
| 24   | **def isEmpty: Boolean**检测列表是否为空                     |
| 25   | **def iterator: Iterator[A]**创建一个新的迭代器来迭代元素    |
| 26   | **def last: A**返回最后一个元素                              |
| 27   | **def lastIndexOf(elem: A, end: Int): Int**在指定的位置 end 开始查找元素最后出现的位置 |
| 28   | **def length: Int**返回列表长度                              |
| 29   | **def map[B](f: (A) => B): List[B]**通过给定的方法将所有元素重新计算 |
| 30   | **def max: A**查找最大元素                                   |
| 31   | **def min: A**查找最小元素                                   |
| 32   | **def mkString: String**列表所有元素作为字符串显示           |
| 33   | **def mkString(sep: String): String**使用分隔符将列表所有元素作为字符串显示 |
| 34   | **def reverse: List[A]**列表反转                             |
| 35   | **def sorted[B >: A]: List[A]**列表排序                      |
| 36   | **def startsWith[B](that: Seq[B], offset: Int): Boolean**检测列表在指定位置是否包含指定序列 |
| 37   | **def sum: A**计算集合元素之和                               |
| 38   | **def tail: List[A]**返回所有元素，除了第一个                |
| 39   | **def take(n: Int): List[A]**提取列表的前n个元素             |
| 40   | **def takeRight(n: Int): List[A]**提取列表的后n个元素        |
| 41   | **def toArray: Array[A]**列表转换为数组                      |
| 42   | **def toBuffer[B >: A]: Buffer[B]**返回缓冲区，包含了列表的所有元素 |
| 43   | **def toMap[T, U]: Map[T, U]**List 转换为 Map                |
| 44   | **def toSeq: Seq[A]**List 转换为 Seq                         |
| 45   | **def toSet[B >: A]: Set[B]**List 转换为 Set                 |
| 46   | **def toString(): String**列表转换为字符串                   |

### Scala Set 常用方法

下表列出了 Scala Set 常用的方法：

| 序号 | 方法及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **def +(elem: A): Set[A]**为集合添加新元素，x并创建一个新的集合，除非元素已存在 |
| 2    | **def -(elem: A): Set[A]**移除集合中的元素，并创建一个新的集合 |
| 3    | **def contains(elem: A): Boolean**如果元素在集合中存在，返回 true，否则返回 false。 |
| 4    | **def &(that: Set[A]): Set[A]**返回两个集合的交集            |
| 5    | **def &~(that: Set[A]): Set[A]**返回两个集合的差集           |
| 6    | **def +(elem1: A, elem2: A, elems: A\*): Set[A]**通过添加传入指定集合的元素创建一个新的不可变集合 |
| 7    | **def ++(elems: A): Set[A]**合并两个集合                     |
| 8    | **def -(elem1: A, elem2: A, elems: A\*): Set[A]**通过移除传入指定集合的元素创建一个新的不可变集合 |
| 9    | **def addString(b: StringBuilder): StringBuilder**将不可变集合的所有元素添加到字符串缓冲区 |
| 10   | **def addString(b: StringBuilder, sep: String): StringBuilder**将不可变集合的所有元素添加到字符串缓冲区，并使用指定的分隔符 |
| 11   | **def apply(elem: A)**检测集合中是否包含指定元素             |
| 12   | **def count(p: (A) => Boolean): Int**计算满足指定条件的集合元素个数 |
| 13   | **def copyToArray(xs: Array[A], start: Int, len: Int): Unit**复制不可变集合元素到数组 |
| 14   | **def diff(that: Set[A]): Set[A]**比较两个集合的差集         |
| 15   | **def drop(n: Int): Set[A]]**返回丢弃前n个元素新集合         |
| 16   | **def dropRight(n: Int): Set[A]**返回丢弃最后n个元素新集合   |
| 17   | **def dropWhile(p: (A) => Boolean): Set[A]**从左向右丢弃元素，直到条件p不成立 |
| 18   | **def equals(that: Any): Boolean**equals 方法可用于任意序列。用于比较系列是否相等。 |
| 19   | **def exists(p: (A) => Boolean): Boolean**判断不可变集合中指定条件的元素是否存在。 |
| 20   | **def filter(p: (A) => Boolean): Set[A]**输出符合指定条件的所有不可变集合元素。 |
| 21   | **def find(p: (A) => Boolean): Option[A]**查找不可变集合中满足指定条件的第一个元素 |
| 22   | **def forall(p: (A) => Boolean): Boolean**查找不可变集合中满足指定条件的所有元素 |
| 23   | **def foreach(f: (A) => Unit): Unit**将函数应用到不可变集合的所有元素 |
| 24   | **def head: A**获取不可变集合的第一个元素                    |
| 25   | **def init: Set[A]**返回所有元素，除了最后一个               |
| 26   | **def intersect(that: Set[A]): Set[A]**计算两个集合的交集    |
| 27   | **def isEmpty: Boolean**判断集合是否为空                     |
| 28   | **def iterator: Iterator[A]**创建一个新的迭代器来迭代元素    |
| 29   | **def last: A**返回最后一个元素                              |
| 30   | **def map[B](f: (A) => B): immutable.Set[B]**通过给定的方法将所有元素重新计算 |
| 31   | **def max: A**查找最大元素                                   |
| 32   | **def min: A**查找最小元素                                   |
| 33   | **def mkString: String**集合所有元素作为字符串显示           |
| 34   | **def mkString(sep: String): String**使用分隔符将集合所有元素作为字符串显示 |
| 35   | **def product: A**返回不可变集合中数字元素的积。             |
| 36   | **def size: Int**返回不可变集合元素的数量                    |
| 37   | **def splitAt(n: Int): (Set[A], Set[A])**把不可变集合拆分为两个容器，第一个由前 n 个元素组成，第二个由剩下的元素组成 |
| 38   | **def subsetOf(that: Set[A]): Boolean**如果集合中含有子集返回 true，否则返回false |
| 39   | **def sum: A**返回不可变集合中所有数字元素之和               |
| 40   | **def tail: Set[A]**返回一个不可变集合中除了第一元素之外的其他元素 |
| 41   | **def take(n: Int): Set[A]**返回前 n 个元素                  |
| 42   | **def takeRight(n: Int):Set[A]**返回后 n 个元素              |
| 43   | **def toArray: Array[A]**将集合转换为数组                    |
| 44   | **def toBuffer[B >: A]: Buffer[B]**返回缓冲区，包含了不可变集合的所有元素 |
| 45   | **def toList: List[A]**返回 List，包含了不可变集合的所有元素 |
| 46   | **def toMap[T, U]: Map[T, U]**返回 Map，包含了不可变集合的所有元素 |
| 47   | **def toSeq: Seq[A]**返回 Seq，包含了不可变集合的所有元素    |
| 48   | **def toString(): String**返回一个字符串，以对象来表示       |

### Scala Map 常用方法

下表列出了 Scala Map 常用的方法：

| 序号 | 方法及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **def ++(xs: Map[(A, B)]): Map[A, B]**返回一个新的 Map，新的 Map xs 组成 |
| 2    | **def -(elem1: A, elem2: A, elems: A\*): Map[A, B]**返回一个新的 Map, 移除 key 为 elem1, elem2 或其他 elems。 |
| 3    | **def --(xs: GTO[A]): Map[A, B]**返回一个新的 Map, 移除 xs 对象中对应的 key |
| 4    | **def get(key: A): Option[B]**返回指定 key 的值              |
| 5    | **def iterator: Iterator[(A, B)]**创建新的迭代器，并输出 key/value 对 |
| 6    | **def addString(b: StringBuilder): StringBuilder**将 Map 中的所有元素附加到StringBuilder，可加入分隔符 |
| 7    | **def addString(b: StringBuilder, sep: String): StringBuilder**将 Map 中的所有元素附加到StringBuilder，可加入分隔符 |
| 8    | **def apply(key: A): B**返回指定键的值，如果不存在返回 Map 的默认方法 |
| 9    | **def clear(): Unit**清空 Map                                |
| 10   | **def clone(): Map[A, B]**从一个 Map 复制到另一个 Map        |
| 11   | **def contains(key: A): Boolean**如果 Map 中存在指定 key，返回 true，否则返回 false。 |
| 12   | **def copyToArray(xs: Array[(A, B)]): Unit**复制集合到数组   |
| 13   | **def count(p: ((A, B)) => Boolean): Int**计算满足指定条件的集合元素数量 |
| 14   | **def default(key: A): B**定义 Map 的默认值，在 key 不存在时返回。 |
| 15   | **def drop(n: Int): Map[A, B]**返回丢弃前n个元素新集合       |
| 16   | **def dropRight(n: Int): Map[A, B]**返回丢弃最后n个元素新集合 |
| 17   | **def dropWhile(p: ((A, B)) => Boolean): Map[A, B]**从左向右丢弃元素，直到条件p不成立 |
| 18   | **def empty: Map[A, B]**返回相同类型的空 Map                 |
| 19   | **def equals(that: Any): Boolean**如果两个 Map 相等(key/value 均相等)，返回true，否则返回false |
| 20   | **def exists(p: ((A, B)) => Boolean): Boolean**判断集合中指定条件的元素是否存在 |
| 21   | **def filter(p: ((A, B))=> Boolean): Map[A, B]**返回满足指定条件的所有集合 |
| 22   | **def filterKeys(p: (A) => Boolean): Map[A, B]**返回符合指定条件的不可变 Map |
| 23   | **def find(p: ((A, B)) => Boolean): Option[(A, B)]**查找集合中满足指定条件的第一个元素 |
| 24   | **def foreach(f: ((A, B)) => Unit): Unit**将函数应用到集合的所有元素 |
| 25   | **def init: Map[A, B]**返回所有元素，除了最后一个            |
| 26   | **def isEmpty: Boolean**检测 Map 是否为空                    |
| 27   | **def keys: Iterable[A]**返回所有的key/p>                    |
| 28   | **def last: (A, B)**返回最后一个元素                         |
| 29   | **def max: (A, B)**查找最大元素                              |
| 30   | **def min: (A, B)**查找最小元素                              |
| 31   | **def mkString: String**集合所有元素作为字符串显示           |
| 32   | **def product: (A, B)**返回集合中数字元素的积。              |
| 33   | **def remove(key: A): Option[B]**移除指定 key                |
| 34   | **def retain(p: (A, B) => Boolean): Map.this.type**如果符合满足条件的返回 true |
| 35   | **def size: Int**返回 Map 元素的个数                         |
| 36   | **def sum: (A, B)**返回集合中所有数字元素之和                |
| 37   | **def tail: Map[A, B]**返回一个集合中除了第一元素之外的其他元素 |
| 38   | **def take(n: Int): Map[A, B]**返回前 n 个元素               |
| 39   | **def takeRight(n: Int): Map[A, B]**返回后 n 个元素          |
| 40   | **def takeWhile(p: ((A, B)) => Boolean): Map[A, B]**返回满足指定条件的元素 |
| 41   | **def toArray: Array[(A, B)]**集合转数组                     |
| 42   | **def toBuffer[B >: A]: Buffer[B]**返回缓冲区，包含了 Map 的所有元素 |
| 43   | **def toList: List[A]**返回 List，包含了 Map 的所有元素      |
| 44   | **def toSeq: Seq[A]**返回 Seq，包含了 Map 的所有元素         |
| 45   | **def toSet: Set[A]**返回 Set，包含了 Map 的所有元素         |
| 46   | **def toString(): String**返回字符串对象                     |

### Scala Iterator 常用方法

下表列出了 Scala Iterator 常用的方法：

| 序号 | 方法及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **def hasNext: Boolean**如果还有可返回的元素，返回true。     |
| 2    | **def next(): A**返回迭代器的下一个元素，并且更新迭代器的状态 |
| 3    | **def ++(that: => Iterator[A]): Iterator[A]**合并两个迭代器  |
| 4    | **def ++[B >: A](that :=> GenTraversableOnce[B]): Iterator[B]**合并两个迭代器 |
| 5    | **def addString(b: StringBuilder): StringBuilder**添加一个字符串到 StringBuilder b |
| 6    | **def addString(b: StringBuilder, sep: String): StringBuilder**添加一个字符串到 StringBuilder b，并指定分隔符 |
| 7    | **def buffered: BufferedIterator[A]**迭代器都转换成 BufferedIterator |
| 8    | **def contains(elem: Any): Boolean**检测迭代器中是否包含指定元素 |
| 9    | **def copyToArray(xs: Array[A], start: Int, len: Int): Unit**将迭代器中选定的值传给数组 |
| 10   | **def count(p: (A) => Boolean): Int**返回迭代器元素中满足条件p的元素总数。 |
| 11   | **def drop(n: Int): Iterator[A]**返回丢弃前n个元素新集合     |
| 12   | **def dropWhile(p: (A) => Boolean): Iterator[A]**从左向右丢弃元素，直到条件p不成立 |
| 13   | **def duplicate: (Iterator[A], Iterator[A])**生成两个能分别返回迭代器所有元素的迭代器。 |
| 14   | **def exists(p: (A) => Boolean): Boolean**返回一个布尔值，指明迭代器元素中是否存在满足p的元素。 |
| 15   | **def filter(p: (A) => Boolean): Iterator[A]**返回一个新迭代器 ，指向迭代器元素中所有满足条件p的元素。 |
| 16   | **def filterNot(p: (A) => Boolean): Iterator[A]**返回一个迭代器，指向迭代器元素中不满足条件p的元素。 |
| 17   | **def find(p: (A) => Boolean): Option[A]**返回第一个满足p的元素或None。注意：如果找到满足条件的元素，迭代器会被置于该元素之后；如果没有找到，会被置于终点。 |
| 18   | **def flatMap[B](f: (A) => GenTraversableOnce[B]): Iterator[B]**针对迭代器的序列中的每个元素应用函数f，并返回指向结果序列的迭代器。 |
| 19   | **def forall(p: (A) => Boolean): Boolean**返回一个布尔值，指明 it 所指元素是否都满足p。 |
| 20   | **def foreach(f: (A) => Unit): Unit**在迭代器返回的每个元素上执行指定的程序 f |
| 21   | **def hasDefiniteSize: Boolean**如果迭代器的元素个数有限则返回 true（默认等同于 isEmpty） |
| 22   | **def indexOf(elem: B): Int**返回迭代器的元素中index等于x的第一个元素。注意：迭代器会越过这个元素。 |
| 23   | **def indexWhere(p: (A) => Boolean): Int**返回迭代器的元素中下标满足条件p的元素。注意：迭代器会越过这个元素。 |
| 24   | **def isEmpty: Boolean**检查it是否为空, 为空返回 true，否则返回false（与hasNext相反）。 |
| 25   | **def isTraversableAgain: Boolean**Tests whether this Iterator can be repeatedly traversed. |
| 26   | **def length: Int**返回迭代器元素的数量。                    |
| 27   | **def map[B](f: (A) => B): Iterator[B]**将 it 中的每个元素传入函数 f 后的结果生成新的迭代器。 |
| 28   | **def max: A**返回迭代器迭代器元素中最大的元素。             |
| 29   | **def min: A**返回迭代器迭代器元素中最小的元素。             |
| 30   | **def mkString: String**将迭代器所有元素转换成字符串。       |
| 31   | **def mkString(sep: String): String**将迭代器所有元素转换成字符串，并指定分隔符。 |
| 32   | **def nonEmpty: Boolean**检查容器中是否包含元素（相当于 hasNext）。 |
| 33   | **def padTo(len: Int, elem: A): Iterator[A]**首先返回迭代器所有元素，追加拷贝 elem 直到长度达到 len。 |
| 34   | **def patch(from: Int, patchElems: Iterator[B], replaced: Int): Iterator[B]**返回一个新迭代器，其中自第 from 个元素开始的 replaced 个元素被迭代器所指元素替换。 |
| 35   | **def product: A**返回迭代器所指数值型元素的积。             |
| 36   | **def sameElements(that: Iterator[_]): Boolean**判断迭代器和指定的迭代器参数是否依次返回相同元素 |
| 37   | **def seq: Iterator[A]**返回集合的系列视图                   |
| 38   | **def size: Int**返回迭代器的元素数量                        |
| 39   | **def slice(from: Int, until: Int): Iterator[A]**返回一个新的迭代器，指向迭代器所指向的序列中从开始于第 from 个元素、结束于第 until 个元素的片段。 |
| 40   | **def sum: A**返回迭代器所指数值型元素的和                   |
| 41   | **def take(n: Int): Iterator[A]**返回前 n 个元素的新迭代器。 |
| 42   | **def toArray: Array[A]**将迭代器指向的所有元素归入数组并返回。 |
| 43   | **def toBuffer: Buffer[B]**将迭代器指向的所有元素拷贝至缓冲区 Buffer。 |
| 44   | **def toIterable: Iterable[A]**Returns an Iterable containing all elements of this traversable or iterator. This will not terminate for infinite iterators. |
| 45   | **def toIterator: Iterator[A]**把迭代器的所有元素归入一个Iterator容器并返回。 |
| 46   | **def toList: List[A]**把迭代器的所有元素归入列表并返回      |
| 47   | **def toMap[T, U]: Map[T, U]**将迭代器的所有键值对归入一个Map并返回。 |
| 48   | **def toSeq: Seq[A]**将代器的所有元素归入一个Seq容器并返回。 |
| 49   | **def toString(): String**将迭代器转换为字符串               |
| 50   | **def zip[B](that: Iterator[B]): Iterator[(A, B)**返回一个新迭代器，指向分别由迭代器和指定的迭代器 that 元素一一对应而成的二元组序列 |



### scala 元组

```scala
val t = (1, 3.14, "Fred") 
或
val t = new Tuple3(1, 3.14, "Fred")

new Tuple6(1,"heh", 12312.1,.....)


object Test {
   def main(args: Array[String]) {
      val t = (4,3,2,1)

      val sum = t._1 + t._2 + t._3 + t._4 	//	访问Tuple

      println( "元素之和为: "  + sum )
   }
}
```



## Scala 文件 I/O

Scala 进行文件写操作，直接用的都是 java中 的 I/O 类 （**java.io.File**)：

```
import java.io._

object Test {
   def main(args: Array[String]) {
      val writer = new PrintWriter(new File("test.txt" ))

      writer.write("菜鸟教程")
      writer.close()
   }
}
```

执行以上代码，会在你的当前目录下生产一个 test.txt 文件，文件内容为"菜鸟教程":

```
$ scalac Test.scala 
$ scala Test
$ cat test.txt 
菜鸟教程
```

### 从屏幕上读取用户输入

有时候我们需要接收用户在屏幕输入的指令来处理程序。实例如下：

```scala
import scala.io._
object Test {
   def main(args: Array[String]) {
      print("请输入菜鸟教程官网 : " )
      val line = StdIn.readLine()

      println("谢谢，你输入的是: " + line)
   }
}
```

> Scala2.11 后的版本 **Console.readLine** 已废弃，使用 **scala.io.StdIn.readLine()** 方法代替。

执行以上代码，屏幕上会显示如下信息:

```scala
$ scalac Test.scala 
$ scala Test
请输入菜鸟教程官网 : www.runoob.com
谢谢，你输入的是: www.runoob.com
```

### 从文件上读取内容

从文件读取内容非常简单。我们可以使用 Scala 的 **Source** 类及伴生对象来读取文件。以下实例演示了从 "test.txt"(之前已创建过) 文件中读取内容:

```scala
import scala.io.Source

object Test {
   def main(args: Array[String]) {
      println("文件内容为:" )

      Source.fromFile("test.txt" ).foreach{ 
         print 
      }
   }
}
```

执行以上代码，输出结果为:

```scala
$ scalac Test.scala 
$ scala Test
文件内容为:
菜鸟教程
```



## scala的一些符号

[Scala中_(下划线)的常见用法](https://www.jianshu.com/p/0497583ec538)

[浅谈 Scala 中下划线的用途](https://my.oschina.net/leejun2005/blog/405305)

[Scala基础 - 下划线使用指南](https://my.oschina.net/joymufeng/blog/863823)

[scala中各种符号的意思](https://blog.csdn.net/datadev_sh/article/details/79854273)

**<-**

​	只会出现在for循环里面

**->**

​	只会出现在k->v里面：返回一个二元的元组

```scala
scala> 1 -> 2
res9: (Int, Int) = (1,2)
```



**=>**

1. 函数作为参数
2. 匿名函数

**_**:https://my.oschina.net/joymufeng/blog/863823

1.  将方法转换位函数（方法无法传递，函数可以传递）
2. 简写匿名函数中只出现一次的变量
3. 类成员默认值
4. match的default







