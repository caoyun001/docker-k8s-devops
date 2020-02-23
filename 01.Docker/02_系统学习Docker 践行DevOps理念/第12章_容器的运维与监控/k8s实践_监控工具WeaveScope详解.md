# [k8s实践(十)：监控工具Weave Scope详解](https://blog.51cto.com/3241766/2447151)

**环境说明：**

| 主机名 |  操作系统版本   |      ip      | docker version | kubelet version | 配置 |    备注    |
| :----: | :-------------: | :----------: | :------------: | :-------------: | :--: | :--------: |
| master | Centos 7.6.1810 | 172.27.9.131 | Docker 18.09.6 |     V1.14.2     | 2C2G | master主机 |
| node01 | Centos 7.6.1810 | 172.27.9.135 | Docker 18.09.6 |     V1.14.2     | 2C2G |  node节点  |
| node02 | Centos 7.6.1810 | 172.27.9.136 | Docker 18.09.6 |     V1.14.2     | 2C2G |  node节点  |

+ **k8s集群部署详见：**[Centos7.6部署k8s(v1.14.2)集群](https://blog.51cto.com/3241766/2405624)
+ **k8s学习资料详见：**[基本概念、kubectl命令和资料分享](https://blog.51cto.com/3241766/2413457)
+ **k8s高可用集群部署详见：**[Centos7.6部署k8s v1.16.4高可用集群(主备模式)](https://blog.51cto.com/3241766/2463125)

# 一、Weave Scope简介

Weave Scope自动生成应用程序的映射，使您能够直观地理解、监视和控制基于容器化微服务的应用程序。

Weave Scope可以监控kubernetes集群中的一系列资源的状态、资源使用情况、应用拓扑、scale、还可以直接通过浏览器进入容器内部调试等,`其提供的功能包括:`

> - 交互式拓扑界面
> - 图形模式和表格模式
> - 过滤功能
> - 搜索功能
> - 实时度量
> - 容器排错
> - 插件扩展

Weave Scope由`App和Probe`两部分组成:

> - Probe 负责收集容器和宿主的信息，并发送给 App
> - App 负责处理这些信息，并生成相应的报告，并以交互界面的形式展示

# 二、Weave Scope安装

## 1.安装Weave Scopea

```bash
[root@master ~]# kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"
namespace/weave created
serviceaccount/weave-scope created
clusterrole.rbac.authorization.k8s.io/weave-scope created
clusterrolebinding.rbac.authorization.k8s.io/weave-scope created
deployment.apps/weave-scope-app created
service/weave-scope-app created
deployment.apps/weave-scope-cluster-agent created
daemonset.apps/weave-scope-agent created
```

![图片.png](https://ask.qcloudimg.com/draft/6211241/jffomkg3tc.png)

## 2.资源查看

```bash
[root@master ~]# kubectl get all -n weave 
NAME                                            READY   STATUS    RESTARTS   AGE
pod/weave-scope-agent-hx4t2                     1/1     Running   0          103s
pod/weave-scope-agent-vmbqr                     1/1     Running   0          103s
pod/weave-scope-agent-zd8x7                     1/1     Running   0          103s
pod/weave-scope-app-b99fb9585-77rld             1/1     Running   0          104s
pod/weave-scope-cluster-agent-58f5b5454-vnckm   1/1     Running   0          103s

NAME                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/weave-scope-app   ClusterIP   10.99.31.182   <none>        80/TCP    105s

NAME                               DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/weave-scope-agent   3         3         3       3            0           <none>          104s

NAME                                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/weave-scope-app             1/1     1            1           105s
deployment.apps/weave-scope-cluster-agent   1/1     1            1           105s

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/weave-scope-app-b99fb9585             1         1         1       105s
replicaset.apps/weave-scope-cluster-agent-58f5b5454   1         1         1       105s
```

![图片.png](https://ask.qcloudimg.com/draft/6211241/k9fjacl6yc.png)

## 3.对外访问

修改service/weave-scope-app，将其模式由ClusterIP修改为NodePort，使其可以直接通过NodeIP:Port方式访问

```bash
[root@master ~]# kubectl edit service -n weave weave-scope-app
service/weave-scope-app edited
```

![图片.png](https://ask.qcloudimg.com/draft/6211241/dc1cwvy9xx.png)

## 4.登录

登录url：http://172.27.9.131:30022/

![图片.png](https://ask.qcloudimg.com/draft/6211241/7bp62bkntk.png)

# 三、使用Weave Scope

## 1.资源查看的两种方式

以pod为例查看资源，资源有两种展现形式：

**图形式性：**

![图片.png](https://ask.qcloudimg.com/draft/6211241/w6x3kputt4.png)

图形方式还会展示pod之间的拓扑关系

![图片.png](https://ask.qcloudimg.com/draft/6211241/0ygcded9h9.png)

**表格形式：**

![图片.png](https://ask.qcloudimg.com/draft/6211241/5tqhc9v30a.png)

**Weave Scope**监控对象有进程、容器、pods、主机等，监控项有cpu、内存、平均负载等。

## 2.查看资源使用详情

点击某个pod，会展示状态、资源使用、进程等详细信息

![图片.png](https://ask.qcloudimg.com/draft/6211241/5v9270kobo.png)

## 3.pod日志查看

资源使用详情中点击'Get logs'

![图片.png](https://ask.qcloudimg.com/draft/6211241/np62v7hsnw.png)
![图片.png](https://ask.qcloudimg.com/draft/6211241/55c3bs9iuh.png)

## 4.pod描述查看

![图片.png](https://ask.qcloudimg.com/draft/6211241/on4aum37fq.png)
![图片.png](https://ask.qcloudimg.com/draft/6211241/5an5crrmix.png)

## 5.资源伸缩

![图片.png](https://ask.qcloudimg.com/draft/6211241/063uh9ipoc.png)

点击deployment类型的Controllers，可以进行deployment的伸缩和查看

## 6.容器操作

![图片.png](https://ask.qcloudimg.com/draft/6211241/io6vqihe40.png)

可以对容器进行attach、exec shell、restart、paus和stop操作

![图片.png](https://ask.qcloudimg.com/draft/6211241/448o8c22a0.png)

进入容器，执行df -h操作

## 7.展示条件选择

![图片.png](https://ask.qcloudimg.com/draft/6211241/kd07viim7h.png)

左下角可按条件展示，有容器类型（系统或者应用）、容器状态（停止或者运行）、命名空间等。

## 8.搜索功能

**按容器名搜索**

![图片.png](https://ask.qcloudimg.com/draft/6211241/x4wr9g2oao.png)

**按资源使用搜索**

![图片.png](https://ask.qcloudimg.com/draft/6211241/g7s4ng67w1.png)