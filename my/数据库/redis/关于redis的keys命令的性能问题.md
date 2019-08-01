> **Available since 1.0.0.**
>
> **Time complexity:** O(N) with N being the number of keys in the database, under the assumption that the key names in the database and the given pattern have limited length.
>
> Returns all keys matching `pattern`.
>
> While the time complexity for this operation is O(N), the constant times are fairly low. For example, Redis running on an entry level laptop can scan a 1 million key database in 40 milliseconds.
>
> **Warning**: consider [KEYS](https://redis.io/commands/keys) as a command that should only be used in production environments with extreme care. It may ruin performance when it is executed against large databases. This command is intended for debugging and special operations, such as changing your keyspace layout. Don't use [KEYS](https://redis.io/commands/keys) in your regular application code. If you're looking for a way to find keys in a subset of your keyspace, consider using [SCAN](https://redis.io/commands/scan) or [sets](https://redis.io/topics/data-types#sets).
>
> Supported glob-style patterns:

官网说明主要有几点：

1. keys的时间复杂度是O(N)，在入门级笔记本电脑一百万个key耗时40毫秒
2. 不要应出现在常规代码
3. 生产环境慎用
4. 可使用SCAN或者sets代替keys，不会有性能问题

那么问题来了，像HGET时间复杂度也是O(N)，为什么没有性能风险？

SCAN什么原理？



<https://www.jianshu.com/p/2f14bc570563>

<https://cloud.tencent.com/developer/article/1097603>

[redis 用scan 代替keys](https://blog.csdn.net/qq_27623337/article/details/53201202)

