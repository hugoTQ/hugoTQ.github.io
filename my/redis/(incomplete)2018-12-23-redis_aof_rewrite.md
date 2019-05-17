# redis AOF rewrite造成的写入失败(incomplete)

## 现象
1、mConductor每天3点报大量redis nil
2、redis监控显示，每天AOF高达18G，并在凌晨3点做rewrite

## 关于AOF
AOF是redis的一种持久化机制，相较于另一种持久化方式RDB，AOF有这

## 关于AOF rewrite

压缩

### rewrite过程

fork

压缩中，redis操作会放入buf，待rewrite完成再回写到redis

回写默认会阻塞redis，可关闭



## AOF的一些指标



## rewrite策略

增长率

磁盘空间

AOF大小



## 目前公有云rewrite策略

（该策略是18年12月20日，公有云redis不断优化策略，具体可以咨询他们）

凌晨2：00~5：00， 如果aof文件大小超过磁盘20%，就触发一次aof-rewrite
其它时间：如果aof文件大小超过磁盘40%，且业务负载不重就触发一次aof-rewrite，如果超过60%，则强制触发一次aof-rewrite