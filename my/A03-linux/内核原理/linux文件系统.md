1. 目录、文件名

   255字节，即英文255、中文85 （UTF8）

2. 单级目录个数

   32000，减去..和. 即31998

   include/linux/ext2_fs.h:#define EXT2_LINK_MAX 32000

3. 单级文件个数

4. 查看单个进程打开最大文件数：`ulimit -n`，详细：`ulimit -a`， 设置`ulimit -n xxxxx`

   

[文件系统](https://www.cnblogs.com/xumenger/p/4491425.html)

[Linux文件和目录限制](https://blog.csdn.net/wzy_1988/article/details/12917687)

[理解inode](https://blog.csdn.net/wzy_1988/article/details/12917687)

<https://linux.cn/article-4099-2.html>

[文件句柄（file handles） & 文件描述符（file descriptors）](https://blog.csdn.net/u013256816/article/details/60778709)

