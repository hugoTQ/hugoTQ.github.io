- [1.python将列表转化为字典结构，相同Key的放入value列表中](#1python-------------key---value---)
- [2. python怎么把默认input改成某文件](#2-python-----input-----)
- [3. 二次排序](#3-----)
- [4. list遍历](#4-list--)
- [5. map遍历](#5-map--)
- [6. list合并](#6-list--)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

### 1.python将列表转化为字典结构，相同Key的放入value列表中
```python
from collections import defaultdict

my_list = [('a', 1), ('b', 2), ('a', 3), ('c', 4), ('b', 5)]

my_dict = defaultdict(list)
for key, value in my_list:
    my_dict[key].append(value)

print(my_dict)
```
### 2. python怎么把默认input改成某文件
```python
import sys
sys.stdin = open("your input file name")
aLine = raw_input()
print "The line in your file",aLine
```

### 3. 二次排序

### 4. list遍历

### 5. map遍历
可以使用 for 循环遍历字典中的键值对，示例代码如下：

```python
my_dict = {"name": "Alice", "age": 25, "city": "New York"}

# 遍历字典中的键值对
for key, value in my_dict.items():
    print(key, ":", value)
```

输出结果为：

```
name : Alice
age : 25
city : New York
```

其中，`items()` 方法返回一个包含字典所有键值对的可迭代对象，每个键值对以元组的形式表示。在 for 循环中，使用两个变量 `key` 和 `value` 分别接收每个键值对的键和值，然后进行操作。

### 6. list合并
可以使用 `+` 运算符或 `extend()` 方法将两个列表合并成一个新的列表。

例如：

```python
list1 = [1, 2, 3]
list2 = [4, 5, 6]
new_list = list1 + list2
print(new_list)  # 输出 [1, 2, 3, 4, 5, 6]

list1.extend(list2)
print(list1)  # 输出 [1, 2, 3, 4, 5, 6]
```

注意，使用 `+` 运算符会创建一个新的列表，而 `extend()` 方法会在原列表上进行修改。
