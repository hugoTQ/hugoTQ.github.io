# Hive分区表学习总结

## 前言

用了这么久的Hive，而没有认真的学习和使用过Hive的分区，现在学习记录一下。

> - 分区表一般在数据量比较大，且有明确的分区字段时使用，这样用分区字段作为查询条件查询效率会比较高。
> - Hive分区分为静态分区和动态分区

## 1、建表语句

先用一个有分区字段的分区表进行学习，静态分区和动态分区的建表语句是一样的。

```sql
create table test_partition (
    id string comment 'ID', 
    name string comment '名字')
    comment '测试分区'
    partitioned by (year int comment '年')
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' ;
```



## 2、插入语句

> 静态分区和动态分区的插入数据的语句是不一样的，所以分开

### 2.1 静态分区

> 静态分区是在语句中指定分区字段为某个固定值，多次重复插入数据是为了看看数据如何在hdfs上存储的。

#### 2.1.1 INSERT INTO

```sql
insert into table test_partition partition(year=2018) values ('001','张三');insert into table test_partition partition(year=2018) values ('001','张三');insert into table test_partition partition(year=2018) values ('002','李四');
```

#### 2.1.2 LOAD DATA

data.txt

```sql
002,李四003,王五
```



```sql
load data local inpath '/root/dkl/data/data.txt' into table test_partition partition (year =2018);load data local inpath '/root/dkl/data/data.txt' into table test_partition partition (year =2018);load data local inpath '/root/dkl/data/data.txt' into table test_partition partition (year =2017);
```

#### 2.1.3 查询及结果

![img](https://tva3.sinaimg.cn/large/e44344dcly1fxsiazp6yqj20yq07gwet.jpg)

#### 2.1.4 HDFS存储形式

![img](https://tva4.sinaimg.cn/large/e44344dcly1fxsi6f3j0wg20sy0flu0x.gif)

分区2018的路径为

```sql
/apps/hive/warehouse/dkl.db/test_partition/year=2018
```



- /apps/hive/warehouse 为hive的仓库路径
- dkl.db dkl为数据库名称
- test_partition为表名
- year为分区字段名

### 2.2 动态分区

#### 2.2.1 INSERT INTO

```sql
insert into table test_partition partition(year) values ('001','张三',2016);
```

动态分区默认不开启，执行上面的语句会报错：

```sql
insert into table test_partition partition(year) values ('001','张三',2016);FAILED: SemanticException [Error 10096]: Dynamic partition strict mode requires at least one static partition column. To turn this off set hive.exec.dynamic.partition.mode=nonstrict
```



开启：

```sql
set hive.exec.dynamic.partition.mode=nonstrict;
```



然后再执行就可以了

> 注：上面的命令是临时生效，退出hive重新进hive需要重新执行上面的命令，才能动态分区

### 2.2.2 load data

不能使用load data进行动态分区插入
data.txt

```sql
002,李四,2015003,王五,2014
```



```mysql
load data local inpath '/root/dkl/data/data.txt' into table test_partition partition (year);
hive> load data local inpath '/root/dkl/data/data.txt' into table test_partition partition (year);FAILED: NullPointerException null
```

可以使用另一种方法解决

首先创建没有分区的表

```mysql
create table test (id string comment 'ID', name string comment '名字',year int comment '年')comment '测试'ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' ;
```



先将数据load进test表

```mssql
load data local inpath '/root/dkl/data/data.txt' into table test;
```



然后从表test，动态分区插入test_partition中

```sql
insert into table test_partition partition(year)  select * from test;
```



如果后面select具体字段的话，需要保证顺序一致，把分区字段放在最后。

```sql
insert into table test_partition partition(year)  select id,name,year from test;
```



## 3、查看分区信息

```sql
show  partitions test_partition;
hive> show  partitions test_partition;OKyear=2017year=2018Time taken: 0.719 seconds, Fetched: 2 row(s)
```

## 4、添加分区字段

> 查了一下，不能添加新的分区字段

### 4.1 添加新分区

```sql
alter table test_partition add  partition (year=2012);
```

这样就会新建对应的hdfs路径下一个year=2012的文件夹

> 当然也可以指定localtion,这样就不会在默认的路径下建立文件夹了
>
> ```sql
> alter table test_partition add  partition (year=2010) location '/tmp/dkl';
> ```
>
> 
>
> 这样如果/tmp/dkl文件夹不存在的话就会新建文件夹，如果存在就会把该文件夹下的所有的文件加载到Hive表，有一点需要注意，如果删除该分区的话，对应的文件夹也会删掉，删除语法请参考后面的第6部分。

### 4.2 添加非分区字段

```sql
alter table test_partition add columns(age int);
```

这样新加的字段是在非分区字段的最后，在分区字段之前

不过这里有一个bug，就是往表里新插入数据后，新增的age字段查询全部显示为NULL（其实数据已经存在）：

- 新增加的分区是不存在这个bug的，比如之前没有year=2011这个分区，那么新增的话不会存在bug

- 分区在添加age字段之前已存在（即使该分区下没有任何数据），bug存在

  解决方法：

  对已存在的分区执行下面的sql即可,以分区2018为例

  ```sql
  alter table test_partition partition(year=2018) add columns(age int);
  ```

## 5、多个分区字段

以两个分区字段为例

### 5.1 建表

```mysql
create table test_partition2 (id string comment 'ID', name string comment '名字')comment '测试两个分区'partitioned by (year int comment '年',month int comment '月')ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' ;
```

### 5.2 HDFS存储格式

看一下多个分区的的表如何在HDFS上存储的，用静态分区的形式插入一条记录：

```mysql
insert into table test_partition2 partition(year=2018,month=12) values ('001','张三');
```



```mysql
/apps/hive/warehouse/dkl.db/test_partition2/year=2018/month=12
```

![img](https://tva3.sinaimg.cn/large/e44344dcly1fxsn6bsd3hg20sy0fl7wh.gif)

## 6、删除分区

> 只能删除某个分区，如删除分区2018，而不能删除整个分区year字段。

### 6.1 单分区表

```mysql
alter table test_partition drop partition(year=2018);
```

### 6.2 多分区表

#### 6.2.1 删除YEAR=2018,MONTH=12

```mysql
alter table test_partition2 drop partition(year=2018,month=12);
```

#### 6.2.2 删除YEAR=2018

year=2018所有的月份都会删除

```mysql
alter table test_partition2 drop partition(year=2018);
```



#### 6.2.3 删除MONTH=10

所有月份等于10的分区都会删除，无论year=2018,还是year=2017…

```mysql
alter table test_partition2 drop partition(month=10);
```



## 参考

- [hive分区表详细介绍](https://blog.csdn.net/weixin_41122339/article/details/81584110)
- [hive分区表添加字段问题](https://www.cnblogs.com/chitin1027/p/bcd9d024876b21b2c7d1fe7f5177fbc4.html)

## 相关阅读

[Hive内部表和外部表](https://dongkelun.com/2018/12/03/hiveInternalAndExternalTables/)