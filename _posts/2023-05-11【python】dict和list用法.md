## 一. list
### 1.list遍历

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
