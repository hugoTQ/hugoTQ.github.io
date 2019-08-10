 1)关闭防火墙： #sevice iptables stop

​        

​        2)修改 /etc/samba/smb.conf，具体配置网上有,我的如下：

​                

​            security = share     ---- 这个要用上，share表示安全最低级别，其次是user,最高是server

​            

​            [共享目录名]

​                path = /home/用户名/共享目录名

​                ;read only = no  -----这个需要在前面用分号注释掉

​                writeable = yes

​                browseable = yes

​                public = yes

​                guest ok = yes

​                

​        3)SELinux作怪

​            修改/etc/sysconfig/selinux 把enforcing改成disabled；然后命令行setenforce 0；

​            或者用Rainsome兄说的 使用selinux强制策略：chcon -R -t samba_share_t /home/suyang/"Fedora Samba"         

​            

​        4)修改目录权限 #chmod 777 /home/wind ; #chmod 777 /home/wind/smbShare; 特别是前面一个做为上层目录权限也需要修改！！！！

​        

​        5)重启samba服务 #service smb restart 或者 /etc/rc.d/init.d/smb restart







cento系统



[global]

​        workgroup = SAMBA



​        passdb backend = tdbsam



​        printing = cups

​        printcap name = cups

​        load printers = yes

​        cups options = raw

​        usershare allow guests = Yes

​        security = user  //这里关键

map to guest = Bad User //这里关键

[homes]

​        comment = Home Directories

​        valid users = %S, %D%w%S

​        browseable = No

​        read only = No

​        inherit acls = Yes



[printers]

​        comment = All Printers

​        path = /var/tmp

​        printable = Yes

​        create mask = 0600

​        browseable = No



[print$]

​        comment = Printer Drivers

​        path = /var/lib/samba/drivers

​        write list = @printadmin root

​        force group = @printadmin

​        create mask = 0664

​        directory mask = 0775



[hugo]

​        comment = hugo

​        path = /home/htq/gowork

​        browseable = yes

​        writable = yes

​        guest ok = yes

​        create mask = 0600

​        force user = htq



测试：

smbclient -L 127.0.0.1

op90OP()



service smb restart

ununtu：sudo service smbd restart