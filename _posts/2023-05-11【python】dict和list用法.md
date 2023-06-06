## 一. lis
### 1.list遍历

### 2.常见操作
append (x)：在列表的末尾添加一个元素x。相当于a [len (a):] = [x]。124
extend (iterable)：在列表的末尾添加一个可迭代对象的所有元素。相当于a [len (a):] = iterable。124
insert (i, x)：在指定位置i插入一个元素x。第一个参数是要插入的元素之前的索引，所以a.insert (0, x)在列表的开头插入，而a.insert (len (a), x)相当于a.append (x)。124
remove (x)：移除列表中第一个值等于x的元素。如果没有这样的元素，会抛出ValueError异常。124
pop ([i])：移除并返回列表中指定位置i的元素。如果没有指定索引，a.pop ()移除并返回列表中的最后一个元素。（方括号表示该参数是可选的，而不是要输入方括号）。1245
clear ()：移除列表中的所有元素。相当于del a [:]。124
index (x[, start[, end]])：返回列表中第一个值等于x的元素的索引。如果没有这样的元素，会抛出ValueError异常。可选参数start和end表示切片符号，用于限制搜索范围。返回的索引是相对于整个序列而不是start参数而计算的。124
count (x)：返回列表中值等于x的元素的个数。124
sort (*, key=None, reverse=False)：对列表中的元素进行排序（参数可以用于自定义排序，参见sorted ()函数）。124
reverse ()：反转列表中的元素顺序。124
copy ()：返回列表的浅拷贝。相当于a [:]。124

## 二. dict
### 5. dict遍历
可以使用 for 循环遍历字典中的键值对，示例代码如下：

my_dict = {"name": "Alice", "age": 25, "city": "New York"}

# 遍历字典中的键值对
for key, value in my_dict.items():
    print(key, ":", value)
    
### 6.从dict获取元素，若获取不到则创建(setdefault)
```python
node = node_dict.setdefault(node_name, TreeNode(node_name))
```

### 7.删除
```python
del dict['b']

dict.pop('b')
```
这两种方法都会将键为`'b'`的元素从字典中删除。如果键不存在，`del`关键字会引发`KeyError`异常，而`pop()`方法则会返回默认值（如果提供了）或引发`KeyError`异常。
