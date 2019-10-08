

# 自己动手搭建VPN服务器

VPN的作用，不用做解释，有需要的人很明白。网上有很多卖VPS或VPN服务的，我曾经买过，但使用时，速度慢、不稳定。经常长时间的摸索，发现了稳定、可靠、数据安全（网上购买，担心用户数据会被泄露）、且**免费**的方法：基于Amazon AWS EC2搭建自己的VPN服务器。



搭建自己的VPN服务器，有**两个关键动作**：

**1、申请并创建免费的AWS EC2虚拟机**

可创建Linux主机，也可以创建Windows Server。这个主机就是一台干净的服务器。

**2、在虚拟机上搭建VPN 服务器**

Windows Server中搭建VPN Server非常简单，自行Google或bing搜索即可。本文针对Linux主机，搭建VPN Server。Linux中搭建VPN Server稍微复杂，对于Linux初学者，建议使用Windows Server。

 

以下是主要步骤：

**一、创建AWS EC2账户**

 登录<http://aws.amazon.com/cn/ec2/>页面，选择“**免费试用Amazon EC2**”。

![img](http://www.ilinuxkernel.com/files/vpn_media/image1.png)

我们来看一下免费套餐详细信息：

![img](http://www.ilinuxkernel.com/files/vpn_media/image2.png)

也就是说**创建1个虚拟机，可以一直开机免费运行一年**。AWS EC2的特点是按使用收费，关机时不收费。

- **750** **小时**的 Linux、RHEL 或 SLES t2.micro 实例使用量/月
- **750** **小时**的 Windows t2.micro 实例使用量/月
- 一次运行一个实例或同时运行多个实例

​    接下来就选择注册免费账户，填写信息。需要提供VISA或MasterCard信用卡。这里略去注册步骤。

​    注册过程中，建议要填写自己的真实手机号码，Amazon会回拨电话，要求在手机里输入注册页面提供的注册码。注册成功后，amazon会在你的信用卡扣费1美元，但不会形成实际账单，个人理解amazon就是验证信用卡有效性。

![img](http://www.ilinuxkernel.com/files/vpn_media/image3.png)

**二、创建AWS EC2 Instance（即虚拟机）**

1、创建好AWS账户后，进入登录页面

![img](http://www.ilinuxkernel.com/files/vpn_media/image4.png)

2、登录成功后，进入了Amazon Web Services页面。这里我们关注“**EC2云中的虚拟服务器**”

![img](http://www.ilinuxkernel.com/files/vpn_media/image5.png)

3、进入EC2控制面板后，我们就可以创建虚拟机了。选择“**启动实例**”：

启动实例，意思就是创建虚拟主机。这里注意网页右上角，有个**数据中心地址**。对于我们大陆来说，建议选择日本的“**东京”**。经过实测，东京的主机网络延时在100ms左右，而美国的俄勒冈，演示高达500ms。

![img](http://www.ilinuxkernel.com/files/vpn_media/image6.png)

4、启动实例后，进入下面页面：

  OS有**Linux**和**Windows**两种。Linux有Amazon Linux和Redhat、Suse、Ubutun。Windows版本有Windows Server2003/2008/2012。

  这里我们选择“**Amazon Linux**”。

![img](http://www.ilinuxkernel.com/files/vpn_media/image7.png)

5、这里我们选择免费的“**t2.micro**”，配置为1 vCPU和1GB内存，这个配置对于搭建一个VPN Server来说，足够了。

  注意amazon对实例存储的提示：“*实例可用的本地实例存储卷。实例存储中的数据不是永久性的* *–* *它仍然存在实例的生命周期中。*”

![img](http://www.ilinuxkernel.com/files/vpn_media/image8.png)

对于“符合条件的免费套餐”，Amazon的说明如下：

*微型实例有资格享用 AWS 免费使用套餐。在您注册 AWS 后的 12 个月，您每月可获得高达 750 小时的微型实例。如果您的免费使用期结束，或者应用程序用量超出免费使用套餐范围，只需按照标准服务费率根据使用量付费即可。*

*了解更多 有关免费使用套餐资格和限制的信息*

即你可以创建多个虚拟机，但所有虚拟机加起来免费运行时间是750小时。若只创建1个虚拟机，那么一直开机，一个月最多24×31=744小时。即我们可以使用一个虚拟机，一直免费开机用一年。

6、点击上一步页面的“**审核和启动**”，进入“**核查实例启动**”

 这里我们再次确认配置是免费的，1 vCPU、1GB内存

![img](http://www.ilinuxkernel.com/files/vpn_media/image9.png)

7、点击上一步的“启动”，提示“**选择现有密钥对或则创建新密钥对**”。

   由于我们第一次创建，没有密钥对。这里新建一个。

![img](http://www.ilinuxkernel.com/files/vpn_media/image10.png)

这里注意，要选择“下载密钥对”，将密钥文件下载本地。这样虚拟机创建后，我们才能远程SSH登录。

![img](http://www.ilinuxkernel.com/files/vpn_media/image11.png)

8、密钥文件下载完成后，启动实例。进入“**您的实例正在启动**”页面。

![img](http://www.ilinuxkernel.com/files/vpn_media/image12.png)

至此，虚拟机创建成功。我们点击实例，就可以对虚拟机进行配置。这里我的虚拟机编号” i-353dc2c3 “，点击即可进入配置界面。

 

**三、配置AWS EC2虚拟机**

配置过程中，常见的问题：

（1）我的虚拟机公网IP多少？

（2）我的公网IP可以ping通吗？ping不通的话，原因是什么？

（3）如何SSH登录我的EC2虚拟机？

（4）如何创建root用户密码？

 

前面创建完成虚拟机并启动后，就可以进入EC2控制面板，对实例进行配置。

![img](http://www.ilinuxkernel.com/files/vpn_media/image13.png)

**1****、获取EC2公网IP地址信息**

进入实例控制面板后，就可以看到公有IP地址信息，这个IP是可以全球访问的。就是我们要做VPN Server的IP地址。建议使用**浮动IP**，这样你的公网IP一直不会变。若不选择浮动IP，重启后，公网IP可能会变化。当然也可以直接使用**公有DNS**来访问你的主机，就不用记IP地址。

注意，此时的公有IP地址，还无法ping通，也没法直接SSH连接。这是因为EC2虚拟机创建时，“安全组”默认拒绝所有的连接（除SSH外）。后面将介绍如何修改。

![img](http://www.ilinuxkernel.com/files/vpn_media/image14.png)

**2****、如何SSH登录EC2虚拟机**

   刚才创建虚拟机过程中，我们创建了密钥文件，并下载到本地。此时我们要使用这个密钥文件登录。

   amazon有个网页专门说明如何SSH EC2虚拟机。

<http://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html>

​     从Windows机器登录说明：

<http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html>

（1）Linux系统登录方式

  若使用Linux机器登录，则非常简单。将下载的密钥文件拷贝到命令执行当前目录

​     ssh -i ilinuxkernel.pem [ec2-user@52.27.xx.xx](mailto:ec2-user@52.27.xx.xx)

   或则

​    ssh -i ilinuxkernel.pem ec2-user@ec2-52-25-237-29.us-west-2.compute.amazonaws.com

​    注意必须是ec2-user@共有IP或公有DNS，这种格式。用户名不能变。

 

或者（2）Windows登录方式

稍后会有提示ilinuxkernel.pem的位置。我们“import”即可，会提示你找密钥文件的位置。

   主要步骤：

   a）使用puttygen.exe转换我们下载的密钥文件，

![img](http://www.ilinuxkernel.com/files/vpn_media/image15.png)

创建的过程中，晃动一下鼠标：

 ![img](http://www.ilinuxkernel.com/files/vpn_media/image16.png)

 ![img](http://www.ilinuxkernel.com/files/vpn_media/image17.png)

![img](http://www.ilinuxkernel.com/files/vpn_media/image18.png)

![img](http://www.ilinuxkernel.com/files/vpn_media/image19.png)

![img](http://www.ilinuxkernel.com/files/vpn_media/image20.png)

b）使用转换后的密钥文件登录

![img](http://www.ilinuxkernel.com/files/vpn_media/image21.png)

 ![img](http://www.ilinuxkernel.com/files/vpn_media/image22.png)

 c）输入用户名ec2-user

![img](http://www.ilinuxkernel.com/files/vpn_media/image23.png)

**3****、创建root用户密码**

*https://aws.amazon.com/amazon-linux-ami/2015.03-release-notes/*

*31 package(s) needed for security, out of 64 available*

*Run “sudo yum update” to apply all updates.*

*[ec2-user@ip-172-31-19-108 ~]$ **sudo su –***

*[root@ip-172-31-19-108 ~]# passwd*

*Changing password for user root.*

*New password:*

*BAD PASSWORD: it is based on a dictionary word*

*Retype new password:*

*passwd: all authentication tokens updated successfully.*

*[root@ip-172-31-19-108 ~]#*



## 具体搭建步骤

### 准备工作

首先得找一台用来翻墙的海外服务器，该服务器一定要在墙外，比如：香港、新加坡、日本。你可以选择 AWS 的 EC2 或者阿里云的 ECS 服务器都可以。

其次，要在该服务器上安装 docker 运行时环境。这里以 CentOS 7 举例，首先安装 docker 运行时环境。

```shell
## 安装 docker
yum install docker -y

## 启动 docker 服务
service docker start
chkconfig docker on

## 检查 docker 版本
docker -version
复制代码
```

这些都成功了？恭喜你，你已经成功一半了！

### 拉取 docker 镜像

好了，现在让我们直接拉取别人做好的 docker 镜像。这里我选择的是 Github 上别人做好的 [Shadowsock VPN Docker 镜像](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Foddrationale%2Fdocker-shadowsocks)，直接执行以下命令即可。

```shell
docker pull oddrationale/docker-shadowsocks
复制代码
```



![img](https://user-gold-cdn.xitu.io/2018/6/4/163c921c4eff89f7?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



### 运行 docker 镜像

运行如下命令启动该 docker 镜像。

```
docker run -d -p 12346:12346 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 12346 -k welcome -m aes-256-cfb
复制代码
```

> - `-d`参数允许 docker 常驻后台运行
> - `-p`来指定要映射的端口，这里端口号统一保持一致即可。例如：12345
> - `-s`服务器 IP 地址，不用动
> - `-k`后面设置你的 VPN 的密码，比如：welcome
> - `-m`指定加密方式

运行`docker ps -a`查看容器是否已成功运行起来了。



![img](https://user-gold-cdn.xitu.io/2018/6/4/163c921c4ee25c0d?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



### 安装 vpn 客户端（Mac & Windows）

接下来要测试我们的 VPN 服务器是否正常工作了，由于我们大部分时间都是用 PC 来翻墙，先下载个好用的 VPN 客户端。这里推荐下载 [shadowsocks](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fshadowsocks)，简单易用，各个平台版本也都有。

- [Shadowsocks (Windows版本)](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fshadowsocks%2Fshadowsocks-windows%2Fwiki%2FShadowsocks-Windows-%25E4%25BD%25BF%25E7%2594%25A8%25E8%25AF%25B4%25E6%2598%258E)
- [ShadowsocksX-NG (Mac版本)](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fshadowsocks%2FShadowsocksX-NG)

这里以 Mac 版本为例，直接安装即可，非常简单。运行起来后，工具栏上有一个小飞机的图标，进入到“**服务器设置**”。



![img](https://user-gold-cdn.xitu.io/2018/6/4/163c921c4f2c37b8?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



点击“**+**”图标添加新的服务器，如下图所示设置连接信息。



![img](https://user-gold-cdn.xitu.io/2018/6/4/163c921c5052c22a?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



设置好以后，赶紧打开浏览器，试着访问一下：[www.google.com](https://link.juejin.im?target=http%3A%2F%2Fwww.google.com)，一切正常的话，新世界的大门已经向你敞开了。 

![img](https://user-gold-cdn.xitu.io/2018/6/4/163c921c5052017e?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

作者：钢钢更新

链接：https://juejin.im/post/5b14c5115188257d37761a5a

来源：掘金

著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



## Reference

http://ilinuxkernel.com/?p=1594

https://juejin.im/post/5b14c5115188257d37761a5ax·