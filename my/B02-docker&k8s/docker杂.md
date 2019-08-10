[docker gitbook](<https://yeasy.gitbooks.io/docker_practice/introduction/>)

## 代理（公司拉欧拉镜像配上代理即可）

vi /etc/systemd/system/docker.service.d/http-proxy.conf  

vi /etc/systemd/system/docker.service.d/https-proxy.conf  

[Service]

Environment="HTTP_PROXY=<http://h00379181:OP()op90!@proxy.huawei.com:8080/>" "HTTPS_PROXY=[http://h00379181:OP](https://h00379181:OP/)()[op90@proxy.huawei.com](mailto:op90@proxy.huawei.com):8080"





systemctl daemon-reload

service docker restart

## 欧拉安装docker 18.03

1. vi /root/.bashrc 配置代理 

   ```shell
   export http_proxy="http://h00379181:OP()op90@proxyhk.huawei.com:8080"
   export https_proxy="http://h00379181:OP()op90@proxyhk.huawei.com:8080"
   ```

2. 参照 [yum安装docker](https://yeasy.gitbooks.io/docker_practice/install/centos.html?q=)

3. 若遇到报错

      ```SHELL
   Error: Package: 3:docker-ce-19.03.0-1.4.beta4.el7.x86_64 (docker-ce-test)
              Requires: container-selinux >= 2.9
    You could try using --skip-broken to work around the problem
    You could try running: rpm -Va --nofiles --nodiges
   ```

   下载并安装container-selinux

   ``` SHELL
   $ wget http://mirrors.atosworldline.com/public/centos/7/extras/x86_64/Packages/container-selinux-2.68-1.el7.noarch.rpm
   $ rpm -ivh container-selinux-2.68-1.el7.noarch.rpm --nodeps --force
   ```

   

## docker: Error response from daemon: Get https://registry-1.docker.io/v2/: proxyconnect tcp: tls: first record does not look like a TLS handsh

解决：

vi /etc/systemd/system/docker.service.d/http-proxy.conf  

vi /etc/systemd/system/docker.service.d/https-proxy.conf  

[Service]

Environment="HTTP_PROXY=<http://h00379181:OP()op90!@proxy.huawei.com:8080/>" "HTTPS_PROXY=[http://h00379181:OP](https://h00379181:OP/)()[op90@proxy.huawei.com](mailto:op90@proxy.huawei.com):8080"

http不带s

## docker和