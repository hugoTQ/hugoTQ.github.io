# redis命令 

标签（空格分隔）： redis

---
[TOC]

### HSetNX
>将哈希表 key 中的域 field 的值设置为 value ，当且仅当域 field 不存在。
>若域 field 已经存在，该操作无效。
>如果 key 不存在，一个新哈希表被创建并执行 HSETNX 命令
```SHELL
`HSETNX key field value`
redis> HSETNX nosql key-value-store redis
(integer) 1

redis> HSETNX nosql key-value-store redis       # 操作无效，域 key-value-store 已存在
(integer) 0
```

