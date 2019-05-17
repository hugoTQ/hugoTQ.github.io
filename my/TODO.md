# TODO List

标签（空格分隔）： 未分类

---

在此输入正文
# 陷阱1：接口nil

	template, err := api.getTemplateByApollo(req, w)
	if err != nil {
		httpresp.ErrorResponse(w, err, err)
		return
	}
	
	resp, err := api.createWorkflow(req, template)
	if err != nil {
		log.Errorf("create workflow error %v, %p", err, err)
		httpresp.ErrorResponse(w, err, err)
		return
	}


func (api *Api) getTemplateByApollo(req *CreateRequest, w http.ResponseWriter) (*Param, *errors.CodedError) {
	key := req.PolicyKey
	template := apollo.GetStringValueWithNameSapce(setting.ApplicationAppID, setting.ApplicaionNamespaceName, key, "")
	if template == "" {
		log.Errorf("transcoding para not exist, key %s, conf %+v", key)
		return nil, errors.NewErrorf(errors.TranscodeTransParaNotFound, "key %s", key)
	}

	log.Debugf("get template %s", template)
	transPara := new(Param)
	if err := json.Unmarshal([]byte(template), transPara); err != nil {
		log.Errorf("Unmarshal transcoding para error %v", err)
		return nil, errors.NewErrorf(errors.TranscodeMsgParseFail,
			"unmarshal the template failed. Failure message: %v. Please check the template in apollo, policyKey: %s.", err, key)
	}
	log.Debugf("trans para %+v", transPara)
	if err := processTransPara(transPara); err != nil {
		log.Errorf("transcoding para error %v", err)
		return nil, err
	}
	return transPara, nil
}

func (api *Api) createWorkflow(req *CreateRequest, para *Param) (*http.Response, *errors.CodedError) {
return nil
}




#陷阱二：给range的value赋值
go的数组元素可以通过 索引（位置）来读取（或者修改），索引从 0 开始，第一个元素索引为 0，第二个索引为 1，以此类推。

可以通过for结构遍历数组，实现以下功能：

通过 for 初始化数组项
通过 for 打印数组元素
通过 for 依次处理元素
for结构的基本使用方式如下：

package main
import "fmt"

func main() {
    var arr1 [5]int

    for i:=0; i < len(arr1); i++ {
        arr1[i] = i * 2
    }
    
    for i:=0; i < len(arr1); i++ {
        fmt.Printf("Array at index %d is %d\n", i, arr1[i])
    }
}
for 循环中的条件非常重要：i < len(arr1)，如果写成 i <= len(arr1) 的话会产生越界错误。所以，我们一般用关键字range来避免这种错误。

for i, v:= range arr1 {
  ...
}
当然以上两种 for 结构对于切片（slices）来说也同样适用。

需要注意的问题来了，通过range遍历得到的value是值拷贝。

type s struct {
    i int
}

func main() {
    m := make([]s, 0)
    m = append(m, s{i: 0})
    m = append(m, s{i: 1})
    m = append(m, s{i: 2})
    for _, e := range m { //e是值拷贝
        e.i = 3
    }
    for _, x := range m {
        fmt.Printf("%v\n", x.i)
    }
}
上述代码第一个for循环中的e是原值的拷贝，所以e.i = 3并没有修改原数组中的元素，所以输出的结果如下：

0
1
2
如果非要在使用range遍历的过程中修改数组内容，那么还是要用下标访问数组元素。

type s struct {
    i int
}

func main() {
    m := make([]s, 0)
    m = append(m, s{i: 0})
    m = append(m, s{i: 1})
    m = append(m, s{i: 2})
    for index := range m { //获取索引
        m[index].i = 3 //通过下标获取元素进行修改
    }
    for _, x := range m {


## 陷阱三
[Golang数组与Slice，以及append函数的陷阱](https://blog.csdn.net/zhaominpro/article/details/80765241)

 


# 待学习
## 开源工具
### k8s
### es
### openfalcon
### grafana
### docker
- docker-machine：docker-machine是解决docker运行环境问题。docker技术是基于Linux内核的cgroup技术实现的，那么问题来了，如果在非Linux平台上使用docker技术需要依赖安装Linux系统的虚拟机。docker-machine就是docker公司官方提出的，用于在各种平台上快速创建具有docker服务的虚拟机的技术。你可以把它理解为virtualbox或者vmware，最开始在win7上用得比较多，但是win10开始自带了hyper-v虚拟机，已经不再需要docker-machine了，docker可以直接运行在安装了Linux系统得hyper-v上。
- docker-composed：主要是解决本地docker容器编排问题。一般是通过yaml配置文件来使用它，这个yaml文件里能记录多个容器启动的配置信息（镜像、启动命令、端口映射等），最后只需要执行docker-compose对应的命令就会像执行脚本一样地批量创建和销毁容器。
- docker-swarm解决多主机多个容器调度部署得问题。swarm是基于docker平台实现的集群技术，他可以通过几条简单的指令快速的创建一个docker集群，接着在集群的共享网络上部署应用，最终实现分布式的服务。swarm技术相当不成熟，很多配置功能都无法实现，只能说是个半成品，目前更多的是使用Kubernetes来管理集群和调度容器。总结：如果你是在非Linux环境下考虑使用docker-compose，当然我更推荐使用hyper-v或者virtualbox。如果你需要同时操作多个容器，或者希望使用配置文件记录容器启动命令参数，那么推荐使用docker-compose。如果你需要在多台主机上部署docker容器，并对其进行调度，那么swarm是一种选择，当然更推荐Kubernetes。

### [docker build host](https://www.debugself.com/archives/136)

### Open Falcon

----
## go 
### [context](http://www.flysnow.org/2017/05/12/go-in-action-go-context.html)

### go语言http长连接
- [Go HTTP Client 持久连接](https://serholiu.com/go-http-client-keepalive)
- [go HTTP Client大量长连接保持(自定义client设置及源码简单分析)](https://blog.csdn.net/kdpujie/article/details/73177179)
- [go net/http Client使用——长连接客户端的使用](https://blog.csdn.net/u013870094/article/details/78731460)

### go调试
- [Golang程序调试工具介绍(gdb vs dlv)](http://lday.me/2017/02/27/0005_gdb-vs-dlv/)

### dep
[Golang官方依赖管理工具：dep](https://studygolang.com/articles/10589)

### ctm 、conductor 
```GO
func Create(req Request, opts ...OptionFunc) (Tasker, error) { // opts 这用了什么设计模式了么？
	var err error

	option := &Option{}

	for _, o := range opts {
		o(option)
	}

	t := &task{
		access:     option.access,
		priority:   option.priority,
		typ:        option.typ,
		timestamps: make([]time.Time, StatusCount),
	}
	t.setStatus(Created, false)

	t.remoteActions, err = req.BreakDownToRemoteActions()
	if err != nil {
		return nil, err
	}

	t.localActions, err = req.BreakDownToLocalActions()
	if err != nil {
		return nil, err
	}

	id, err := storage.GetNextTaskID()
	if err != nil {
		return nil, err
	}
	t.id = ID(id)

	for _, a := range t.remoteActions {
		if a.GetName() == "screenshot" {
			a.(*screenshot.Action).SetTaskId(int(t.id))
		}
	}

	if err := t.convert().Create(); err != nil {
		return nil, err
	}

	return t, nil
}
```
```go
// Request represents create task request.
type Request interface {
	BreakDownToRemoteActions() ([]action.RemoteAction, error)
	BreakDownToLocalActions() ([]action.LocalAction, error)
}
```


### goredis subscribe publish

## redis
Redis内存满了的几种解决方法（内存淘汰策略与Redis集群）



## 其他
### 制作证书
#!/bin/bash

set -x

passwd="kj3Etkasdgh3523ksdjgks22355"

# ca
openssl genrsa -out ca_key.pem -aes256 -passout pass:kj3Etkasdgh3523ksdjgks22355 2048
openssl req -x509 -new -key ca_key.pem -passin pass:$passwd -sha256 -out ca.100d.pem -subj "/C=CN/ST=Guangdong/L=Shenzhen/O=Huawei/OU=IT/CN=RootCA" -days 100

# restful server, 10 day
openssl genrsa -out server_key.pem -aes256 -passout pass:$passwd 2048
openssl req -new -key server_key.pem -passin pass:$passwd -out server_key.csr -subj "/C=CN/ST=Guangdong/L=Shenzhen/O=Huawei/OU=IT/CN=xcode" -days 10
openssl x509 -req -in server_key.csr -out server_cert.10d.pem -CA ca.100d.pem -CAkey ca_key.pem -passin pass:$passwd -sha256 -days 10 -CAcreateserial -extensions v3_req
cat server_cert.10d.pem server_key.pem > rest_server_cert.10d.pem

# ca list
openssl genrsa -out ca_key.pem -aes256 -passout pass:$passwd 2048
openssl req -x509 -new -key ca_key.pem -passin pass:$passwd -sha256 -out ca.10d.pem -subj "/C=CN/ST=Guangdong/L=Shenzhen/O=Huawei/OU=IT/CN=RootCA" -days 10
openssl req -x509 -new -key ca_key.pem -passin pass:$passwd -sha256 -out ca.20d.pem -subj "/C=CN/ST=Guangdong/L=Shenzhen/O=Huawei/OU=IT/CN=RootCA" -days 20
openssl req -x509 -new -key ca_key.pem -passin pass:$passwd -sha256 -out ca.30d.pem -subj "/C=CN/ST=Guangdong/L=Shenzhen/O=Huawei/OU=IT/CN=RootCA" -days 30
openssl req -x509 -new -key ca_key.pem -passin pass:$passwd -sha256 -out ca.40d.pem -subj "/C=CN/ST=Guangdong/L=Shenzhen/O=Huawei/OU=IT/CN=RootCA" -days 40
openssl req -x509 -new -key ca_key.pem -passin pass:$passwd -sha256 -out ca.50d.pem -subj "/C=CN/ST=Guangdong/L=Shenzhen/O=Huawei/OU=IT/CN=RootCA" -days 50
openssl req -x509 -new -key ca_key.pem -passin pass:$passwd -sha256 -out ca.60d.pem -subj "/C=CN/ST=Guangdong/L=Shenzhen/O=Huawei/OU=IT/CN=RootCA" -days 60
cat ca.10d.pem ca.20d.pem ca.30d.pem ca.40d.pem ca.50d.pem ca.60d.pem > cas.pem

 # go-redis
 ## public-suscribe