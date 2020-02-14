# 4-2 创建PXC的MySQL集群

> 本节是在单主机上进行地，多节点的pxc集群搭建参考 https://www.cnblogs.com/dowi/p/10220166.html ,注意pxc镜像的版本一定要用5.7.21版本，即pull的时候要用`docker pull percona/percona-xtradb-cluster:5.7.21`,不用5.7.21会出各种奇怪的问题！！

## 镜像地址

[percona/percona-xtradb-cluster](https://hub.docker.com/r/percona/percona-xtradb-cluster)

## 用到的命令

+ 安装：
  + `docker pull percona/percona-xtradb-cluster`
  + `docker load < /home/soft/pxc.tar.gz`

+ 更名：
  + docker tag percona/percona-xtradb-cluster pxc

+ 删除：
  + `docker rmi percona/percona-xtradb-cluster pxc`

+ 创建卷
  + `docker volume create --name v#`

+ 创建PXC集群mysql
  + `docker run -d -p 3306:3306 -v v2:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 -e CLUSTER_JOIN=node1 --privileged --name=node2 --net=net1 --ip 172.19.0.3 pxc`

## 创建内部网络

> docker虚拟机自带的网段为`172.17.0.*`，则`docker network create net1`的ip地址为`172.18.0.*`, 以此类推...
+ 创建内部网络：`docker network create --subnet=172.18.0.0/24 net1`,成功会返回一个常常的字符串id
  ```shell
  [root@SZV1000302636 ~]# docker network create --subnet=172.18.0.0/24 net1
  5b59776c5dd6120d9e8c0feb266c31d597a82b0c13557667745db631cea1e451
  [root@SZV1000302636 ~]# docker network inspect net1
  [
      {
          "Name": "net1",
          "Id": "5b59776c5dd6120d9e8c0feb266c31d597a82b0c13557667745db631cea1e451",
          "Created": "2019-06-06T16:28:37.750002066+08:00",
          "Scope": "local",
          "Driver": "bridge",
          "EnableIPv6": false,
          "IPAM": {
              "Driver": "default",
              "Options": {},
              "Config": [
                  {
                      "Subnet": "172.18.0.0/24"
                  }
              ]
          },
          "Internal": false,
          "Attachable": false,
          "Ingress": false,
          "Containers": {},
          "Options": {},
          "Labels": {}
      }
  ]
  ```
+ 查看内部网络：`docker network inspect net1`
+ 删除内部网络：`docker network rm net1`
+ 由于创建内部网络没有指定 --subnet, run容器时出错：
  + docker: Error response from daemon: User specified IP address is supported only when connecting to networks with user configured subnets.
  + 解决方案 http://www.suohi.cc/posts/57be697d731d7c006f9daf74
  
  
## PXC创建Docker卷

### 为什么要创建Docker卷？

+ 1.不要在容器内部存储数据，通过-v目录映射，把业务数据存储到宿主机中
+ 2.pxc无法直接使用映射目录，可创建docker卷，通过docker卷映射到容器的目录

#### 所以容器中的PXC节点映射到数据目录需要Docker卷来中转

> pxc无法直接使用映射目录，可创建docker卷，通过docker卷映射到容器的目录

+ 创建Docker卷：`docker volume create --name v1`
+ 查看Docker卷：`docker inspect v1`
  ```shell
  [root@SZV1000302636 ~]# docker volume create v1
  v1
  [root@SZV1000302636 ~]# docker inspect v1
  [
      {
          "Driver": "local",
          "Labels": {},
          # 这个是Docker卷的真实路径，可以把它关联到我们自定义的路径上,比如MySQL的数据路径
          "Mountpoint": "/var/lib/docker/volumes/v1/_data", 
          "Name": "v1",
          "Options": {},
          "Scope": "local"
      }
  ]
  ```
+ 删除Docker卷：`docker volume rm v1`

## 创建PXC容器

### 创建第一个PXC容器

> docker run -d -p 3306:3306 -v v1:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 --privileged --name=node1 --net=net1 --ip 172.18.0.2 pxc

+ `-d`：守护线程后台持续运行
+ `-p 3306:3306`：对外端口映射
+ `-v v1:/var/lib/mysql`：把Docker卷和Docker内部的MySQL数据存储路径绑定到一起
+ `-e MYSQL_ROOT_PASSWORD=abc123456`:数据库密码
+ `-e CLUSTER_NAME=PXC`：PXC集群名称
+ `-e XTRABACKUP_PASSWORD=abc123456`：数据库节点之间的同步密码
+ `--privileged`：赋予最高权限
+ `--name=node1`：起的容器的名字
+ `--net=net1`：内部网段
+ `--ip 172.18.0.2`:分配的内网ip，这里自己指定，这些内网段ip在当前VM以外是不能访问地.docker虚拟机自带的网段为`172.17.0.*`，则`docker network create net1`的ip地址为`172.18.0.*`, 以此类推...
+ `pxc`:用来创建容器的镜像的名字

### 创建第2~5个PXC容器

+ 先创建2~5的Docker卷
  ```shell
  docker volume create v2
  docker volume create v3
  docker volume create v4
  docker volume create v5
  ```

+ 第2个
  > docker run -d -p 3307:3306 -v v2:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 -e CLUSTER_JOIN=node1 --privileged --name=node2 --net=net1 --ip 172.18.0.3 pxc

+ 第3个
  > docker run -d -p 3308:3306 -v v3:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 -e CLUSTER_JOIN=node1 --privileged --name=node3 --net=net1 --ip 172.18.0.4 pxc
  
+ 第4个
  > docker run -d -p 3309:3306 -v v4:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 -e CLUSTER_JOIN=node1 --privileged --name=node4 --net=net1 --ip 172.18.0.5 pxc
  
+ 第5个
  > docker run -d -p 3310:3306 -v v5:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 -e CLUSTER_JOIN=node1 --privileged --name=node5 --net=net1 --ip 172.18.0.6 pxc


创建完毕，可以在navicat 中连接上面的5个数据库，只要其中任何一个有改动，都会实时同步到其他四个数据库地，有1个同步失败则全局都会更新失败~
