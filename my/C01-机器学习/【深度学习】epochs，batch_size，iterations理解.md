[深度学习中的epochs，batch_size，iterations理解](https://blog.csdn.net/dancing_power/article/details/97015723)



batch

记住一个公式：**Numbers of iterations = all sample/batch_size**

也就是说，有了batch_size才有迭代的概念，当batch_size大于等于样本数，则每个epoch只有一次迭代。

todo：再理解**Batch gradient descent**/**stochastic gradient descent**/**mini-batch gradient decent**



一搬来说，一个epoch需要输入所有样本。每个epoch参数不继承。

每个epoch间会进行shuffle

早停：当经过多个epoch后，auc等指标收敛，则会早停。最终采用指标最好的epoch作为模型参数。



spilt：

将数据集切分n个split，每轮epoch使用1/n 个数据。



