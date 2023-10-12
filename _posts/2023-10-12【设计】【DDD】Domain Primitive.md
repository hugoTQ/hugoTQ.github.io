[阿里技术专家详解 DDD 系列 第一讲- Domain Primitive](https://zhuanlan.zhihu.com/p/340911587)

大纲：
1. 前言
2. 案例
3. 解决方案
4. 方案总结
5. 进阶使用
6. 总结
   - 定义
   - 原则
   - 区别
   - 什么情况下应该用



总结：
1. 什么情况下应该用 Domain Primitive
   - 有格式限制的 String：比如Name，PhoneNumber，OrderNumber，ZipCode，Address等
   - 有限制的Integer：比如OrderId（>0），Percentage（0-100%），Quantity（>=0）等
   - 可枚举的 int ：比如 Status（一般不用Enum因为反序列化问题）
   - Double 或 BigDecimal：一般用到的 Double 或 BigDecimal 都是有业务含义的，比如 Temperature、Money、Amount、ExchangeRate、Rating 等
   - 复杂的数据结构：比如 Map<String, List<Integer>> 等，尽量能把 Map 的所有操作包装掉，仅暴露必要行为

3. Domain Primitiv e的4个好处：
   - 提高接口清晰度
   - 数据验证和处理（不需要每处业务代码都写）
   - 业务代码的清晰度
   - 可测试性（大大减少测试用例）
4. Domain Primitive 的定义：Domain Primitive 是一个在特定领域里，拥有精准定义的、可自我验证的、拥有行为的 Value Object 。
  - DP是一个传统意义上的Value Object，拥有Immutable的特性
  - DP是一个完整的概念整体，拥有精准定义
  - DP使用业务域中的原生语言
  - DP可以是业务域的最小组成部分、也可以构建复杂组合
4.  使用 Domain Primitive 的三原则
  - 让隐性的概念显性化
  - 让隐性的上下文显性化
  - 封装多对象行为
5. Domain Primitive 和 DDD 里 Value Object 的区别
- Value Object 更多的是一个非 Entity 的值对象
- Value Object的Immutability、Equals方法、Factory方法等
  Domain Primitive 是 Value Object 的进阶版，在原始 VO 的基础上要求每个 DP 拥有概念的整体，而不仅仅是值对象。在 VO 的 Immutable 基础上增加了 Validity 和行为。当然同样的要求无副作用（side-effect free）。
6. Domain Primitive 和 Data Transfer Object (DTO) 的区别
  在日常开发中经常会碰到的另一个数据结构是 DTO ，比如方法的入参和出参。DP 和 DTO 的区别如下：
  ![image](https://github.com/hugoTQ/hugoTQ.github.io/assets/11867595/4a9a4e58-2f46-4ab2-a4df-f465fe5f74b4)

