> 神经网络：解决高阶非线性问题

## 神经网络节点符号定义

![1577931129893](../../img/1577931129893.png)





- 输入 x1，x2，x3
  - 通常称第一层为输入激励
  - 第二层有3个神经元
  - 每一层通常会加上一个偏置单元（bias nodes）也作下一层的各单元的输入，x0通常定义为1
- 第一层为输入层-input layer，最后一层为输出层-output layer，中间层都叫做隐藏层hidden layer

![1577932981638](../../img/1577932981638.png)

- ![1577931625780](../../img/1577931625780.png)**- 第j层第i个激励**

  - ![1577931727837](../../img/1577931727837.png)是第二层第一个激励
  - 激励：我们是指通过该节点后，计算并输出的值

- ![1577931791781](../../img/1577931791781.png)**- 第 j 层 到 第 j+1 层函数的参数矩阵，因此第二层的参数矩阵是![1577932408087](../../img/1577932408087.png)**

  - 定义![1577931882236](../../img/1577931882236.png) 是第j层的神经元总数

  - ![1577931920317](../../img/1577931920317.png) 将会是一个![1577931932839](../../img/1577931932839.png)矩阵

    - 因为![1577931969693](../../img/1577931969693.png)等于第 j+1 层的单元个数
    - 列数等于第j层单元个数+1，+1是因为增加的一个bias nodes

  - ![1578018886340](../../img/1578018886340.png) -

    - j ： （下标第一个值）l + 1层的第 j 个节点
    - i ：（下标第二个值）l 层的第 i 个节点
    - l ：（上标）是在当前从哪层移动过来
  
  - 举例：如果第一层有2个节点，第二层有4个激励节点，如下图。则，则![1577932408087](../../img/1577932408087-1579595084621.png)会是一个4x3的矩帧，因为sj=2，s（j+1）=4,
  
    ![1577932807728](../../img/1577932807728.png)





![1577932981638](../../img/1577932981638-1579595086324.png)

![1577933811550](../../img/1577933811550-1579595088462.png)

![1577933824982](../../img/1577933824982.png)

![1577933834798](../../img/1577933834798.png)

![1577933845558](../../img/1577933845558.png)

> Notice that in this **last step**, between layer j and layer j+1, we are doing **exactly the same thing** as we did in logistic regression. Adding all these intermediate layers in neural networks allows us to more elegantly produce interesting and more complex non-linear hypotheses.





![1577947208313](../../img/1577947208313.png)





## 神经网络Cost Function

回顾，逻辑回归的cost Function:

![1577973946762](../../img/1577973946762.png)



1. **神经网络的cost Function：**

![1577973963360](../../img/1577973963360.png)

其中：

- L = 神经网络的总层数

- sl = 第 l 层神经单元 个数（不包含偏差量）

- K = 最后输出的分类

- ![1577975552983](../../img/1577975552983.png)是一个k维向量，![1577975566371](../../img/1577975566371.png)表示第i个输出

- ![1577975930105](../../img/1577975930105.png)表示训练集第i个样本的第k个输出

  

2. 逻辑回归与神经网络区别这两个公式区别：

- 神经网络θ是一个矩阵





## 神经网络优化方法——backpropagation后向传播

1. 定义输出误差

![1578022912570](../../img/1578022912570.png)

​		表示第4层最后一层，第 j 个结果误差（激励值 - 样本结果）。

​		向量化：

![1578023024440](../../img/1578023024440.png)



​		表示第4层的所有误差组成的向量。

2. 定义，前面层的误差计算：

![1578023086618](../../img/1578023086618.png)

![1578023309411](../../img/1578023309411.png)



3. 梯度下降步幅：![1578023330158](../../img/1578023330158.png)

4. 梯度下降过程

   ![1578023393813](../../img/1578023393813.png)



## 展开参数

## 梯度检查

## 随机化初始值

