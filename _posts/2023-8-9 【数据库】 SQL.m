# 1. SQL语法
## 1.1 join on 后跟条件与where 区别

select * from t1
left join t2
on t1.a=xxx

与 select * from t1  条数一样。也就是说left join是on t1表t2表的关联条件已经确定基表条数，on加入t1条件不会影响基表条数 


select * from t1
join t2
on t1.a=xxx

与 select * from t1 where  t1.a=xxx 条数差异相对较少

