# golang map

标签（空格分隔）： go

---

# [原地修改map](https://www.jianshu.com/p/30e86473bdce)
```go
    s2 := make(map[string]*int)
    n := 1
    s2["chenchao"] = &n
    fmt.Println(s2)
```