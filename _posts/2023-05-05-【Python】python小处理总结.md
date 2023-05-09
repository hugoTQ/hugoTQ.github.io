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

