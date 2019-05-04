## 理解几点

minikube是一个虚拟机

在mac上可以通过virtualbox运行minikube

安装 virtualbox ： brew install task virtualbox

安装minikube：brew install task minikube 



## brew源问题

## docker源问题



## 安装minikube

<https://www.jianshu.com/p/74957f08646b>

<https://kubernetes.io/docs/tasks/tools/install-minikube/>

<https://kubernetes.io/docs/setup/minikube/#installation>



安装virualboxsh失败

``` shell
To install and/or use virtualbox you may need to enable their kernel extension in

  System Preferences → Security & Privacy → General
```

then run `brew cask install --force virtualbox` again.

## 代理问题

开启代理，这里我是用的是shadowshock-ng 通过自己在aws搭建的vpn服务器翻墙

注意代理在termial内是默认不生效的，可shadowshock-ng “复制终端代理命令执行”，只针对单个终端，可在～/.bashrc ～/.zshrc 上持久化

理解几个代理，宿主机代理（终端），http代理，socket代理，docker代理，虚拟机代理

1.shadowshock http代理设置0.0.0.0 1087 （代理的 HTTP 监听必须是在所有网卡上，即监听地址 0.0.0.0 而不是 127.0.0.1 或者 localhost，否则虚拟机内是连不上代理的）

2.docker代理设置0.0.0.0:1087，mac直接用docker客户端

3.

```shell
export http_proxy=http://127.0.0.1:1087
export https_proxy=http://127.0.0.1:1087
export no_proxy=192.168.99.100		//宿主机访问virualbox

minikube start --docker-env HTTP_PROXY=10.0.2.2:1087 --docker-env HTTPS_PROXY=10.0.2.2:1087

启动集群后：
export no_proxy=$no_proxy,$(minikube ip)//忽略代理主要是针对宿主在访问集群时绕过代理
export NO_PROXY=$no_proxy,$(minikube ip)
```

上面可以加到～/.zshrc

<https://blog.zhesih.com/2018/06/24/k8s-minikube-setup/>  这篇文章在minikube 通过10.0.2.2可以访问宿主机，minikube start --docker-env HTTP_PROXY=10.0.2.2:1087 --docker-env HTTPS_PROXY=10.0.2.2:1087，还是不work是因为要执行 minikube stop ，minikube delete。。。，就没有后面一大堆事了

## 验证

### 启动一个容器服务

```shell
# hello-world 是要定义的容器名称 nginx:latest表明要用nginx镜像 --port=80表明容器对外暴露80端口
sudo kubectl run hello-world --image=nginx:latest --port=80

> deployment "hello-world" created
```

### 查看状态

```shell
sudo kubectl get pods

NAME                             READY     STATUS              RESTARTS   AGE
hello-world-57c96dbf64-slbgb         0/1       containerCreating   0          38s

sudo kubectl describe pods hello-world-180744149-lj0rd

Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  22m   default-scheduler  Successfully assigned default/hello-world-57c96dbf64-slbgb to minikube
  Normal  Pulling    22m   kubelet, minikube  Pulling image "nginx:1.7.9"
  
看上去是还在pull镜像，外网太慢，足足下载了30分钟，pods ready了
~  kubectl get pods
NAME                           READY   STATUS    RESTARTS   AGE
hello-world-57c96dbf64-slbgb   1/1     Running   0          31m

```

### 下载镜像太慢解决方法：用本地镜像替代

> 原理就是使用阿里云的镜像下载到本地，然后命名为minikube使用的gcr.io的同名镜像，替代远端镜像即可

```shell
# 下载阿里云镜像
docker pull registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0

# 本地命名为 gcr.io/google_containers/pause-amd64:3.0
docker tag registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0 gcr.io/google_containers/pause-amd64:3.0
```

### 重新启动服务

> 增加 `--image-pull-policy=IfNotPresent` 参数，表明优先使用本地镜像，不从远端拉取

```
sudo kubectl run hello-world --image=nginx:latest --port=80 --image-pull-policy=IfNotPresent
```

如果提示已经存在，换个名字重新执行即可。这时候查看服务状态应该是如下Running状态代表创建成功，但此时还不能访问容器

```
sudo kubectl get pods

NAMESPACE     NAME                             READY     STATUS             RESTARTS   AGE
default       hello-world-77867567f5-48czx   1/1       Running            2          16h
```

### 发布服务

```
sudo kubectl expose deployment hello-world --type=NodePort

> service "hello-world" exposed
```

### 查看服务地址

```
sudo minikube service hello-world --url

> http://192.168.99.104:31953
```

上面命令展示的地址即启动的nginx容器服务地址，访问 http://192.168.99.104:31953 即可出现nginx首页，服务成功启动！

## 常用命令

kubectl：

- ```shell
  - kubectl get pod
  - kubectl get pods —all-namespaces
  - kubectl get service
  - kubectl describe pods hello-minikube-180744149-lj0rd
  sudo minikube service hello-world --url
  ```

minikube：

```shell
- minikube dashboard
- minikube status
- minikube service hello-minikube —url
- curl $(minikube service hello-minikube —url)
```

## Reference

<https://blog.zhesih.com/2018/06/24/k8s-minikube-setup/>

<https://qii404.me/2018/01/06/minukube.html>

<https://kubernetes.io/docs/setup/minikube/#installation>

<https://kubernetes.io/docs/tasks/tools/install-minikube/>