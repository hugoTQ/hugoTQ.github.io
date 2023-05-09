[TOC]
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
