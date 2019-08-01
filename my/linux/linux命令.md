# Linux 常用命令

标签（空格分隔）： linux 命令

---
# 命令
- 递归修改某类文件权限 find -name "*.go" | xargs -i chmod 600 {}

#linux上的神器
https://www.zhihu.com/question/59227720

#awk
#sed
#xargs
#tcpdump
#top
    top - H 
###脚本输出
```
#!/bin/bash
    PidList=`top -b -n 1 -Hp $1 | grep cte | awk '{print $1}'`
    
    for pid in $PidList
    do
            echo "##############" $pid "#################"
             PidName=`top -b -n 1 -Hp $1 | grep $pid | awk '{print $12}'`
              TaskSet=`taskset -p $pid`
             echo "###" $PidName "--" $TaskSet
done
```
#grep
1、或操作

  grep -E '123|abc' filename  // 找出文件（filename）中包含123或者包含abc的行
  egrep '123|abc' filename    // 用egrep同样可以实现
  awk '/123|abc/' filename   // awk 的实现方式

2、与操作

  grep pattern1 files | grep pattern2 ：显示既匹配 pattern1 又匹配 pattern2 的行。


3、其他操作

grep -i pattern files ：不区分大小写地搜索。默认情况区分大小写，
grep -l pattern files ：只列出匹配的文件名，
grep -L pattern files ：列出不匹配的文件名，
grep -w pattern files ：只匹配整个单词，而不是字符串的一部分（如匹配‘magic’，而不是‘magical’），
grep -C number pattern files ：匹配的上下文分别显示[number]行，

4、通配符
grep 'a.*b' files   :.任意字符，*任意个数
#vim
###光标移动(Cursor Movement)

命令	作用（解释）
h,j,k,l	h表示往左，j表示往下，k表示往右，l表示往上
Ctrl+f	上一页
Ctrl+b	下一页
w, e, W, E	跳到单词的后面，小写包括标点
b, B	以单词为单位往前跳动光标，小写包含标点
O	开启新的一行
^	一行的开始
$	一行的结尾
gg	文档的第一行
[N]G	文档的第N行或者最后一行
###插入模式(Insert Mode)

命令	作用（解释)
i	插入到光标前面
I	插入到行的开始位置
a	插入到光标的后面
A	插入到行的最后位置
o, O	新开一行
Esc	关闭插入模式
###编辑(Editing)

命令	作用（解释）
r	在插入模式替换光标所在的一个字符
J	合并下一行到上一行
s	删除光标所在的一个字符, 光标还在当行
S	删除光标所在的一行，光标还在当行，不同于dd
u	撤销上一步操作
ctrl+r	恢复上一步操作
.	重复最后一个命令
~	变换为大写
[N]>>	一行或N行往右移动一个tab
[N]<<	一行或N行往左移动一个tab
###关闭(Exiting)

命令	作用（解释)
:w	保存
:wq, :x	保存并关闭
:q	关闭（已保存）
:q!	强制关闭
###搜索(Search)

命令	作用（解释)
/pattern	搜索（非插入模式)
?pattern	往后搜索
n	光标到达搜索结果的前一个目标
N	光标到达搜索结果的后一个目标
###视觉模式(Visual Mode)

命令	作用（解释)
v	选中一个或多个字符
V	选中一行
###剪切和复制(Cut and Paste)

命令	作用（解释)
dd	删除一行
dw	删除一个单词
x	删除后一个字符
X	删除前一个字符
D	删除一行最后一个字符
[N]yy	复制一行或者N行
yw	复制一个单词
p	粘贴
###窗口操作

命令	作用（解释)
:split	水平方向分割出一个窗口
:vsplit	垂直方向分割出一个窗口
:close	关闭窗口
Ctrl+W	切换窗口, h到左边窗口，j到下方窗口，k到上方窗口，l到右边窗口


#eval
#ps（pstree）
ps auxw --sort=rss

ps auxw --sort=%cpu

ps aux --sort=%mem

 

%CPU 进程的cpu占用率
%MEM 进程的内存占用率
VSZ 进程所使用的虚存的大小
RSS 进程使用的驻留集大小或者是实际内存的大小
TTY 与进程关联的终端（tty）
STAT 检查的状态：进程状态使用字符表示的，如R（running正在运行或准备运行）、S（sleeping睡眠）、I（idle空闲）、Z (僵死)、D（不可中断的睡眠，通常是I/O）、P（等待交换页）、W（换出,表示当前页面不在内存）、N（低优先级任务）T(terminate终止)、W has no resident pages

START （进程启动时间和日期）
TIME ;（进程使用的总cpu时间）
COMMAND （正在执行的命令行命令）
NI (nice)优先级
PRI 进程优先级编号
PPID 父进程的进程ID（parent process id）
SID 会话ID（session id）
WCHAN 进程正在睡眠的内核函数名称；该函数的名称是从/root/system.map文件中获得的。
FLAGS 与进程相关的数字标识

常用参数
-A 显示所有进程（等价于-e）(utility)
-a 显示一个终端的所有进程，除了会话引线
-N 忽略选择。
-d 显示所有进程，但省略所有的会话引线(utility)
-x 显示没有控制终端的进程，同时显示各个命令的具体路径。dx不可合用。（utility）
-p pid 进程使用cpu的时间
-u uid or username 选择有效的用户id或者是用户名
-g gid or groupname 显示组的所有进程。
U username 显示该用户下的所有进程，且显示各个命令的详细路径。如:ps U zhang;(utility)
-f 全部列出，通常和其他选项联用。如：ps -fa or ps -fx and so on.
-l 长格式（有F,wchan,C 等字段）
-j 作业格式
-o 用户自定义格式。
v 以虚拟存储器格式显示
s 以信号格式显示
-m 显示所有的线程
-H 显示进程的层次(和其它的命令合用，如：ps -Ha)（utility）
e 命令之后显示环境（如：ps -d e; ps -a e）(utility)
h 不显示第一行

##cpu统计
input_para_01=$1
log_dir=log

function start()
{
        mpstat -P ALL 1 > $log_dir/cpu_data.txt &
        echo "start mpstat..."
}

function stop()
{
        killall mpstat;
        echo "kill mpstat..."
}

function main()
{
        mkdir -p $log_dir
        case "$input_para_01" in
                start)
                        stop
                        start
                        ;;
                stop)
                        stop
                        ;;
                *)
                        echo "Usage: $0 {start|stop} [para]"
                        ;;
        esac
}

main;

##输出core

##绑核
如何绑核
taskset用于将某个进程/线程绑定到CPU的某个或某几个核上面，其用法如下：

taskset -p pid
可以查出进程pid现在的绑核情况。

设置绑核有两种方法：

掩码形式
列表形式
下面分别介绍。

掩码形式绑核
将掩码转换为二进制形式，从最低位到最高位代表物理CPU的#0、#1、……、#n号核。某位的值为0表示不绑该核，1表示绑。比如：0x00000001的二进制为0000...0001，只有第0号核的位置是1，所以表示只绑0号核；0x00000003的二进制为0000...0011，第0和1号核的位置是1，所以表示绑CPU的0号和1号核；再比如0xFFFFFFFF的二进制为1111...1111，所有32个核的位置都为1，所以表示绑CPU的0~31核。

需要注意的是，并非掩码中给出的CPU核就一定会存在，比如0x00000400理论上代表CPU的第10号核，但是该核在真正的计算机上面并不一定是存在的。而且，如果我们试图将物理上并不存的核绑定给某个进程时，会返回错误。掩码形式的绑核命令为：

taskset -p mask pid
列表形式
列表形式指直接指定要绑的CPU核的列表，列表中可以有一个或多个核。具体语法如下：

taskset -cp cpu-list pid
其中cpu-list是数字化的cpu列表，从0开始。多个不连续的cpu可用逗号连接，连续的可用短现连接，比如0,2,5-11等。

比如taskset -cp 0,2,5-11 9865命令表示将进程9864绑定到#0、#2、#5~#11号核上面。

最后要说的是：只要taskset成功返回了，那就表示绑核一定成功了，即该进程已被绑到指定的核上面，而且taskset命令会显示原来的绑核（原来的可能是系统默认分配的核）情况，以及新的绑核情况。


# 端口
ss -ntl





## lsof

1.列出所有打开的文件:

lsof

备注: 如果不加任何参数，就会打开所有被打开的文件，建议加上一下参数来具体定位

2. 查看谁正在使用某个文件

lsof   /filepath/file

3.递归查看某个目录的文件信息

lsof +D /filepath/filepath2/

备注: 使用了+D，对应目录下的所有子目录和文件都会被列出

4. 比使用+D选项，遍历查看某个目录的所有文件信息 的方法

lsof | grep ‘/filepath/filepath2/’

5. 列出某个用户打开的文件信息

lsof  -u username

备注: -u 选项，u其实是user的缩写

6. 列出某个程序所打开的文件信息

lsof -c mysql

备注: -c 选项将会列出所有以mysql开头的程序的文件，其实你也可以写成 lsof | grep mysql, 但是第一种方法明显比第二种方法要少打几个字符了

7. 列出多个程序多打开的文件信息

lsof -c mysql -c apache

8. 列出某个用户以及某个程序所打开的文件信息

lsof -u test -c mysql

9. 列出除了某个用户外的被打开的文件信息

lsof   -u ^root

备注：^这个符号在用户名之前，将会把是root用户打开的进程不让显示

10. 通过某个进程号显示该进行打开的文件

lsof -p 1

11. 列出多个进程号对应的文件信息

lsof -p 123,456,789

12. 列出除了某个进程号，其他进程号所打开的文件信息

lsof -p ^1

13 . 列出所有的网络连接

lsof -i

14. 列出所有tcp 网络连接信息

lsof  -i tcp

15. 列出所有udp网络连接信息

lsof  -i udp

16. 列出谁在使用某个端口

lsof -i :3306

17. 列出谁在使用某个特定的udp端口

lsof -i udp:55

特定的tcp端口

lsof -i tcp:80

18. 列出某个用户的所有活跃的网络端口

lsof  -a -u test -i

19. 列出所有网络文件系统

lsof -N

20.域名socket文件

lsof -u

21.某个用户组所打开的文件信息

lsof -g 5555

22. 根据文件描述列出对应的文件信息

lsof -d description(like 2)

23. 根据文件描述范围列出文件信息

    lsof -d 2-3

## 快速生成大文件

1. shell命令

   ```C
   char *shell = "dd if=/dev/zero of=test.txt bs=1K count=1024";
   system(shell);
   ```

2. seek

   ```C
   int main(void)
   {
       int fd ;
       fd = open("test.txt" , O_CREAT|O_RDWR , 0777);
   
       if( fd < 0)
       {
           printf("open file error\n");
           return 0;
       }
   
       //为了创建一个大小为3M的文件，我们先少创建2个字节，然后在写文件的时候补充2字节
       lseek(fd , 1024 * 1024 *3 -2, L_SET);
       write(fd , "e" , 1);
       close(fd);
   
       return 0 ;
   }
   ```

   