# 搭建k8s集群完整篇

> 参考博客 https://www.jianshu.com/p/f4ac7f4555d3

- kubeadm是官方社区推出的一个用于快速部署kubernetes集群的工具。
- 这个工具能通过两条指令完成一个kubernetes集群的部署：



```ruby
# 创建一个 Master 节点
$ kubeadm init

# 将一个 Node 节点加入到当前集群中
$ kubeadm join <Master节点的IP和端口 >
```

## 1. 安装要求

在开始之前，部署Kubernetes集群机器需要满足以下几个条件：

- 一台或多台机器，操作系统 CentOS7.x-86_x64
- 硬件配置：2GB或更多RAM，2个CPU或更多CPU，硬盘30GB或更多
- 集群中所有机器之间网络互通
- 可以访问外网，需要拉取镜像
- 禁止swap分区

## 2. 学习目标

1. 在所有节点上安装Docker和kubeadm
2. 部署Kubernetes Master
3. 部署容器网络插件
4. 部署 Kubernetes Node，将节点加入Kubernetes集群中
5. 部署Dashboard Web页面，可视化查看Kubernetes资源

## 3. 准备环境



```ruby
关闭防火墙：
$ systemctl stop firewalld
$ systemctl disable firewalld

关闭selinux：
$ sed -i 's/enforcing/disabled/' /etc/selinux/config 
$ setenforce 0

关闭swap：
$ swapoff -a  $ 临时
$ vim /etc/fstab  $ 永久

添加主机名与IP对应关系（记得设置主机名）：
设置主机名：
vi /etc/sysconfig/network 
HOSTNAME=k8s-master
$ cat /etc/hosts
172.16.3.40 k8s-master
172.16.3.41 k8s-node1
172.16.3.42 k8s-node2

将桥接的IPv4流量传递到iptables的链：
$ cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
$ sysctl --system
```

## 4. 所有节点安装Docker/kubeadm/kubelet

Kubernetes默认CRI（容器运行时）为Docker，因此先安装Docker。

## 4.1 安装Docker



```ruby
$ wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
$ yum -y install docker-ce-18.06.1.ce-3.el7
$ systemctl enable docker && systemctl start docker
$ docker --version
Docker version 18.06.1-ce, build e68fc7a
```

### 4.2 添加阿里云YUM软件源



```csharp
$ cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

### 4.3 安装kubeadm，kubelet和kubectl

由于版本更新频繁，这里指定版本号部署：



```ruby
$ yum install -y kubelet-1.14.0 kubeadm-1.14.0 kubectl-1.14.0
$ systemctl enable kubelet

#安装kubelet 后会在/etc下生成文件目录/etc/kubernetes/manifests/
```

## 5. 部署Kubernetes Master

在172.16.3.40（Master）执行。



```ruby
$ kubeadm init \
  --apiserver-advertise-address=172.16.3.40 \
  --image-repository registry.aliyuncs.com/google_containers \
  --kubernetes-version v1.14.0 \
  --service-cidr=10.1.0.0/16 \
  --pod-network-cidr=10.244.0.0/16

  # kubeadm 以后将会在 /etc 路径下生成配置文件和证书文件
  [root@k8s-master etc]# tree kubernetes/
kubernetes/
├── admin.conf
├── controller-manager.conf
├── kubelet.conf
├── manifests
│   ├── etcd.yaml
│   ├── kube-apiserver.yaml
│   ├── kube-controller-manager.yaml
│   └── kube-scheduler.yaml
├── pki
│   ├── apiserver.crt
│   ├── apiserver-etcd-client.crt
│   ├── apiserver-etcd-client.key
│   ├── apiserver.key
│   ├── apiserver-kubelet-client.crt
│   ├── apiserver-kubelet-client.key
│   ├── ca.crt
│   ├── ca.key
│   ├── etcd
│   │   ├── ca.crt
│   │   ├── ca.key
│   │   ├── healthcheck-client.crt
│   │   ├── healthcheck-client.key
│   │   ├── peer.crt
│   │   ├── peer.key
│   │   ├── server.crt
│   │   └── server.key
│   ├── front-proxy-ca.crt
│   ├── front-proxy-ca.key
│   ├── front-proxy-client.crt
│   ├── front-proxy-client.key
│   ├── sa.key
│   └── sa.pub
└── scheduler.conf
```

- 另一种配置方法
- kubeadm init config kubeadm.yaml

由于默认拉取镜像地址k8s.gcr.io国内无法访问，这里指定阿里云镜像仓库地址。

使用kubectl工具：



```ruby
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
$ kubectl get nodes
```

## 6. 安装Pod网络插件（CNI）



```ruby
$ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml
```

确保能够访问到quay.io这个registery。

如果下载失败，可以改成这个镜像地址：roeslys/flannel

## 7. 加入Kubernetes Node

在172.16.3.62/63/64（Node）执行。

向集群添加新节点，执行在kubeadm init输出的kubeadm join命令：这个在master init初始化时会有提示，更换为自己的IP和token。



```csharp
$  kubeadm join 172.16.3.40:6443 --token l79g5t.6ov4jkddwqki1dxe --discovery-token-ca-cert-hash sha256:4f07f9068c543130461c9db368d62b4aabc22105451057f887defa35f47fa076
```

## 8. 测试kubernetes集群

在Kubernetes集群中创建一个pod，验证是否正常运行：



```ruby
$ kubectl create deployment nginx --image=nginx
$ kubectl expose deployment nginx --port=80 --type=NodePort
$ kubectl get pod,svc
```

## 9. 部署 Dashboard



```ruby
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
```

默认镜像国内无法访问，修改kubernetes-dashboard.yaml修改镜像地址为：
 先将文件下载下来：



```ruby
wget https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
# 原image 地址
# k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1
# 修改为
# roeslys/kubernetes-dashboard-amd64:v1.10.1
```

默认Dashboard只能集群内部访问，**修改Service为NodePort类型**，暴露到外部：不修改的话外部不能访问。



```tsx
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  type: NodePort
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 30000
  selector:
    k8s-app: kubernetes-dashboard
```

可以添加nodePort指定端口，然后访问地址，必须火狐浏览器用https打开：[https://NodeIP:30001](https://links.jianshu.com/go?to=https%3A%2F%2FNodeIP%3A30001)
 后续也可以自己添加ssl，安全方面后续再说。



```ruby
$ kubectl apply -f kubernetes-dashboard.yaml
```



```csharp
kubectl get pods,svc -n kube-system
```

创建service account并绑定默认cluster-admin管理员集群角色：



```ruby
$ kubectl create serviceaccount dashboard-admin -n kube-system
$ kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kube-system:dashboard-admin
$ kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $1}')
```

记录保存token，使用令牌登录。

![img](images\k8s的dashboard登录.png)

![img](images\k8s的dashboard详情.png)

> k8s搭建参考官方文档和李振良老师的视频和教程，也还有很多东西在官网和github和博客上找，很多坑问的是群的的志同道合的朋友，感谢大家的帮助,也希望大家一起努力，共同进步。

推荐网站和文档：

- [k8s中文文档](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.kubernetes.org.cn%2Fdocs)
- [https://github.com/kubernetes](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fkubernetes)
- [kubernetes官方文档](https://links.jianshu.com/go?to=https%3A%2F%2Fkubernetes.io%2Fzh%2Fdocs%2Fconcepts%2Foverview%2Fwhat-is-kubernetes%2F)
   视频：
- 云盘地址：[https://pan.baidu.com/s/1INns0FCY89rV4eAVwZedow](https://links.jianshu.com/go?to=https%3A%2F%2Fpan.baidu.com%2Fs%2F1INns0FCY89rV4eAVwZedow)
- 在线版：[https://ke.qq.com/course/266656](https://links.jianshu.com/go?to=https%3A%2F%2Fke.qq.com%2Fcourse%2F266656)