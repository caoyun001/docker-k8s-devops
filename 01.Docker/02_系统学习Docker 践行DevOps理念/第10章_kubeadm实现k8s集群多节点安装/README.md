# 第10章 Kubeadm实现多节点k8s集群安装

## 准备3台虚拟机
> 使用VirtualBox基于centos的ova镜像创建3台虚拟机

ova镜像在我的百度网盘里，实际是拿地[廖师兄的SpringBoot实战微信点餐系统](https://coding.imooc.com/down/117.html)的[课程资料里提供的镜像](https://git.imooc.com/coding-117/coding-117/src/develop/doc/虚拟机说明文档.md)，百度网盘的路径如下，直接从"管理"-->"导入虚拟电脑"即可，导入创建好把3台虚拟机的`/etc/hostname`分别改成master、node1、node2，然后重启3台虚拟机
![centos的用于virtualbox的ova镜像](images/centos的用于virtualbox的ova镜像.png)

最终得到的3台虚拟机信息如下：

| 虚拟机IP        | 用户名 | 密码   | 主机名 | 作用            |
| --------------- | ------ | ------ | ------ | --------------- |
| 192.168.100.116 | root   | 123456 | k8s-master | k8s的master节点 |
| 192.168.100.117 | root   | 123456 | k8s-node01  | k8s的node节点1  |
| 192.168.100.118 | root   | 123456 | k8s-node02  | k8s的node节点2  |

## 安装docker以及k8s均可以使用[阿里云的镜像源](https://developer.aliyun.com/mirror/)

## 安装docker

参考教程：https://developer.aliyun.com/mirror/docker-ce?spm=a2c6h.13651102.0.0.3e221b11lPzn2K

### Ubuntu 14.04/16.04（使用 apt-get 进行安装）
```shell
# step 1: 安装必要的一些系统工具
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
# step 2: 安装GPG证书
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
# Step 3: 写入软件源信息
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# Step 4: 更新并安装Docker-CE
sudo apt-get -y update
sudo apt-get -y install docker-ce

# 安装指定版本的Docker-CE:
# Step 1: 查找Docker-CE的版本:
# apt-cache madison docker-ce
#   docker-ce | 17.03.1~ce-0~ubuntu-xenial | https://mirrors.aliyun.com/docker-ce/linux/ubuntu xenial/stable amd64 Packages
#   docker-ce | 17.03.0~ce-0~ubuntu-xenial | https://mirrors.aliyun.com/docker-ce/linux/ubuntu xenial/stable amd64 Packages
# Step 2: 安装指定版本的Docker-CE: (VERSION例如上面的17.03.1~ce-0~ubuntu-xenial)
# sudo apt-get -y install docker-ce=[VERSION]
```
### CentOS 7（使用 yum 进行安装）
```shell
# step 1: 安装必要的一些系统工具
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
# Step 2: 添加软件源信息
sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# Step 3: 更新并安装Docker-CE
sudo yum makecache fast
sudo yum -y install docker-ce
# Step 4: 开启Docker服务
sudo service docker start

# 注意：
# 官方软件源默认启用了最新的软件，您可以通过编辑软件源的方式获取各个版本的软件包。例如官方并没有将测试版本的软件源置为可用，您可以通过以下方式开启。同理可以开启各种测试版本等。
# vim /etc/yum.repos.d/docker-ee.repo
#   将[docker-ce-test]下方的enabled=0修改为enabled=1
#
# 安装指定版本的Docker-CE:
# Step 1: 查找Docker-CE的版本:
# yum list docker-ce.x86_64 --showduplicates | sort -r
#   Loading mirror speeds from cached hostfile
#   Loaded plugins: branch, fastestmirror, langpacks
#   docker-ce.x86_64            17.03.1.ce-1.el7.centos            docker-ce-stable
#   docker-ce.x86_64            17.03.1.ce-1.el7.centos            @docker-ce-stable
#   docker-ce.x86_64            17.03.0.ce-1.el7.centos            docker-ce-stable
#   Available Packages
# Step2: 安装指定版本的Docker-CE: (VERSION例如上面的17.03.0.ce.1-1.el7.centos)
# sudo yum -y install docker-ce-[VERSION]
```

## 安装k8s

### Debian / Ubuntu
```shell
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF  
apt-get update
apt-get install -y kubelet kubeadm kubectl
```

### CentOS / RHEL / Fedora
```shell
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet
```
### 查看安装清单

> 三个节点都执行`rpm -ql kubelet`，返回如下内容表示成功
```shell
/etc/kubernetes/manifests #清单目录
/etc/sysconfig/kubelet #配置文件
/etc/systemd/system/kubelet.service
/usr/bin/kubelet #主程序
```

## 配置k8s集群

### 修改主机命名【可操作】
> 三个节点上都执行

```shell
 vim /etc/hosts
# 加入如下内容
192.168.100.116 k8s-master
192.168.100.117 k8s-node01
192.168.100.118 k8s-node02
```

### 关闭并禁用防火墙
> 三个节点上都执行

```shell
systemctl stop firewalld
systemctl disable firewalld
```

### 网络桥接设置
> 三个节点上都执行

```shell
echo 'net.bridge.bridge-nf-call-iptables = 1'>>/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-ip6tables = 1'>>/etc/sysctl.conf
sysctl -p
# 返回如下内容表示设置成功
# net.bridge.bridge-nf-call-iptables = 1
# net.bridge.bridge-nf-call-ip6tables = 1
```

### k8s相关docker镜像获取
> 三个节点上都执行

```shell
docker pull registry.cn-beijing.aliyuncs.com/yzxd/kube-apiserver:v1.12.1
docker pull registry.cn-beijing.aliyuncs.com/yzxd/kube-controller-manager:v1.12.1
docker pull registry.cn-beijing.aliyuncs.com/yzxd/kube-scheduler:v1.12.1
docker pull registry.cn-beijing.aliyuncs.com/yzxd/kube-proxy:v1.12.1
docker pull registry.cn-beijing.aliyuncs.com/yzxd/etcd:3.2.24
docker pull registry.cn-beijing.aliyuncs.com/yzxd/pause:3.1
docker pull registry.cn-beijing.aliyuncs.com/yzxd/coredns:1.2.2
docker pull registry.cn-beijing.aliyuncs.com/yzxd/flannel:v0.10.0-amd64

# 下载完成后，查看镜像
[root@k8s-master ~]# docker images
REPOSITORY                                                      TAG                 IMAGE ID            CREATED             SIZE
registry.cn-beijing.aliyuncs.com/yzxd/kube-proxy                v1.12.1             61afff57f010        2 months ago        96.6MB
registry.cn-beijing.aliyuncs.com/yzxd/kube-apiserver            v1.12.1             dcb029b5e3ad        2 months ago        194MB
registry.cn-beijing.aliyuncs.com/yzxd/kube-controller-manager   v1.12.1             aa2dd57c7329        2 months ago        164MB
registry.cn-beijing.aliyuncs.com/yzxd/kube-scheduler            v1.12.1             d773ad20fd80        2 months ago        58.3MB
registry.cn-beijing.aliyuncs.com/yzxd/etcd                      3.2.24              3cab8e1b9802        2 months ago        220MB
registry.cn-beijing.aliyuncs.com/yzxd/coredns                   1.2.2               367cdc8433a4        3 months ago        39.2MB
registry.cn-beijing.aliyuncs.com/yzxd/flannel                   v0.10.0-amd64       f0fad859c909        10 months ago       44.6MB
registry.cn-beijing.aliyuncs.com/yzxd/pause                     3.1                 da86e6ba6ca1        11 months ago       742kB

# 由于k8s使用镜像名称与下载的镜像名不同，需要进行镜像名称改动
docker tag registry.cn-beijing.aliyuncs.com/yzxd/pause:3.1 k8s.gcr.io/pause:3.1
docker tag registry.cn-beijing.aliyuncs.com/yzxd/coredns:1.2.2 k8s.gcr.io/coredns:1.2.2
docker tag registry.cn-beijing.aliyuncs.com/yzxd/etcd:3.2.24 k8s.gcr.io/etcd:3.2.24
docker tag registry.cn-beijing.aliyuncs.com/yzxd/kube-scheduler:v1.12.1 k8s.gcr.io/kube-scheduler:v1.12.1
docker tag registry.cn-beijing.aliyuncs.com/yzxd/kube-controller-manager:v1.12.1 k8s.gcr.io/kube-controller-manager:v1.12.1
docker tag registry.cn-beijing.aliyuncs.com/yzxd/kube-apiserver:v1.12.1 k8s.gcr.io/kube-apiserver:v1.12.1
docker tag registry.cn-beijing.aliyuncs.com/yzxd/kube-proxy:v1.12.1 k8s.gcr.io/kube-proxy:v1.12.1
docker tag registry.cn-beijing.aliyuncs.com/yzxd/flannel:v0.10.0-amd64 quay.io/coreos/flannel:v0.10.0-amd64

# 修改后的镜像列表
[root@k8s-master ~]# docker images
REPOSITORY                                                      TAG                 IMAGE ID            CREATED             SIZE
k8s.gcr.io/kube-proxy                                           v1.12.1             61afff57f010        2 months ago        96.6MB
registry.cn-beijing.aliyuncs.com/yzxd/kube-proxy                v1.12.1             61afff57f010        2 months ago        96.6MB
k8s.gcr.io/kube-scheduler                                       v1.12.1             d773ad20fd80        2 months ago        58.3MB
registry.cn-beijing.aliyuncs.com/yzxd/kube-scheduler            v1.12.1             d773ad20fd80        2 months ago        58.3MB
k8s.gcr.io/kube-apiserver                                       v1.12.1             dcb029b5e3ad        2 months ago        194MB
registry.cn-beijing.aliyuncs.com/yzxd/kube-apiserver            v1.12.1             dcb029b5e3ad        2 months ago        194MB
k8s.gcr.io/kube-controller-manager                              v1.12.1             aa2dd57c7329        2 months ago        164MB
registry.cn-beijing.aliyuncs.com/yzxd/kube-controller-manager   v1.12.1             aa2dd57c7329        2 months ago        164MB
k8s.gcr.io/etcd                                                 3.2.24              3cab8e1b9802        2 months ago        220MB
registry.cn-beijing.aliyuncs.com/yzxd/etcd                      3.2.24              3cab8e1b9802        2 months ago        220MB
k8s.gcr.io/coredns                                              1.2.2               367cdc8433a4        3 months ago        39.2MB
registry.cn-beijing.aliyuncs.com/yzxd/coredns                   1.2.2               367cdc8433a4        3 months ago        39.2MB
quay.io/coreos/flannel                                          v0.10.0-amd64       f0fad859c909        10 months ago       44.6MB
registry.cn-beijing.aliyuncs.com/yzxd/flannel                   v0.10.0-amd64       f0fad859c909        10 months ago       44.6MB
k8s.gcr.io/pause                                                3.1                 da86e6ba6ca1        11 months ago       742kB
registry.cn-beijing.aliyuncs.com/yzxd/pause                     3.1                 da86e6ba6ca1        11 months ago       742kB

# 删除下载的镜像
docker rmi registry.cn-beijing.aliyuncs.com/yzxd/kube-apiserver:v1.12.1
docker rmi registry.cn-beijing.aliyuncs.com/yzxd/kube-controller-manager:v1.12.1
docker rmi registry.cn-beijing.aliyuncs.com/yzxd/kube-scheduler:v1.12.1
docker rmi registry.cn-beijing.aliyuncs.com/yzxd/kube-proxy:v1.12.1
docker rmi registry.cn-beijing.aliyuncs.com/yzxd/etcd:3.2.24
docker rmi registry.cn-beijing.aliyuncs.com/yzxd/pause:3.1
docker rmi registry.cn-beijing.aliyuncs.com/yzxd/coredns:1.2.2
docker rmi registry.cn-beijing.aliyuncs.com/yzxd/flannel:v0.10.0-amd64

[root@k8s-master ~]# docker images
REPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
k8s.gcr.io/kube-proxy                v1.12.1             61afff57f010        2 months ago        96.6MB
k8s.gcr.io/kube-scheduler            v1.12.1             d773ad20fd80        2 months ago        58.3MB
k8s.gcr.io/kube-apiserver            v1.12.1             dcb029b5e3ad        2 months ago        194MB
k8s.gcr.io/kube-controller-manager   v1.12.1             aa2dd57c7329        2 months ago        164MB
k8s.gcr.io/etcd                      3.2.24              3cab8e1b9802        2 months ago        220MB
k8s.gcr.io/coredns                   1.2.2               367cdc8433a4        3 months ago        39.2MB
quay.io/coreos/flannel               v0.10.0-amd64       f0fad859c909        10 months ago       44.6MB
k8s.gcr.io/pause                     3.1                 da86e6ba6ca1        11 months ago       742kB
```

如果想获取更高k8s.gcr.io相关包，可根据以下方式获取，因为docker.io仓库对google的容器做了镜像，这根据网速快慢，决定下载快慢，网卡实时，可能会下载失败。下载完后修改成对应的名称。

```shell
docker pull mirrorgooglecontainers/kube-apiserver:v1.13.0
docker pull mirrorgooglecontainers/kube-controller-manager-amd64:v1.13.0
docker pull mirrorgooglecontainers/kube-scheduler-amd64:v1.13.0
docker pull mirrorgooglecontainers/kube-proxy-amd64:v1.13.0
```
到目前为止，所以镜像文件已经准备完毕！！！