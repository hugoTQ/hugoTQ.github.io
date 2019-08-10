1. 模糊匹配历史命令

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

2. 软连接解决磁盘不足问题

   ```
   mv /home /new
   ln -s /usr1/htq /home/htq
   ```

   这样，/home目录中的东东就都移到新硬盘中了。

3. 生成大文件

   