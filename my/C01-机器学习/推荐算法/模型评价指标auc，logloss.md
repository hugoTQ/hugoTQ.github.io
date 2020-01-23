模型评价指标

https://tracholar.github.io/machine-learning/2018/01/26/auc.html

[](https://www.zhihu.com/question/39840928?from=profile_question_card)

![1576228628702](../../../../../projectdocsmyimages/1576228628702.png)





**首先**，在试图弄懂AUC和ROC曲线之前，一定，一定要彻底理解**混淆矩阵**的定义！！！

混淆矩阵中有着Positive、Negative、True、False的概念，其意义如下：

- **称预测类别为1的为Positive（阳性），预测类别为0的为Negative（阴性）。**
- **预测正确的为True（真），预测错误的为False（伪）。**

对上述概念进行组合，就产生了如下的混淆矩阵：

![1579594961513](../../../../../projectdocsmyimages/1579594961513.png)



**然后**，由此引出True Positive Rate（真阳率）、False Positive（伪阳率）两个概念：

![1578723792644](../../../../../projectdocsmyimages/1578723792644.png)

仔细看这两个公式，发现其实TPRate就是TP除以TP所在的列，FPRate就是FP除以FP所在的列，二者意义如下：

- **TPRate的意义是所有真实类别为1的样本中，预测类别为1的比例。**
- **FPRate的意义是所有真实类别为0的样本中，预测类别为1的比例。**

![1576504738557](../../../../../projectdocsmyimages/1576504738557.png)



面试检验：怎样想一个没有任何计算机、数学、统计等基础的人介绍下什么是AUC。



AUC的真正含义：随机选取一个正例和一个负例，分类器给正例的打分大于分类器给负例的打分的概率。