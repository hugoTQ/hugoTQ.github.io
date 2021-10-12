[TOC]

# 1.DataFrame

> dataframe中index用来标识行，column标识列，shape表示维度。

```python
# 获得行索引信息
df.index
# 获得列索引信息
df.columns
# 获得df的size
df.shape
# 获得df的行数
df.shape[0]
# 获得df的 列数
df.shape[1]
# 获得df中的值
df.values
# 获取数据大致情况
df.describe()
```



## 常规增删改查

```python
# 创建 dataFrame
# 1.list
data = [1,2,3,4,5]
df = pd.DataFrame(data)

data = [{'a': 1, 'b': 2},{'a': 5, 'b': 10, 'c': 20}]
df = pd.DataFrame(data, index=['first', 'second'])

# 2.字典dict
data = {'Name':['Tom', 'Jack', 'Steve', 'Ricky'],'Age':[28,34,29,42]}
df = pd.DataFrame(data, index=['rank1','rank2','rank3','rank4'])

# 3.Series
d = {'one' : pd.Series([1, 2, 3], index=['a', 'b', 'c']),
      'two' : pd.Series([1, 2, 3, 4], index=['a', 'b', 'c', 'd'])}
df = pd.DataFrame(d)


# 选择列
d3 = d3[['time', 'status', 'CM', 'CT', 'CU']]

# 选择标签
d = {'one' : pd.Series([1, 2, 3], index=['a', 'b', 'c']), 
     'two' : pd.Series([1, 2, 3, 4], index=['a', 'b', 'c', 'd'])}

df = pd.DataFrame(d)
print df.loc['b']

# 过滤
df = df[(df.a > A) & (df.a < B)]
# apply TODO


# 新增列
# 1.insert 方法
data.insert(data.shape[1], 'd', 0)
# 2. obj[‘col’] = value 方法
data['d'] = 0
# 3. reindex 方法
data = data.reindex(columns=['a', 'b', 'c', 'd'], fill_value=0)
# 4. concat 方法
data = pd.concat([data, pd.DataFrame(columns=['d'])], sort=False)
# 5. loc 方法
 data.loc[:, 'd'] = 0


# 删除
用法：DataFrame.drop(labels=None,axis=0, index=None, columns=None, inplace=False)

参数说明：
labels 就是要删除的行列的名字，用列表给定
axis 默认为0，指删除行，因此删除columns时要指定axis=1；
index 直接指定要删除的行
columns 直接指定要删除的列
inplace=False，默认该删除操作不改变原数据，而是返回一个执行删除操作后的新dataframe；
inplace=True，则会直接在原数据上进行删除操作，删除后无法返回。

因此，删除行列有两种方式：
1）labels=None,axis=0 的组合
2）index或columns直接指定要删除的行或列


```



##  数学处理

```python
# 文件预处理
df.duplicated()           返回各行是否是上一行的重复行
df.drop_duplicates()      删除重复行，如果需要按照列过滤，参数选填['col1', 'col2',...]
df.fillna(0)              用实数0填充na
df.dropna()               axis=0|1  0-index 1-column
                          how='all'|'any' all-全部是NA才删  any-只要有NA就全删
del df['col1']            直接删除某一列              
df.drop(['col1',...], aixs=1)   删除指定列，也可以删除行                          
df.column = col_lst       重新制定列名
df.rename(index={'row1':'A'},   重命名索引名和列名
          columns={'col1':'A1'})  
df.replace(dict)          替换df值，前后值可以用字典表，{1:‘A’, '2':'B'}

def get_digits(str):
    m = re.match(r'(\d+(\.\d+)?)', str.decode('utf-8'))
    if m is not None:   
        return float(m.groups()[0])
    else:
        return 0
df.apply(get_digits)      DataFrame.apply，只获取小数部分，可以选定某一列或行
df['col1'].map(func)      Series.map，只对列进行函数转换

pd.merge(df1, df2, on='col1', 
         how='inner'，sort=True) 合并两个DataFrame，按照共有的某列做内连接（交集），outter为外连接（并集），结果排序
         
pd.merge(df1, df2, left_on='col1', 
         right_on='col2')   df1 df2没有公共列名，所以合并需指定两边的参考列


pd.concat([sr1, sr2, sr3,...], axis=0) 多个Series堆叠成多行，结果仍然是一个Series
pd.concat([sr1, sr2, sr3,...], axis=1) 多个Series组合成多行多列，结果是一个DataFrame，索引取并集，没有交集的位置填入缺省值NaN
 
df1.combine_first(df2)   用df2的数据补充df1的缺省值NaN，如果df2有更多行，也一并补上

pd.get_dummies(df['col1'], prefix='key') 某列含有有限个值，且这些值一般是字符串，例如国家


# 数据筛选
df.columns             列名，返回Index类型的列的集合
df.index               索引名，返回Index类型的索引的集合
df.shape               返回tuple，行x列
df.head(n=N)           返回前N条
df.tail(n=M)           返回后M条
df.values              值的二维数组，以numpy.ndarray对象返回
df.index               DataFrame的索引，索引不可以直接赋值修改
df.reindex(index=['row1', 'row2',...]
           columns=['col1', 'col2',...]) 根据新索引重新排序
df[m:n]                切片，选取m~n-1行
df[df['col1'] > 1]     选取满足条件的行
df.query('col1 > 1')   选取满足条件的行
df.query('col1==[v1,v2,...]') 
df.ix[:,'col1']        选取某一列
df.ix['row1', 'col2']  选取某一元素
df.ix[:,:'col2']       切片选取某一列之前（包括col2）的所有列
df.loc[m:n]            获取从m~n行（推荐）
df.iloc[m:n]           获取从m~n-1行
df.loc[m:n-1,'col1':'coln']   获取从m~n行的col1~coln列


sr=df['col']           取某一列，返回Series
sr.values              Series的值，以numpy.ndarray对象返回
sr.index               Series的索引，以index对象返回


# 数据运算与排序
df.T                   DataFrame转置
df1 + df2              按照索引和列相加，得到并集，NaN填充
df1.add(df2, fill_value=0) 用其他值填充
df1.add/sub//mul/div   四则运算的方法
df - sr                DataFrame的所有行同时减去Series
df * N                 所有元素乘以N
df.add(sr, axis=0)     DataFrame的所有列同时减去Series


sr.order()             Series升序排列
df.sort_index(aixs=0, ascending=True) 按行索引升序
df.sort_index(by=['col1', 'col2'...])  按指定列优先排序
df.sort_values(by='') 
df.rank()              计算排名rank值

# 数学统计
sr.unique             Series去重
sr.value_counts()     Series统计频率，并从大到小排序，DataFrame没有这个方法
sr.describe()         返回基本统计量和分位数

df.describe()         按各列返回基本统计量和分位数
df.count()            求非NA值得数量
df.max()              求最大值
df.min()              求最大值
df.sum(axis=0)        按各列求和
df.mean()             按各列求平均值
df.median()           求中位数
df.var()              求方差
df.std()              求标准差
df.mad()              根据平均值计算平均绝对利差
df.cumsum()           求累计和
sr1.corr(sr2)         求相关系数
df.cov()              求协方差矩阵
df1.corrwith(df2)     求相关系数

pd.cut(array1, bins)  求一维数据的区间分布
pd.qcut(array1, 4)    按指定分位数进行区间划分，4可以替换成自定义的分位数列表   

df['col1'].groupby(df['col2']) 列1按照列2分组，即列2作为key
df.groupby('col1')    DataFrame按照列1分组
grouped.aggreagte(func) 分组后根据传入函数来聚合
grouped.aggregate([f1, f2,...]) 根据多个函数聚合，表现成多列，函数名为列名
grouped.aggregate([('f1_name', f1), ('f2_name', f2)]) 重命名聚合后的列名
grouped.aggregate({'col1':f1, 'col2':f2,...}) 对不同的列应用不同函数的聚合，函数也可以是多个
         
pd.crosstab(df['col1'], df['col2']) 交叉表，计算分组的频率

# 保留小数
 df.round(2) #统一保留两位小数
 df.round({'dogs':2, 'cats':1}) # 指定列


# 数据转换
df['col_name'].astype(str)
df['col_name'].astype('object')
df[u]=df[u].astype('int') # 讲True/False转为1/0
使用Pandas提供的函数如to_numeric()、to_datetime()

```



## 合并merge/join

```python
result = pd.merge(df1, df2, on=['key1', 'key2']) # 默认inner， on是关联的列名，如果存在列名相同但没在on条件会自动重命名
result = pd.merge(df1, df2, how='left', on=['key1', 'key2']) # how 支持: left, right, outer, inner

# join 
df1.join(df2, on='key',how='left')
```



##  DataFrame/Series与常见数据结构相互转换

```python
# DataFrame to Series
将整个DataFrame转换为Series是不合理的, 因为DataFrame中含有多个列.
正常操作是从DataFrame中选择一列, 这样会自动生成一个Series.

df = pd.DataFrame().from_dict(data={'a':[1,2,3],'b':[4,5,6]}) # df : DataFrame
se = df['a'] # se : Series

# Series to DataFrame
se = pd.Series(data = np.arange(start=1,stop=11,step=1))
se_df = se.to_frame(name='rand')

通过Series.to_frame方法转换为DataFrame, 索引不变. 如果不传入name参数, 则默认转换的列名为0(需确认?); 否则,将列名设为name参数传入的值.

# DataFrame to List
首先使用np.array()函数把DataFrame转化为np.ndarray()，再利用tolist()函数把np.ndarray()转为list，示例代码如下：

import numpy as np
import pandas as pd

data_x = pd.read_csv("E:/Tianchi/result/features.csv",usecols=[2,3,4])#pd.dataframe
data_y =  pd.read_csv("E:/Tianchi/result/features.csv",usecols=[5])

train_data = np.array(data_x)#np.ndarray()
train_x_list=train_data.tolist()#list
print(train_x_list)
print(type(train_x_list))

# List 转 DataFrame
# DataFrame 转 Dict
# Dict 转 DataFrame
假设存在字典d, 需要将其转换为pd.DataFame.

> d= {u'2012-06-08': 388, u'2012-06-09': 388, u'2012-06-10': 388, u'2012-06-11': 389}

通过from_dict进行构建.
> d_df = pd.DataFrame().from_dict(d,orient='index').reset_index()
        index    0
0  2012-06-08  388
1  2012-06-09  388
2  2012-06-10  388
3  2012-06-11  389
Python3
这样生成的DataFrame的columns分别为index和0, 不太方便理解和使用. 可以通过DataFrame.rename()来对columns进行重命名.

> d_df.rename(columns={'index': 'Date', 0: 'Count'},inplace=True)
         Date  Count
0  2012-06-08    388
1  2012-06-09    388
2  2012-06-10    388
3  2012-06-11    389

通过传递list键值对, 初始化DataFrame.
>>> d_df = pd.DataFrame(data=list(d.items()),index=[5,6,7,8],columns=['Date','Count'],dtype=np.int32,copy=False)
>>> d_df
         Date  Count
5  2012-06-08    388
6  2012-06-09    388
7  2012-06-10    388
8  2012-06-11    389

copy只对其他DataFrame或其他2-D格式的数据起作用. 默认为False.

可以通过构建Series后reset_index转为DataFrame. 不过这种方法不直接, 不建议使用.
> s = pd.Series(d, name='DateValue')
> s.index.name = 'Date'
# 这里不可以使用inplace=True来重置index, 
# 会抛出TypeError: Cannot reset_index inplace on a Series to create a DataFrame
> d_df = s.reset_index()

通过d构建Series, 后设置index.name, 最后通过reset_index将Series s转换为DataFrame d_df.

# DataFrame 转 Numpy.array
np_arr = df.values
Python3
# Numpy.array 转 DataFrame
df = pd.DataFrame(np_arr)
```



##  输出文件

```python
df.to_cvs("avc.cvs", seq='\t', index=False, head=False) #  seq默认','  ， index=False不输出行索引，head=Fasle不输出列名
```





# 2.透视表 privot_table

## 数据透视表转换为dataframe

```python
df.reset_index()
df.columns = df.columns.droplevel(1) # 从多级列索引中删除一个
```







## 3. 机器学习

### get_dummies

onehot编码

**参数：**

- drop_first=True，丢弃第一列，也即特征onehot编码后丢弃原特征列