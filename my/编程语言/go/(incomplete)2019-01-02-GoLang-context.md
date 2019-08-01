# GoLang|Context包

控制并发有两种经典的方式，一种是WaitGroup，另一种就是Context，今天我们就谈谈Context。

## 什么是WaitGroup

WaitGroup是一种控制并发的方式，它可以控制多个goroutine同时完成。

```go
func main() {
    
    
    
	var wg sync.WaitGroup

	wg.Add(2)
	go func() {
		time.Sleep(2*time.Second)
		fmt.Println("1号完成")
		wg.Done()
	}()
	go func() {
		time.Sleep(2*time.Second)
		fmt.Println("2号完成")
		wg.Done()
	}()
	wg.Wait()
	fmt.Println("好了，大家都干完了，放工")
}
```

## Context

```django
ctx, cancel := context.WithCancel(context.TODO())
```

```Go
ctx, cancel := context.WithCancel(context.Background())
```



上面两个哟啥区别？