# etcd实现Docker多机容通信

+ 1. 实验准备
+ 2. 搭建etcd集群
+ 3. 重启docker服务
+ 4. 创建overlay
+ 5. 实验
  + 5.1 创建两个busybox容器
  + 5.2 验证连通性

## 1. 实验准备
准备两台可以相互通信的linux主机，并安装好docker。本实验准备的两台主机ip分别为：192.168.100.116和192.168.100.117
关闭两台机器的防火墙`systemctl disable firewalld`
## 2. 搭建etcd集群
etcd是开源免费的分布式存储工具，官网 https://coreos.com/etcd.
在两台机器上分别装上etcd  etcd-v3.3.12-linux-amd64.tar.gz

### 192.168.100.116上
```powershell
// 下载etcd
[root@eshop-cache04 opt]# wget https://github.com/coreos/etcd/releases/download/v3.0.12/etcd-v3.0.12-linux-amd64.tar.gz

// 解压
[root@eshop-cache04 opt]# tar zxvf  etcd-v3.3.12-linux-amd64.tar.gz

//进入目录
[root@eshop-cache04 opt]# cd etcd-v3.3.12-linux-amd64

//安装etcd
[root@eshop-cache04 etcd-v3.3.12-linux-amd64]#  nohup ./etcd --name docker-node1 --initial-advertise-peer-urls http://192.168.100.116:2380 \
--listen-peer-urls http://192.168.100.116:2380 \
--listen-client-urls http://192.168.100.116:2379,http://127.0.0.1:2379 \
--advertise-client-urls http://192.168.100.116:2379 \
--initial-cluster-token etcd-cluster \
--initial-cluster docker-node1=http://192.168.100.116:2380,docker-node2=http://192.168.100.117:2380 \
--initial-cluster-state new&
```
### 192.168.100.117上

```powershell
// 下载etcd
[root@eshop-cache04 opt]# wget https://github.com/coreos/etcd/releases/download/v3.0.12/etcd-v3.0.12-linux-amd64.tar.gz

// 解压
[root@eshop-cache04 opt]# tar zxvf  etcd-v3.3.12-linux-amd64.tar.gz

//进入目录
[root@eshop-cache04 opt]# cd etcd-v3.3.12-linux-amd64

//安装etcd
[root@eshop-cache04 etcd-v3.3.12-linux-amd64]#  nohup ./etcd --name docker-node2 --initial-advertise-peer-urls http://192.168.100.117:2380 \
--listen-peer-urls http://192.168.100.117:2380 \
--listen-client-urls http://192.168.100.117:2379,http://127.0.0.1:2379 \
--advertise-client-urls http://192.168.100.117:2379 \
--initial-cluster-token etcd-cluster \
--initial-cluster docker-node1=http://192.168.100.116:2380,docker-node2=http://192.168.100.117:2380 \
--initial-cluster-state new&
```

### 检查cluster状态
```powershell
[root@localhost etcd-v3.3.12-linux-amd64]# systemctl disable firewalld
[root@localhost etcd-v3.3.12-linux-amd64]# ./etcdctl cluster-health
member 74583f9f3f19ae56 is healthy: got healthy result from http://192.168.100.116:2379
member d636d1feb32075ad is healthy: got healthy result from http://192.168.100.117:2379
cluster is healthy
```

如果出现下面的情况，检查是防火墙已开启，关闭防火墙`systemctl disable firewalld`，再查看cluster状态
```powershell
[root@localhost etcd-v3.3.12-linux-amd64]#./etcdctl cluster-health
cluster may be unhealthy: failed to list members
Error:  client: etcd cluster is unavailable or misconfigured
error #0: dial tcp 127.0.0.1:4001: getsockopt: connection refused
```

## 3.重启docker服务
### 重启192.168.100.116
+ `service docker stop`
+ `/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=etcd://192.168.100.116:2379 --cluster-advertise=192.168.100.116:2375&
`
### 重启192.168.100.117
+ `service docker stop`
+ `/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=etcd://192.168.100.117:2379 --cluster-advertise=192.168.100.117:2375&
`

## 4.创建overlay
在192.168.100.116上创建overlay并查看
```powershell
[root@localhost ~]# docker network create -d overlay demo
e8bc9842dda7fa7918455dd0280d09c8c9956d0311c53984a90ecc0620c8ee55
[root@localhost ~]# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
bb615ec75def        bridge              bridge              local
e8bc9842dda7        demo                overlay             global
c27645bea545        host                host                local
cd3a13dd8dcb        mybridge            bridge              local
fcab1d25df11        none                null                local
```
在192.168.100.117上可以看到也自动有了demo网络

```powershell
[root@localhost ~]#  docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
0eba23b918ef        bridge              bridge              local
e8bc9842dda7        demo                overlay             global
c27645bea545        host                host                local
fcab1d25df11        none                null                local
```

查看创建的网络模式demo

```powershell
[
    {
        "Name": "demo",
        "Id": "e8bc9842dda7fa7918455dd0280d09c8c9956d0311c53984a90ecc0620c8ee55",
        "Created": "2020-02-17T00:13:52.194191669+08:00",
        "Scope": "global",
        "Driver": "overlay",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "10.0.0.0/24",
                    "Gateway": "10.0.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

## 5.实验
### 5.1 创建两个busybox容器
在192.168.100.116上创建名为test1的busybox容器
```powershell
docker run -d --name test1 --net demo busybox sh -c "while true; do sleep 3600; done"
```
在192.168.100.117上创建名为test1的busybox容器，会失败，因为demo网络里已经有一个test1了，在116上

```powershell
[root@localhost ~]# docker run -d --name test1 --net demo busybox sh -c "while true; do sleep 3600; done"Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
57c14dd66db0: Pull complete 
Digest: sha256:7964ad52e396a6e045c39b5a44438424ac52e12e4d5a25d94895f2058cb863a0
Status: Downloaded newer image for busybox:latest
b7d4a8a3c5c9e46986346614f210ea1b1e16669d30450a2e7bc79e6f8ce3d9ea
docker: Error response from daemon: endpoint with name test1 already exists in network demo.
```

所以在192.168.100.117上创建名为test2的busybox容器

```powershell
[root@localhost ~]# docker run -d --name test2 --net demo busybox sh -c "while true; do sleep 3600; done
```

### 5.2 验证连通性
192.168.100.116上网络状态
```powershell
[root@localhost ~]# docker exec test1 ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:0A:00:00:02  
          inet addr:10.0.0.2  Bcast:10.0.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1450  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

eth1      Link encap:Ethernet  HWaddr 02:42:AC:12:00:02  
          inet addr:172.18.0.2  Bcast:172.18.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:14 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1116 (1.0 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

```

192.168.100.117上网络状态

```powershell
[root@localhost ~]# sudo docker exec -it test2 ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:0A:00:00:03  
          inet addr:10.0.0.3  Bcast:10.0.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1450  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

eth1      Link encap:Ethernet  HWaddr 02:42:AC:13:00:02  
          inet addr:172.19.0.2  Bcast:172.19.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1248 (1.2 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

在192.168.100.116上执行命令，可以ping通192.168.100.117上创建的busybox(10.0.0.3)容器

```powershell
[root@localhost ~]# sudo docker exec test1 sh -c "ping 10.0.0.3"
PING 10.0.0.3 (10.0.0.3): 56 data bytes
64 bytes from 10.0.0.3: seq=0 ttl=64 time=6.775 ms
64 bytes from 10.0.0.3: seq=1 ttl=64 time=0.458 ms
64 bytes from 10.0.0.3: seq=2 ttl=64 time=0.401 ms
64 bytes from 10.0.0.3: seq=3 ttl=64 time=0.405 ms
64 bytes from 10.0.0.3: seq=4 ttl=64 time=0.395 ms
^Z
[1]+  Stopped                 sudo docker exec test1 sh -c "ping 10.0.0.3"
```