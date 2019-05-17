---
layout: post
title: 'go introduction'
subtitle: 'go 入门'
date: 2018-08-26
categories: 技术
cover: 'http://on2171g4d.bkt.clouddn.com/jekyll-theme-h2o-postcover.jpg'
tags: Go
---

[TOC]
# GoLang basical study
>Roboto Condensed Bold

## function
### 错误处理
go语法糖提供了多返回值，在异常判断非常简便和统一。书中提供一般的错误处理方法：
- 在go语言io标准库以及报告了详细的上下文信息，开发者无需再包含这些信息直接`return err`即可。在调用一些需要报告额外信息的，可使用`return fmt.Errorf("..%v..",err)`。
- 对于不可预测的错误，可以指数退避策略重试再报错。
- 对于一些致命错误，log.Fatalf则退出程序，一般主程序做。
- 忽略错误时应该注释说明理由。

### 匿名函数
#### 闭包
- 定义：闭包是由函数及其相关引用环境组合而成的实体(即：闭包=函数+引用环境)。
- 简单的判断方法：一个函数嵌套了一个匿名函数。
- 函数与闭包的区别：闭包看上去像函数但不是函数。函数只有一个实例，而闭包在运行时可以有多个实例，不同的引用环境和相同的函数组合可以产生不同的实例。
- 对象是附有行为的数据，而闭包是附有数据的行为。

```go
//构造闭包
func intSeq() func() int {
	i := 0
    return func() int {
        i++
        return i
    }
}

func main() {
    nextInt := intSeq()
    fmt.Println(nextInt())
    fmt.Println(nextInt())
    fmt.Println(nextInt())

    newInts := intSeq() //创建新闭包环境
    fmt.Println(newInts())
}

输出：
1
2
3
1
```

### defer
[Go 中 defer 的 5 个坑](https://studygolang.com/articles/12061?fr=sidebar)

### 宕机与recover
recover 后funcA正常退出，进程继续往下走。 recover的返回值p就是panic的入参x
recover有助于简化处理复杂和未知的错误，但这几种情况不宜使用recover: 1.其他包产生的宕机；2.公共的API产生的宕机；3.不由你维护的代码产生的宕机

recover语法：
```GO
func funA(x int) {
	// recover要在panic前定义并使用defer
	defer func(){
		if p := recover; p != nil {
			// recover处理，一般是请理v 和打日志ui看，
		}
	}()

	panic(x)
	fmt.Prinfln("panic 后面的代码不会执行")
}
```


---


## Method
### 一些隐式
1. 无论方法receiver是T还是\*T，都可以使用对象、对象的指针调用（在调用出做了*、&的饮隐式转换），实际的类型就是定义的receiver类型
2. 可以省略匿名的内嵌struct而直接使用该struct下面的所有字段（重名的情况下比较复杂？），同理，也可以直接调用内嵌类型下的方法，不过这区别于继承，具体原理是go语言在编译时额外生成了包装方法。注意这两种省略是必须要该内嵌结构是匿名字段。这个特性引入的高端写法参考

### 方法变量与表达式
```GO
p := new(Point)
DisFromP := p.Distance // 方法变量，从对象中获取方法，receiver已知
dis1 := DisFrom(p2)

funcDis := Point.Distance // 方法表达式，从结构中获取方法，receiver未知
dis2 := funcDis(p1, p2)	// 第一个参数是receiver

```

### 关于封装的好处
1. 使用方不能直接修改对象的变量，所以不需要更多的语句来检查变量的值
2. 隐藏实现细节，减少依赖，增加灵活性和兼容性
3. 防止使用之肆意改变对象内的变量


## 接口
### 什么时候考虑定义接口
先定义类型之前可以先不考虑定义接口，从具体类型出发、提取其共性得出每一种分组方式都可以表示为一种接口类型。GO语言定义接口的好处是，不需要修改原有类型的定义。当需要使用另一个作者包里的具体类型是，只一点特别有用。

### 接口值
接口值包括具体类型和该类型的一个值，即动态类型和动态值。
当接口声明后为赋值，则动态类型和动态值都为nil，接口才会==nil。当空指针赋给接口，接口的动态类型则不为nil，参考go陷阱3


## go陷阱
### 1.for range中使用闭包

错误示例：
```GO
var funs []func()
func main() {
	s := []string{"a", "b", "c"}
	for k, v := range s {
		funs = append(funs, func() {
			fmt.Println(k, v)
		})
	}

	for _, v := range funs {
		v()
	}
}

输出：
2 c
2 c
2 c
```

循环变量作为匿名函数的变量，由于3个匿名函数引用了`k,v`，实际上声明了一个闭包代码，创建了一个闭包，只有一份环境变量。

改进方法：
```GO
var funs []func(int, string)
func main() {
	s := []string{"a", "b", "c"}
	for k, v := range s {
		k1, v1 := k, v
		funs = append(funs, func() {
			fmt.Println(k1, v1)
		})
	}

	for _, v := range funs {
		v()
	}
}

output：
0 a
1 b
2 c
```
由于3个匿名函数引用独立的`k1,v1`，因此实际上可看做声明了3个闭包，创建了3个闭包，有3份环境变量。



### 2.for 里open文件描述符
```GO
for _, filename := range filenames {
	f, err := os.open(filename)
    defer f.Close()	// 注意，defer在最后执行，因此可能会用尽描述符
}
```
解决：
 defer放到另一个函数里
```GO4r
for _, filename := range filenames {
	f, err := doFile(filename)w
}

func doFile(filename string) {
	f, err := os.open(filename)
    defer f.Close()
}
```

### 3.空指针防御无效
```GO
func testInterfaceNil() {
	var a *bytes.Buffer
	fmt.Printf("a is nil=%v\n", a == nil)//a is nil=true
	f(a)
}

func f(a io.Writer) {
	fmt.Printf("a is nil=%v\n", a == nil)//a is nil=false
}
```

解决：
```GO
 func testInterfaceNil() {
	var a *io.Writer
	fmt.Printf("a is nil=%v\n", a == nil)//a is nil=true
	f(a)
}

func f(a io.Writer) {
	fmt.Printf("a is nil=%v\n", a == nil)//a is nil=true
}
```


## Golang的一些技巧

### 1. 一条defer语句实现入口和出口的处理
```GO
func slowOperation() {
	defer trace("slowOperation")()
    //...operation
    time.Sleep(5 * time.Second)
}

func trace(msg string) {
	start := time.Now()
	log.Printf("enter %s", msg)
	return func() { log.Printf("exit %s (%s)", msg, time.Since(start)) }
}

output:
2018/08/26 19:46:10 enter slowOperation
2018/08/26 19:46:15 exit slowOperation (5.000198169s)
```
defer后面跟着一个闭包，程序走到defer时则需要先创建闭包，注意defer语句后面要`（）`

### 2. 利用匿名结构让新定义的结构包含方法，使用更优雅贴切
互斥锁map数据
一般实现：
```GO
var (
	mu sync.Mutex
	mapping = make(map[string]string)
)

func Lookup(key string) string {
	mu.Lock()
	v:=mapping[key]
	mu.Unlock()
	return v
}

```
利用匿名结构:
```GO
var cache = struct {
	sync.Mutex
	mapping map[string]string
}{
	mapping: make(map[string]string),
}

func Lookup(key string) string {
	cache.Lock()
	v := cache.mapping[key]
	cache.Unlock()
	return v
}
```
利用匿名结构使cache可以直接用cache.Lock()，更加贴切，并且限定了锁的使用范围。

### 3.利用声明断言类型实现了接口
```GO
var a A = new(B)// B要必须实现了A接口

var _ A = B(nil)// 若实现断言，可以把变量省略
```