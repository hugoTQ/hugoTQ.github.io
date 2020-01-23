## Hive命令

1. database

```sql
创建数据库：CREATE SCHEMA userdb; 或者 CREATE DATABASE [IF NOT EXISTS] userdb;
```

2. table

```MYSQL 
#1.查看表
模糊搜索表：show tables like '*name*';
查看表详细信息：desc extended t1;
查看表创建信息：show create table t1; # 这个比较好看
查看表分区：show partitions day_hour_table

#2.操作表结构(创建表，修改表)
create external table xxx (l int) partitoned by (d string);#按分区外部表创建
alter table table_name rename to new_table_name; # 重命名表
alter table table_name add columns (newcol1 int comment ‘新增’);# 增加字段
alter table table_name change col_name new_col_name new_type;#修改字段
alter table table_name replace columns (col1 int,col2 string,col3 string);# 删除字段
drop table table_name;# 删除表
alter table table_name drop if exists partitions (d='2016-07-01');#删除分区：注意：若是外部表，则还需要删除文件(hadoop fs -rm -r -f  hdfspath)

#3.查数据
select * from no_primary_key limit 10; # 随意显示其中10条记录；
select table_coulm from table_name where partition_name = '2014-02-25';  #按分区查看

#4.插入数据
#4.1 从本地系统导入数据
#注意：有LOCAL表示从本地文件系统加载（文件会被拷贝到HDFS中）
LOAD DATA LOCAL INPATH '/home/hadoop/person.txt' OVERWRITE INTO TABLE person;
#4.2 从hdfs导入数据
load data inpath 'data/load_data_hdfs.txt' into table load_data_hdfs;

#4.3从hive其他表导入数据
#1.将数据导入分区表必须先在Hive中执行下面两句语句：
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
# 静态方式将load_data_local表的数据导入到load_data_partition表的sql语句如下：
insert into table load_data_partition partition(age=25) select name from load_data_local;
# 动态方式将load_data_local表的数据导入到load_data_partition表的sql语句如下：
insert overwrite table load_data_partition partition select name,age from load_data_local;
#Hive还支持一条SQL语句中将数据插入多个表的功能，只需将from关键字前置即可：
from load_data_local 
insert overwrite table load_data_partition partition (age)
  select name,age
insert overwrite table load_data_local3 
  select 
  
# 4.4创建表的同时导入数据
create table load_data_local3 as select * from load_data_local;


```

