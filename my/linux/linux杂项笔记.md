1. 模糊匹配历史命令

   ```shell
   [root@tektea ~]# vi ~/.inputrc 
   "\e[A": history-search-backward 
   "\e[B":history-search-forward 
   set show-all-if-ambiguous on 
   set completion-ignore-case on
   ```

   [参考](https://blog.csdn.net/u010598445/article/details/48002889)

2. 软连接解决磁盘不足问题

   ```
   mv /home /new
   ln -s /new/home /home
   ```

   这样，/home目录中的东东就都移到新硬盘中了。

