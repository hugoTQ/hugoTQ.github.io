## docker与k8s发展

- 2013年像Cloud Foundry为代表的Paas项目已经使用NameSpace与Cgroups机制为每一个应用创建“沙盒”的隔离环境。
- Docker的创新在于镜像，彻底解决了打包这个根本性问题，让本地环境与云端环境高度一致。
- Google、RedHat等开源基础设施领域玩家们，共同牵头发起CNCF。以Kubernetes为基础的平台级社区，对抗以Docker公司为核心的容器商业生态。
- 2016年之后，以k8s为核心的的繁荣，2017年Docker公司将容器运行时部分Containerd捐献给CNCF社区，Docker项目改名为Moby，交给社区自行维护，Docker公司的商业产品占有Docker商标，表明放弃在开源社区的竞争。
- 容器本身没有价值，有价值的是“容器编排”。
- 沙盒（集装箱），顾名思义两个特点：隔离与搬运

## Docker 实现原理

- Namespace - 隔离
- Linux Cgroups（Linux Control Group）- 限制
- rootfs（镜像） - 一致性

## kubectl

- kubectl get node - 获取所

- kubectl get pods

  - kubectl get pods -l app=nginx

- kubectl discribe pod <pod-name>   查看API 对象的细节（包含ymal文件信息）

  

- 

