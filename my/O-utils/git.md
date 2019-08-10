

## Auto packing the repository in background for optimum performance

git运行突然提示 
Auto packing the repository in background for optimum performance

查资料，原来是自己本地一些 “悬空对象”太多(git删除分支或者清空stash的时候，这些其实还没有真正删除，成为悬空对象，我们可以使用merge命令可以从中恢复一些文件)

解决： 
1.输入命令：git fsck --lost-found，可以看到好多“dangling commit” 
2.清空他们：git gc --prune=now，完成



## error: RPC failed; curl 56 GnuTLS recv error (-110): The TLS connection was non-properly terminated.

apt install gnutls-bin

## error: RPC failed; curl 56 GnuTLS recv error (-9): A TLS packet with unexpected length was received

sudo apt-get purge git

sudo apt-get install git

## git 没有颜色

git config --global color.ui true



## server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none

```shell
export GIT_SSL_NO_VERIFY=1
```