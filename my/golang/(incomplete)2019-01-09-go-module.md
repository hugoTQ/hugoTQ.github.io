# go module 第三方软件管理

## 环境准备

### 导入CA证书

导出证书参考：http://3ms.huawei.com/km/blogs/details/5313743

导入证书，centos/欧拉：

1. 证书放到 /etc/pki/ca-trust/source/anchors/
2. 执行`/bin/update-ca-trust`

suse12的还要找下

### git配置国外代理

~/.gitconfig 添加：

[http]
    sslVerify = false
    postBuffer = 524288000
    proxy = http://工号:密码@proxyus2.huawei.com:8080/
[https]
    sslVerify = false
    postBuffer = 524288000
    proxy = http://工号:密码@proxyus2.huawei.com:8080/



## go mod应用



/gowork/pkg/mod/cache/vcs

/gowork/pkg/mod/cache/download



### 初始化

### 升级应用

手动修改go.mod ？go build、go list、go tidy都会自动更新到vendor