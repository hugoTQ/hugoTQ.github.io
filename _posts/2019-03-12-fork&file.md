疑问 fopen得到FILE*文件句柄fp，fork后子进程fclose fp会有什么效果？

```c
#include <stdio.h>
#include <errno.h>
#include <unistd.h>

void main(){
	FILE *fp = NULL;
	fp = fopen("1.txt", "ab+");
	int pid = fork();
	if (pid == 0) {
	sleep(20);
	}else {
		fclose(fp);
	}
}
```

用`lsof 1.txt`查看占用文件的进程：

COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
fopen   9586 root    3u   REG  253,2        0 929315 1.txt

可以看出，父进程fclose fp后，子进程还会占用文件，这时候若主进程对该文件删除则删除失败，因为子进程打开该文件，除非子进程退出或者主动fclose该文件指针。

有两个方法避免这个问题：

方法1：fork后子进程执行以下代码

```C
for ( i=getdtablesize(); i>2; --i) 
    close(i);
```

方法2：使用clone替代fork，后面fork与clone讨论。

在C程序中，文件由文件指针或者文件描述符表示。ISO C的标准I/0库函数（fopen, fclose, fread, fwrite, fscanf, fprintf等）使用文件指针，UNIX的I/O函数（open, close, read, write, ioctl）使用文件描述符。下面重点来说，文件描述符是如何工作的。

## 文件描述符

## 引申

fork

vfork

clone



