

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
​```





# Git - 项目拆分https://fqk.io/tags/Star/)

#### 操作

1. 使用 git subtree 为子项目创建一个 branch，该 branch 包含子项目相关的所有历史记录
2. git clone 上述 branch，然后推送到目标仓库
3. 根据需要，可清理上述 branch



#### 执行命令

```shell
## MAIN_PROJ_PATH: 需要被拆分的主工程路径
## SUB_PROJ_RELATIVE_PATH: 需要拆分出来的子工程相对于主工程的路径
## SOME_NAME: 任意取的某个分支名## SUB_PROJ_NAME: 子工程项目名
## GIT_REMOTE_URL: 子工程指向的仓库地址

cd <main_dir>
git subtree split -P <sub_dir> -b <sub_branch>

cd ..
git clone -b <sub_branch> <main_dir> <sub_branch>

cd <sub_branch>
git branch -m master
git remote remove origin
git remote add origin GIT_REMOTE_URL
git push -u origin master

cd <main_dir>
git branch -D <sub_branch>
​```



## 清除垃圾文件

- 查看仓库大小：`git count-objects -v`

- http://openfibers.github.io/blog/2015/03/04/use-bfg-to-clean-big-blog-in-git/

- 查找大文件：

  ```shell
  #!/bin/bash
  IFS=$'\n';
  
  # list all objects including their size, sort by size, take top 10
  objects=`git verify-pack -v .git/objects/pack/pack-*.idx | grep -v chain | sort -k3nr | head`
  
  echo "All sizes are in kB's. The pack column is the size of the object, compressed, inside the pack file."
  
  output="size,pack,SHA,location"
  for y in $objects
  do
          # extract the size in bytes
          size=$((`echo $y | cut -f 5 -d ' '`/1024))
          # extract the compressed size in bytes
          compressedSize=$((`echo $y | cut -f 6 -d ' '`/1024))
          # extract the SHA
          sha=`echo $y | cut -f 1 -d ' '`
          # find the objects location in the repository tree
          other=`git rev-list --all --objects | grep $sha`
          #lineBreak=`echo -e "\n"`
          output="${output}\n${size},${compressedSize},${other}"
  done
  
  echo -e $output | column -t -s ', 	
  ```

  

1. git clone --mirror  ssh://git@git.huawei.com:2222/Cloud_CDN/mpc/ctm.git
2. 直接删除大于多少M的文件：java -jar ../bfg-1.13.0.jar --strip-blobs-bigger-than 20M cte.git
3. 删除指定文件：java -jar bfg-1.13.0.jar -D libMDNAAP* ctm-mirror
4. 删除目录：java -jar bfg-1.13.0.jar --delete-folders suse* ctm.git
5. cd ctm.git & git reflog expire --expire=now --all && git gc --prune=now --aggressive
6. git push
```

```