# String+性能问题

原因：String类final修饰，具有对象不变性，+都是new对象

解决方案：
用StringBuffer或者StringBuilder，StringBuilder线程不安全，但性能更优。

# Reference: 
- [String性能提升10倍的几个方法！(源码+原理分析)](https://ost.51cto.com/posts/2524)
- [String 既然能这样性能调优，我直呼内行](https://z.itpub.net/article/detail/41A16B147F1E0891962627A4C8C058A7)
