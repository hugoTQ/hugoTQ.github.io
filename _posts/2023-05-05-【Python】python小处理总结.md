- [1.python将列表转化为字典结构，相同Key的放入value列表中](#1python将列表转化为字典结构相同key的放入value列表中)
- [2. python怎么把默认input改成某文件](#2-python怎么把默认input改成某文件)
- [3. 二次排序](#3-二次排序)




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

### 4. 初始化二维数组

```python
a = [[0 * n] for _ in range(m)]
```
`[0 for _ in range(n)]`和 `[0] * n` 没有区别。但是二维数组不能用`[[0]*n]*n`，因为是`*`是浅拷贝，修改其中一个元素会影响其他元。
