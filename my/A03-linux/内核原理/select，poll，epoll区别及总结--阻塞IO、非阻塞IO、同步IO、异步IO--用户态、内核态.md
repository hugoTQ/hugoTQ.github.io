# select，poll，epoll区别及总结--阻塞IO、非阻塞IO、同步IO、异步IO--用户态、内核态

标签（空格分隔）： epoll 网络编程

---

[reference](https://www.cnblogs.com/langzibin/p/7755783.html)
[最好的对于epoll解释](https://blog.csdn.net/libaineu2004/article/details/70197825)

# 阻塞IO，非阻塞IO，同步IO，多路复用IO，异步IO的区别
- 何为内核态，用户态
- IO分为等待数据，与将数据从内核态拷贝到用户态两个阶段

# select，poll
- 多路复用IO优势，无需创建线程
- poll相较于select无本质区别，只是文件描述符无上限
- 相比epoll，select和poll劣势：
    1. 每次调用select都要把fd集合从用户态拷贝内核态一次
    2. 当一个文件描述符可读写的时候，都要遍历完所有？


# epoll
- epoll实现原理