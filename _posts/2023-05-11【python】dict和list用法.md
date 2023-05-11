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
