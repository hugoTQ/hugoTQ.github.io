疑问：

1. 矩阵分解与Embedding的比较
2. 



[[NLP] 秒懂词向量Word2vec的本质](https://zhuanlan.zhihu.com/p/26306795)

[如何通俗理解word2vec](https://blog.csdn.net/v_JULY_v/article/details/102708459) :解释为什么有些有隐层有些没有

[理解 Word2Vec 之 Skip-Gram 模型](https://zhuanlan.zhihu.com/p/27234078)：从样本，训练，参数方面讲的比较清楚

[Word2vec词向量原理解析！](https://wxjwjj.github.io/2018/01/21/word2vec/) ：讲到Hierarchical Softmax



## 常用的Embedding方式

1. 以SVD为代表的MF方式。通过对user-item-score矩阵的分解，或者user-item的隐式矩阵分解，可以获取user与item的隐向量，该向量可以作为embedding向量使用。
2. FM算法。FM学习了各个特征的隐向量表示，从而可以将这些学习到的隐向量作为特征的embedding使用。
3. DNN-Embedding 通过神经网络，利用接入Embedding层与目标loss进行joint train，从而学习其特征表达，这是一种端到端的embedding训练方式(end-to-end)。
4. item2vec 与word2vec类似的方式。
5. graph embedding，是基于图模型的方法，包括deep walk, node2vec, eges等方法。
   

## item2vec与MF的区别
首先，二者都应用了隐向量来表征实体特征，不同的是，传统的 MF 通常是 user-item 矩阵，而 Item2Vec 通过滑动窗口样本生成的方式构造出的则更像是 item-item 矩阵；另外，二者得到隐向量的方式也不同，MF 利用均方差损失，使预测得分与已有得分之间的误差尽可能地小，而 Item2Vec 则是利用空间信息并借助了最大似然估计的思想，使用对数损失，使上下文关系或者共现关系构造出的正样本的 item Pair 出现的概率可能地大；此外训练 Item2Vec 的时候还要引入负样本，这也是与 MF 不同的地方。

对于二者在推荐效果上的差异，一个经验是传统 MF 推荐会让热门内容经常性排在前面，而 Item2vec 能更好的学到中频内容的相似性。Iterm2Vec 加上较短的时间窗口，相似推荐会比 MF 好很多。


# word2vec参考资料

>1. Mikolov 两篇原论文：
>『Distributed Representations of Sentences and Documents』
>      贡献：在前人基础上提出更精简的语言模型（language model）框架并用于生成词向量，这个框架就是 Word2vec
>『Efficient estimation of word representations in vector space』
>      贡献：专门讲训练 Word2vec 中的两个trick：hierarchical softmax 和 negative sampling
>优点：Word2vec 开山之作，两篇论文均值得一读
>缺点：只见树木，不见森林和树叶，读完不得要义。
>      这里『森林』指 word2vec 模型的理论基础——即 以神经网络形式表示的语言模型
>      『树叶』指具体的神经网络形式、理论推导、hierarchical softmax 的实现细节等等
>
>2. 北漂浪子的博客：『深度学习word2vec 笔记之基础篇』
>优点：非常系统，结合源码剖析，语言平实易懂
>缺点：太啰嗦，有点抓不住精髓
>
>3. Yoav Goldberg 的论文：『word2vec Explained- Deriving Mikolov et al.’s Negative-Sampling Word-Embedding Method』
>优点：对 negative-sampling 的公式推导非常完备
>缺点：不够全面，而且都是公式，没有图示，略显干枯
>
>4. **Xin Rong 的论文：『word2vec Parameter Learning Explained』：**
>**！重点推荐！**
>理论完备由浅入深非常好懂，且直击要害，既有 high-level 的 intuition 的解释，也有细节的推导过程
>一定要看这篇paper！一定要看这篇paper！一定要看这篇paper！
>
>5. 来斯惟的博士论文『基于神经网络的词和文档语义向量表示方法研究』以及他的博客（网名：licstar）
>可以作为更深入全面的扩展阅读，这里不仅仅有 word2vec，而是把词嵌入的所有主流方法通通梳理了一遍
>
>6. 几位大牛在知乎的回答：『word2vec 相比之前的 Word Embedding 方法好在什么地方？』
>刘知远、邱锡鹏、李韶华等知名学者从不同角度发表对 Word2vec 的看法，非常值得一看
>
>7. Sebastian 的博客：『On word embeddings - Part 2: Approximating the Softmax』
>详细讲解了 softmax 的近似方法，Word2vec 的 hierarchical softmax 只是其中一种



## Item2Vec

[Python训练item2vec实现电影相关推荐](https://www.bilibili.com/video/BV1th411Z7eG)



## 双塔模型

### [Tensorflow2实现推荐系统双塔DNN排序模型](https://www.bilibili.com/video/BV1Mh411Z7YQ/)