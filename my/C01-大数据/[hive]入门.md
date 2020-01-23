1、Hive简介

- Hive通过SQL来分析大数据，避免写MapReduce程序来分析数据。
- Hive数据是存放在HDFS，Hive本身并不提供数据的存储功能。
- Hive将数据映射成数据库和一张张表，库和表的元数据信息一般存放在关系型数据库上（比如MySQL）
- 对数据完整性、格式要求并不严格
- Hive语句最终生成MapReduce任务去计算，所以不适用于实时计算场景，适用于离线分析。



2、Hive架构

Hive的核心：

- 解析器
- 编译器
- 优化器
- 执行器



Hive语句执行过程：

Hive中的执行器，是将最终要执行的MapReduce程序放到YARN上以一系列Job的方式去执行。



hive创建表会放在hdfs，默认放在

![1579658548940](../../../../../projectdocsmyimages/1579658548940.png)

​	以table.db命名。



可以在create table的时候指定location到hdfs自定义路径。



Hive的元数据存储：

Hive的元数据是一般是存储在MySQL这种关系型数据库上的，Hive和MySQL之间通过MetaStore服务交互。



3、基本数据类型

| **数据类型** | **长度**                | **备注**                                |
| :----------- | :---------------------- | :-------------------------------------- |
| Tinyint      | 1字节的有符号整数       | -128~127                                |
| SmallInt     | 1个字节的有符号整数     | -32768~32767                            |
| Int          | 4个字节的有符号整数     | -2147483648 ~ 2147483647                |
| BigInt       | 8个字节的有符号整数     |                                         |
| Boolean      | 布尔类型，true或者false | true、false                             |
| Float        | 单精度浮点数            |                                         |
| Double       | 双精度浮点数            |                                         |
| String       | 字符串                  |                                         |
| TimeStamp    | 整数                    | 支持Unix timestamp，可以达到纳秒精度    |
| Binary       | 字节数组                |                                         |
| Date         | 日期                    | 0000-01-01 ~ 9999-12-31，常用String代替 |
|              |                         |                                         |



4、基本操作

4.1 database

```mysql
hive> CREATE DATABASE [IF NOT EXISTS] userdb;
	或
hive> CREATE SCHEMA userdb

show databases;
use 数据库;
drop database if exists 数据表;
```



4.2 table

4.2.1 创建table

```mysql
# 指定表存放地址
create table testtable (id string comment 'ID') comment 'testtable' location '/testlocation';
等价于
create table testtable (id string comment 'ID') comment 'testtable' location'hdfs://localhost:9000/testlocation';

# 从其他表中创建表
create table load_data_local3 as select * from load_data_local;
```



