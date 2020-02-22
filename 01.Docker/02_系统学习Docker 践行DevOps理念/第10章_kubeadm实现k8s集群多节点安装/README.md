# 第10章 Kubeadm实现多节点k8s集群安装

## 准备3台虚拟机
> 使用VirtualBox基于centos的ova镜像创建3台虚拟机

ova镜像在我的百度网盘里，实际是拿地[廖师兄的SpringBoot实战微信点餐系统](https://coding.imooc.com/down/117.html)的[课程资料里提供的镜像](https://git.imooc.com/coding-117/coding-117/src/develop/doc/虚拟机说明文档.md)，百度网盘的路径如下，直接从"管理"-->"导入虚拟电脑"即可，导入创建好把3台虚拟机的`/etc/hostname`分别改成master、node1、node2，然后重启3台虚拟机
![centos的用于virtualbox的ova镜像](images/centos的用于virtualbox的ova镜像.png)

最终得到的3台虚拟机信息如下：

| 虚拟机IP        | 用户名 | 密码   | 主机名 | 作用            |
| --------------- | ------ | ------ | ------ | --------------- |
| 192.168.100.116 | root   | 123456 | master | k8s的master节点 |
| 192.168.100.117 | root   | 123456 | node1  | k8s的node节点1  |
| 192.168.100.118 | root   | 123456 | node1  | k8s的node节点2  |

