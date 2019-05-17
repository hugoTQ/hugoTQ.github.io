# Golang 学习笔记

标签（空格分隔）： go

---
[TOC]

# go学习资料

-  博客
    - https://colobu.com/categories/Go/
-  文章
    - [[]T 还是[]*T, 这是一个问题](https://colobu.com/2017/01/05/-T-or-T-it-s-a-question/)
    - [年终盘点！2017年超有价值的Golang文章述][1]



#基本语法
## printf格式化
一般：

%v   基本格式的值。当输出结构体时，扩展标志(%+v)添加成员的名字。the value in a default format.

     when printing structs, the plus flag (%+v) adds field names

%#v  值的Go语法表示。

%T   值的类型的Go语法表示。

%%   百分号。

布尔型：

%t   值的true或false

整型：

%b   二进制表示

%c   数值对应的Unicode编码字符

%d   十进制表示

%o   八进制表示

%q   单引号

%x   十六进制表示，使用a-f

%X   十六进制表示，使用A-F

%U   Unicode格式： U+1234，等价于"U+%04X"

浮点数：

%b   无小数部分、两位指数的科学计数法，和strconv.FormatFloat的'b'转换格式一致。举例：-123456p-78

%e   科学计数法，举例：-1234.456e+78

%E   科学计数法，举例：-1234.456E+78

%f   有小数部分，但无指数部分，举例：123.456

%g   根据实际情况采用%e或%f格式（以获得更简洁的输出）

%G   根据实际情况采用%E或%f格式（以获得更简洁的输出）

字符串和byte切片类型：

%s   直接输出字符串或者[]byte

%q   双引号括起来的字符串

%x   每个字节用两字符十六进制数表示（使用小写a-f）

%X   每个字节用两字符十六进制数表示（使用大写A-F）

指针：

%p   0x开头的十六进制数表示

木有'u'标志。如果是无类型整数，自然会打印无类型格式。类似的，没有必要去区分操作数的大小(int8, int64)。

宽度和精度格式化控制是指的Unicode编码字符的数量（不同于C的printf，它的这两个因子指的是字节的数量。）两者均可以使用'*'号取代（任一个或两个都），此时它们的值将被紧接着的参数控制，这个操作数必须是整型。

对于数字，宽度设置总长度，精度设置小数部分长度。例如，格式%6.2f 输出123.45。

对于字符串，宽度是输出字符数目的最低数量，如果不足会用空格填充。精度是输出字符数目的最大数量，超过则会截断。

其它符号：

+    总是输出数值的正负号；对%q(%+q)将保证纯ASCII码输出

- 用空格在右侧填充空缺而不是默认的左侧。

  切换格式：在八进制前加0(%#o)，十六进制前加0x(%#x)或0X(%#X)；废除指针的0x(%#p)；

   对%q (%#q)如果可能的话输出一个无修饰的字符串；

   对%U(%#U)如果对应数值是可打印字符输出该字符。

' '  对数字(% d)空格会留一个空格在数字前并忽略数字的正负号；

     对切片和字符串(% x, % X)会以16进制输出。

0    用前置0代替空格填补空缺。

每一个类似Printf的函数，都会有一个同样的Print函数，此函数不需要format字符串，等价于对每一个参数设置为%v。另一个变体Println会在参数之间加上空格并在输出结束后换行。

如果参数是一个接口值，将使用内在的具体实现的值，而不是接口本身，%v参数不会被使用。如下：

var i interface{} = 23

fmt.Printf("%v\n", i)

将输出23。

如果参数实现了Formatter接口，该接口可用来更好的控制格式化。

如果格式（标志对Println等是隐含的%v）是专用于字符串的(%s %q %v %x %X)，还提供了如下两个规则：

1. 如果一个参数实现了error接口，Error方法会用来将目标转化为字符串，随后将被按给出的要求格式化。

2. 如果参数提供了String方法，这个方法将被用来将目标转换为字符串，然后将按给出的格式标志格式化。

为了避免有可能的递归循环，例如：

type X string

func (x X) String() string { return Sprintf("<%s>", x) }

会在递归循环前转换值：

func (x X) String() string { return Sprintf("<%s>", string(x)) }

错误的格式：

如果提供了一个错误的格式标志，例如给一个字符串提供了%d标志，生成的字符串将包含对该问题的描述，如下面的例子：

错误或未知的格式标志: %!verb(type=value)

     Printf("%d", hi):          %!d(string=hi)

太多参数: %!(EXTRA type=value)

     Printf("hi", "guys"):      hi%!(EXTRA string=guys)

缺少参数: %!verb(MISSING)

     Printf("hi%d"):            hi %!d(MISSING)

使用非整数提供宽度和精度: %!(BADWIDTH) or %!(BADPREC)

     Printf("%*s", 4.5, "hi"):  %!(BADWIDTH)hi
    
     Printf("%.*s", 4.5, "hi"): %!(BADPREC)hi

所有的错误都使用"%!"起始，（紧随单字符的格式标志）以括号包围的错误描述结束。

输入

一系列类似的函数读取格式化的文本，生成值。Scan，Scanf和Scanln从os.Stdin读取；Fscan，Fscanf和Fscanln 从特定的io.Reader读取；Sscan，Sscanf和Sscanln 从字符串读取；Scanln，Fscanln和Sscanln在换行时结束读取，并要求数据连续出现；Scanf，Fscanf和Sscanf会读取一整行以匹配格式字符串；其他的函数将换行看着空格。

Scanf, Fscanf, and Sscanf根据格式字符串解析数据，类似于Printf。例如，%x将读取一个十六进制数，%v将读取值的默认表示。

格式行为类似于Printf，但有如下例外：

%p没有提供

%T没有提供

%e %E %f %F %g %G是等价的，都可以读取任何浮点数或者复合数（非复数，指科学计数法表示的带指数的数）

%s 和 %v字符串使用这两个格式读取时会因为空格而结束

不设格式或者使用%v读取整数时，如果前缀为0(八进制)或0x(十六进制)，将按对应进制读取。

宽度在输入中被解释（%5s意思是最多从输入读取5个字符赋值给一个字符串），但输入系列函数没有解释精度的语法(木有%5.2f，只有%5f)。

输入系列函数中的格式字符串，所有非空的空白字符（除了换行符之外），无论在输入里还是格式字符串里，都等价于1个空白字符。格式字符串必须匹配输入的文本，如果不匹配将停止读取数据并返回函数已经赋值的参数的数量。

所有的scan系列函数，如果参数包含Scan方法（或者说实现了Scanner接口），该参数将使用该方法读取文本。另外，如果被填写的参数的数量少于提供的参数的数量，将返回一个错误。

所有要被输入的参数都应该

## 深入理解interface
 https://blog.csdn.net/justaipanda/article/details/43155949

## 理解goroutine
https://blog.csdn.net/justaipanda/article/details/44064811
    
## new() 和 make()的区别


## strings包用法
https://blog.csdn.net/chenbaoke/article/details/40318423


[1]: https://colobu.com/2017/12/28/top-golang-articles-of-2017/

## [go语言会遇到的坑](https://www.imooc.com/article/23959)

## [golang: 类型转换和类型断言](https://my.oschina.net/goal/blog/194308)

##[fmt 源码分析——fmt 如何进行格式化？](http://blog.cyeam.com/golang/2018/09/10/fmt)

##[slice删除元素的性能对比](https://www.jianshu.com/p/d276aa7300d1)