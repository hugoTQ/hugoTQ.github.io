## Counter（计数器）：用于追踪值的出现次数

Counter类继承dict类，所以它能使用dict类里面的方法 

------

 创建一个Counter类

```python
import collections
obj = collections.Counter('aabbccc')
print(obj)

#输出：Counter({'c': 3, 'a': 2, 'b': 2})
```

elements()

```python
import collections
obj = collections.Counter('aabbccc')
print(sorted(obj.elements()))

#输出：['a', 'a', 'b', 'b', 'c', 'c', 'c']

for k in obj.elements():   #遍历打印obj所有元素
    print(k)
```

```python
import collections
obj = collections.Counter('aabbbcccc')
print(obj.most_common(2))

#输出：[('c', 4), ('b', 3)]
```

items(从dict类中继承的方法)

```python
import collections
obj = collections.Counter('aabbbcccc')
print(obj.items())

for k,v in obj.items():
    print(k,v)

#输出：dict_items([('b', 3), ('c', 4), ('a', 2)])
#     b 3
#     c 4
#     a 2
```

update(增加元素)

```python
import collections
obj = collections.Counter(['11','22'])
obj.update(['22','55'])
print(obj)

#输出：Counter({'22': 2, '11': 1, '55': 1})
```

 subtract(原来的元素减去新传入的元素)

```python
import collections
obj = collections.Counter(['11','22','33'])
obj.subtract(['22','55'])
print(obj)

#输出：Counter({'11': 1, '33': 1, '22': 0, '55': -1})
```



## pickle模块使用

在机器学习中，我们常常需要把训练好的模型存储起来，这样在进行决策时直接将模型读出，而不需要重新训练模型，这样就大大节约了时间。Python提供的pickle模块就很好地解决了这个问题，它可以序列化对象并保存到磁盘中，并在需要的时候读取出来，任何对象都可以执行序列化操作。

Pickle模块中最常用的函数为：

1. pickle.dump(obj, file, [,protocol])

​        函数的功能：将obj对象序列化存入已经打开的file中。

​       参数讲解：

- obj：想要序列化的obj对象。
- file:文件名称。
- protocol：序列化使用的协议。如果该项省略，则默认为0。如果为负值或HIGHEST_PROTOCOL，则使用最高的协议版本。



2. pickle.load(file)

​        函数的功能：将file中的对象序列化读出。

​        参数讲解：

- file：文件名称。



3. pickle.dumps(obj[, protocol])

​       函数的功能：将obj对象序列化为string形式，而不是存入文件中。

​       参数讲解：

- obj：想要序列化的obj对象。
- protocal：如果该项省略，则默认为0。如果为负值或HIGHEST_PROTOCOL，则使用最高的协议版本。



4. pickle.loads(string)

​       函数的功能：从string中读出序列化前的obj对象。

​       参数讲解：

- string：文件名称。

​     【注】 dump() 与 load() 相比 dumps() 和 loads() 还有另一种能力**：**dump()函数能一个接着一个地将几个对象序列化存储到同一个文件中，随后调用load()来以同样的顺序反序列化读出这些对象。

​     【代码示例】

​      pickleExample.py

 ```python
#coding:utf-8
__author__ = 'MsLili'
#pickle模块主要函数的应用举例
import pickle
dataList = [[1, 1, 'yes'],
            [1, 1, 'yes'],
            [1, 0, 'no'],
            [0, 1, 'no'],
            [0, 1, 'no']]
dataDic = { 0: [1, 2, 3, 4],
            1: ('a', 'b'),
            2: {'c':'yes','d':'no'}}
 
#使用dump()将数据序列化到文件中
fw = open('dataFile.txt','wb')
# Pickle the list using the highest protocol available.
pickle.dump(dataList, fw, -1)
# Pickle dictionary using protocol 0.
pickle.dump(dataDic, fw)
fw.close()
 
#使用load()将数据从文件中序列化读出
fr = open('dataFile.txt','rb')
data1 = pickle.load(fr)
print(data1)
data2 = pickle.load(fr)
print(data2)
fr.close()
 
#使用dumps()和loads()举例
p = pickle.dumps(dataList)
print( pickle.loads(p) )
p = pickle.dumps(dataDic)
print( pickle.loads(p) )
 ```



## `zip`(**iterables*)

```python
# 返回list，list元素是元组，由输入每个迭代器的元素按顺序组合，元组个数是输入元素数量最少决定，
zip([123,456],'xy','123') --> [(123, 'x', '1'), (456, 'y', '2')]
```