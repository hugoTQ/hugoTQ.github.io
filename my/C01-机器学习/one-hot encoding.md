# 一、One-Hot Encoding介绍





# 1 .One-Hot Encoding

​    One-Hot编码，又称为一位有效编码，主要是采用![N](http://latex.codecogs.com/gif.latex?N)位状态寄存器来对![N](http://latex.codecogs.com/gif.latex?N)个状态进行编码，每个状态都由他独立的寄存器位，并且在任意时候只有一位有效。

​    在实际的机器学习的应用任务中，特征有时候并不总是连续值，有可能是一些分类值，如性别可分为“male”和“female”。在机器学习任务中，对于这样的特征，通常我们需要对其进行特征数字化，如下面的例子：

有如下三个特征属性：

- 性别：["male"，"female"]
- 地区：["Europe"，"US"，"Asia"]
- 浏览器：["Firefox"，"Chrome"，"Safari"，"Internet Explorer"]

对于某一个样本，如["male"，"US"，"Internet Explorer"]，我们需要将这个分类值的特征数字化，最直接的方法，我们可以采用序列化的方式：[0,1,3]。但是这样的特征处理并不能直接放入机器学习算法中。

# 2. One-Hot Encoding的处理方法

​    对于上述的问题，性别的属性是二维的，同理，地区是三维的，浏览器则是四维的，这样，我们可以采用One-Hot编码的方式对上述的样本“["male"，"US"，"Internet Explorer"]”编码，“male”则对应着[1，0]，同理“US”对应着[0，1，0]，“Internet Explorer”对应着[0,0,0,1]。则完整的特征数字化的结果为：[1,0,0,1,0,0,0,0,1]。这样导致的一个结果就是数据会变得非常的稀疏。

# 3. 实际的Python代码



**[python]**[view plain](http://blog.csdn.net/google19890102/article/details/44039761#)





1. **from** sklearn **import** preprocessing  
2.   
3. enc = preprocessing.OneHotEncoder()  
4. enc.fit([[0,0,3],[1,1,0],[0,2,1],[1,0,2]])  
5.   
6. array = enc.transform([[0,1,3]]).toarray()  
7.   
8. **print** array  


结果：[[ 1.  0.  0.  1.  0.  0.  0.  0.  1.]]





**二.  为什么使用one-hot编码来处理离散型特征?**



1.使用one-hot编码，将离散特征的取值扩展到了欧式空间，离散特征的某个取值就对应欧式空间的某个点。



2.将离散特征通过one-hot编码映射到欧式空间，是因为，在回归，分类，聚类等机器学习算法中，特征之间距离的计算或相似度的计算是非常重要的，而我们常用的距离或相似度的计算都是在欧式空间的相似度计算，计算余弦相似性，基于的就是欧式空间。



3.将离散型特征使用one-hot编码，确实会让特征之间的距离计算更加合理。比如，有一个离散型特征，代表工作类型，该离散型特征，共有三个取值，不使用one-hot编码，其表示分别是x_1 = (1), x_2 = (2), x_3 = (3)。两个工作之间的距离是，(x_1, x_2) = 1, d(x_2, x_3) = 1, d(x_1, x_3) = 2。那么x_1和x_3工作之间就越不相似吗？显然这样的表示，计算出来的特征的距离是不合理。那如果使用one-hot编码，则得到x_1 = (1, 0, 0), x_2 = (0, 1, 0), x_3 = (0, 0, 1)，那么两个工作之间的距离就都是sqrt(2).即每两个工作之间的距离是一样的，显得更合理。



4.对离散型特征进行one-hot编码是为了让距离的计算显得更加合理。



5.将离散型特征进行one-hot编码的作用，是为了让距离计算更合理，但如果特征是离散的，并且不用one-hot编码就可以很合理的计算出距离，那么就没必要进行one-hot编码，比如，该离散特征共有1000个取值，我们分成两组，分别是400和600,两个小组之间的距离有合适的定义，组内的距离也有合适的定义，那就没必要用one-hot 编码

离散特征进行one-hot编码后，编码后的特征，其实每一维度的特征都可以看做是连续的特征。就可以跟对连续型特征的归一化方法一样，对每一维特征进行归一化。比如归一化到[-1,1]或归一化到均值为0,方差为1



**引申：如何做归一化**



处理离散型特征和连续型特征并存的情况，**如何做归一化：**
1、需要归一化情况：
拿到获取的原始特征，必须对每一特征分别进行归一化，比如，特征A的取值范围是[-1000,1000]，特征B的取值范围是[-1,1].
如果使用logistic回归，w1*x1+w2*x2，因为x1的取值太大了，所以x2基本起不了作用。
所以，必须进行特征的归一化，每个特征都单独进行归一化。



2、连续型特征归一化的常用方法：
   2.1：Rescale bounded continuous features: All continuous input that are bounded, rescale them to [-1, 1] through **x = (2x - max - min)/(max - min).**线性放缩到[-1,1]


  2.2:Standardize all continuous features: All continuous input should be standardized and by this I mean, for every continuous feature, compute its mean (u) and standard deviation (s) and do **x = (x - u)/s.**放缩到均值为0，方差为1



**有些情况不需要进行特征的归一化：**

**基于树**的方法是不需要进行特征的归一化，例如随机森林，bagging 和 boosting等。

**基于参数的模型或基于距离**的模型，都是要进行特征的归一化。


