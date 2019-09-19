1. fdisk -l 查看你的硬盘编号，如sda,sdb 等

2. mkfs.ext4 /dev/xvdb1 格式化

3. du -bsh dir_name 查看目录大小

4. df -h 查看磁盘大小 -h：大小以G显示

5. df 命令可以查看分区挂载情况， fdisk 命令可以查看系统分区情况。

6. hostname 主机名字

7. cd ${0%/*} 表示删除从变量$0尾部开始第一个正斜冈之后匹配到的内容，返回剩下的内容。比如$0是这个目录/home/john/source 那么就是把"/source"截取掉剩下的。*

8. *反引号``:shell会运行引号中的命令，并将其输出赋给变量 

9. echo "aa bb cc" | awk '{print $1}'  :输出aa。awk '{print $1}' 输出以空格隔开第一个字符串 

10. echo "wewewe   wewewe" | grep "^we" ：输出wewewe   wewewe。grep "^we" 查找以we开头的那行

11. last -n 5 ：用户登录历史。 -n 5：最近的5个

12. ```shell
    $# 是传给脚本的参数个数
    $0 是脚本本身的名字
    $1 是传递给该shell脚本的第一个参数
    $2 是传递给该shell脚本的第二个参数
    $@ 是传给脚本的所有参数的列表
    $* 是以一个单字符串显示所有向脚本传递的参数，与位置变量不同，参数可超过9个
    $$ 是脚本运行的当前进程ID号
    $? 是显示最后命令的退出状态，0表示没有错误，其他表示有错误
    ```

13. find ${DIR} -name "${filename}" -exec ${ACTION} ${PARA} {} \;-exec {} \; 

    1. -exec后面固定写法：空格+大括号+空格+斜杠+分号
    2. 例子：find . -name * -exec ls -ls {} \;

14. ls只显示文件/文件夹： ls -l | grep ^d      ls -l | grep ^-

15. rpm -qa |grep gcc 查看安装软件    rpm -ql openssh   查看软件文件

16. w: 查看登录用户正在使用的进程信息 who:正在登录的用户 last <user>登陆过该用户的信息

17. nohup 重定向** nohup abc.sh > nohup.log 2>&1 &

18. kill -9  $(ps -ef |grep SysManager_gc | awk '{print $2}')          ps aux | grep "SP" |grep -v grep| cut -c 9-15 | xargs kill -9

19. 解决telnet无法连接 Connection refusedservice xinetd restart

20. 密码不过期：chage -M 99999 oracle

21. 快捷命令alias p="ps -u prov_htq -f | grep -v grep | grep java

22. 重启网络，三种都可以

    1. service network restart
    2. rcnetwork restart
    3. /etc/rc.d/network restart

23. 生成一百万行的文件tr -dc A-Za-z0-9 < /dev/urandom |fold -w 16 |head -1000000 >file

24. [suse11如何修改hostname[Linux基础\]](http://blog.itpub.net/24930246/viewspace-1065304/) 

    1.  Linux1.修改当前的hostname可以用hostname  myname 此时只是修改了内存内部的，下次启动又恢复了

    2. 机器在启动的时候会调用/etc/rc.d/boot.localnet脚本看后面的附录，这个脚本会判断当前的$HOSTNAME变量是否设置，没有设置就会读取/etc/HOSTNAME来设置主机名。

    3. 因此要修改hostname， 

       1. 修改/etc/HOSTNAME文件 
       2. 修改当前的$HOSTNAME变量 
       3. 停掉/etc/rc.d/boot.localnet 
       4. 启动 /etc/rc.d/boot.localnet

    4. 详细操作如下：

       ```SHELL
       # export HOSTNAME=myname
       # echo $HOSTNAME>/etc/HOSTNAME
       # /etc/rc.d/boot.localnet stop
       # /etc/rc.d/boot.localnet start
       ```

25. 关闭防火墙

    1. 关闭防火墙的方法

       ```shell
       service SuSEfirewall2_setup stop
       service SuSEfirewall2_init  stop
       ```

    2. 禁用防火墙自动启动的方法

       ```shell
       chkconfig SuSEfirewall2_init  off
       chkconfig SuSEfirewall2_setup off
       ```

    3. 检查防火墙服务的状态

       ```shell
       service SuSEfirewall2_setup status
       service SuSEfirewall2_init  status
       ```

31. 自动输入密码

    ```shell
    expect -c "
    
    spawn scp -r ../../share/cte/release/xcode_ctm.tar.gz root@10.253.181.91:/home/pkg
    expect {
    \"*assword\" {set timeout 300; send \"Admin123\r\";}
    \"yes/no\" {send \"yes\r\"; exp_continue;}
    }
    	
    expect eof"
    ```



32. shell条件表达式

    ```SHELL
    #文件表达式
    if [ -f  file ]    如果文件存在
    if [ -d ...   ]    如果目录存在
    if [ -s file  ]    如果文件存在且非空 
    if [ -r file  ]    如果文件存在且可读
    if [ -w file  ]    如果文件存在且可写
    if [ -x file  ]    如果文件存在且可执行   
    
    #整数变量表达式
    if [ int1 -eq int2 ]    等于
    if [ int1 -ne int2 ]    如果不等于    
    if [ int1 -ge int2 ]       如果>=
    if [ int1 -gt int2 ]       如果>
    if [ int1 -le int2 ]       如果<=
    if [ int1 -lt int2 ]       如果<
    if [  int1 -gt int2 -o int3 -gt int4 -a int5 -gt int6 ]  -o 或 -a 且
       
    #字符串变量表达式
    if  [ $a = $b ]                 如果string1等于string2,字符串允许使用赋值号做等号
    if  [ $string1 !=  $string2 ]   如果string1不等于string2       
    if  [ -n $string  ]             如果string 非空(非0），返回0(true)  
    if  [ -z $string  ]             如果string 为空
    if  [ $sting ]                  如果string 非空，返回0 (和-n类似) 
    ```

33. 将一个用户添加到用户组中，千万不能直接用： usermod -G groupA 这样做会使你离开其他用户组，仅仅做为 这个用户组 groupA 的成员。 应该用 加上 -a 选项： usermod -A  groupA user(FC4: usermod -G groupA,groupB,groupC user)-a 代表 append， 也就是 将自己添加到 用户组groupA 中，而不必离开 其他用户组。 

34. userdel jb51 注：删除用户jb51，但不删除其家目录及文件；userdel -r jb51 注：删除用户jb51，其家目录及文件一并删除；

35. 查看分区挂载lsblk 

36. 查看发行版本cat /etc/issue

37.  watch 定期执行命令

    1. 命令参数：-n或--interval  watch缺省每2秒运行一下程序，可以用-n或-interval来指定间隔的时间。

    -d或--differences  用-d或--differences 选项watch 会高亮显示变化的区域。 而-d=cumulative选项会把变动过的地方(不管最近的那次有没有变动)都高亮显示出来。

    -t 或-no-title  会关闭watch命令在顶部的时间间隔,命令，当前时间的输出。

    -h, --help 查看帮助文档

    2. 使用实例：
       1. 实例1：命令：每隔一秒高亮显示网络链接数的变化情况**watch -n 1 -d netstat -ant** 说明：**其它操作：切换终端： Ctrl+x退出watch：Ctrl+g**
       2. 实例2：每隔一秒高亮显示http链接数的变化情况命令：**watch -n 1 -d 'pstree|grep http'**说明：**每隔一秒高亮显示http链接数的变化情况。 后面接的命令若带有管道符，需要加''将命令区域归整。**
       3. 实例3：实时查看模拟攻击客户机建立起来的连接数命令：**watch 'netstat -an | grep:21 | \ grep<模拟攻击客户机的IP>| wc -l' **说明：
       4. 实例4：监测当前目录中** **scf'** **的文件****的变化命令：**watch -d 'ls -l|grep scf' **实例5：10秒一次输出系统的平均负载命令：**watch -n 10 'cat /proc/loadavg'

38. 递归修改文件权限find -type f -exec chmod 644 {} \;   或者：find -type f|xargs chmod 644 
39. 计算云euler添加yum源计算云申请的eulerOS 默认是没有带yum源的，有需要的话可以添加一下
    1. 使用下面的源，这个源是提供给开发者社区使用的，不对产品开放，自己可以调试使用http://developer.huawei.com/ict/site-euleros/euleros/repo/yum/2.5/os/x86_64/
    2. 进入以下目录/etc/yum.repos.d，创建Euler.repo文件，写入以下内容[Euler]name=Eulerbaseurl=http://developer.huawei.com/ict/site-euleros/euleros/repo/yum/2.5/os/x86_64/enabled=1gpgcheck=0
    3. 此时查看一下yum repolist all
    4. 执行清缓存 yum clean all yum makecache
    5. 下面就可以通过安装相关包 yum search gcc
40.  your CXX compiler: "CMAKE_CXX_COMPILER-NOTFOUND" was not found
    1. sudo yum install gcc-c++
41. cannot find -lz
    1. 【问题原因】模块编译时找不到相应的动态库，编译时在/lib目录下未找到libz.zo动态库。
    2. 【问题解决方法】libz.so动态库在linux环境下是有的，只是找不到，用以下命令建立软连接后再编译即可。

42. 模糊匹配历史命令

```shell
[root@tektea ~]# vi ~/.inputrc 
# for linux console and RH/Debian xterm
"\e[1~": beginning-of-line
"\e[4~": end-of-line
# commented out keymappings for pgup/pgdown to reach begin/end of history
#"\e[5~": beginning-of-history
#"\e[6~": end-of-history
"\e[5~": history-search-backward
"\e[6~": history-search-forward
"\e[3~": delete-char
"\e[2~": quoted-insert
"\e[5C": forward-word
"\e[5D": backward-word
"\e[1;5C": forward-word
"\e[1;5D": backward-word
 
# for rxvt
"\e[8~": end-of-line
"\eOc": forward-word
"\eOd": backward-word
 
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
"\eOH": beginning-of-line
"\eOF": end-of-line
 
# for freebsd console
"\e[H": beginning-of-line
"\e[F": end-of-line
set show-all-if-ambiguous on 
set completion-ignore-case on
```

[参考](https://blog.csdn.net/u010598445/article/details/48002889)

43. 软连接解决磁盘不足问题

```
mv /home /new
ln -s /usr1/htq /home/htq
```

这样，/home目录中的东东就都移到新硬盘中了。

44. 生成大文件

45. 生产core dump

    1. 先用#ulimit -a可以查看系统core文件的大小限制（第一行），core文件大小设置为0, 即没有打开core dump设置；

    2. ulimit -c 100 设置core文件最大为100k 

    3. ulimit -c unlimited 不限制core文件大小

    4. 永久生效办法：vi /etc/profile  添加ulimit -c unlimited

    5. core文件自动加上进程ID：echo 1 > /proc/sys/kernel/core_uses_pid

    6. 指定core文件目录：vim /etc/sysctl.conf 添加：

       ```SHELL
       kernel.core_pattern = /var/core/core_%e_%p
       kernel.core_uses_pid = 0
       ```

       