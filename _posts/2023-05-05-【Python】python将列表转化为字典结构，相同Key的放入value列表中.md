```python
from collections import defaultdict

my_list = [('a', 1), ('b', 2), ('a', 3), ('c', 4), ('b', 5)]

my_dict = defaultdict(list)
for key, value in my_list:
    my_dict[key].append(value)

print(my_dict)
```
