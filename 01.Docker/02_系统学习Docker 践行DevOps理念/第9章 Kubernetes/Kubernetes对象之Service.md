> 学习本节内容之前，希望你已经对Pod, ReplicaSet和Label有了基本的了解，具体请参考以下文章：
>
> - [Kubernetes对象之Pod](https://www.jianshu.com/p/ce71385e0370)
> - [Kubernetes对象之ReplicaSet](https://www.jianshu.com/p/fd8d8d51741e)
> - [Kubernetes基本概念之Label](https://www.jianshu.com/p/cd6b4b4caaab)

通过以前的学习，我们已经能够通过ReplicaSet来创建一组Pod来提供具有高可用性的服务。虽然每个Pod都会分配一个单独的Pod IP，然而却存在如下两问题：

- Pod IP仅仅是集群内可见的虚拟IP，外部无法访问。
- Pod IP会随着Pod的销毁而消失，当ReplicaSet对Pod进行动态伸缩时，Pod IP可能随时随地都会变化，这样对于我们访问这个服务带来了难度。

因此，Kubernetes中的Service对象就是解决以上问题的核心关键。

# 1. Service的创建

**Service可以看作是一组提供相同服务的Pod对外的访问接口**。借助Service，应用可以方便地实现服务发现和负载均衡。

Service同其他Kubernetes对象一样，也是通过yaml或json文件进行定义。此外，它和其他Controller对象一样，通过Label Selector来确定一个Service将要使用哪些Pod。一个简单的Service定义如下：



```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    run: nginx
  name: nginx-service
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 81
  selector:
    app: nginx
  type: ClusterIP
```

下面简单分析一下上面的Service描述文件：

- 通过`spec.selector`字段确定这个Service将要使用哪些Label。在本例中，这个名为nginx的Service，将会管理所有具有`app: nginx`Label的Pod。
- `spec.ports.port: 80`表明此Service将会监听80端口，并将所有监听到的请求转发给其管理的Pod。`spec.ports.targetPort: 81`表明此Service监听到的80端口的请求都会被转发给其管理的Pod的81端口，此字段可以省略，省略后其值会被设置为`spec.ports.port`的值。
- `type: ClusterIP`表面此Service的type，会在下文中讲到。

# 2. Service的类型

在Serive定义时，我们需要指定`spec.type`字段，这个字段拥有四个选项：

- **ClusterIP**。默认值。给这个Service分配一个Cluster IP，它是Kubernetes系统自动分配的虚拟IP，因此只能在集群内部访问。
- **NodePort**。将Service通过指定的Node上的端口暴露给外部。通过此方法，访问任意一个`NodeIP:nodePort`都将路由到ClusterIP，从而成功获得该服务。
- **LoadBalancer**。在 NodePort 的基础上，借助 cloud provider 创建一个外部的负载均衡器，并将请求转发到 <NodeIP>:NodePort。此模式只能在云服务器（AWS等）上使用。
- **ExternalName**。将服务通过 DNS CNAME 记录方式转发到指定的域名（通过 spec.externlName 设定）。需要 kube-dns 版本在 1.7 以上。

## 2.1 NodePort类型

在定义Service时指定spec.type=NodePort，并指定spec.ports.nodePort的值，Kubernetes就会在集群中的每一个Node上打开你定义的这个端口，这样，就能够从外部通过任意一个`NodeIP:nodePort`访问到这个Service了。
 下面是一个简单的例子：



```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  labels:
    run: nginx
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    nodePort: 30001
  type: NodePort
```

假如有3个app: nginx Pod运行在3个不同的Node中，那么此时客户端访问任意一个Node的30001端口都能访问到这个nginx服务。

## 2.2 LoadBalancer类型

如果云服务商支持外接负载均衡器，则可以通过spec.type=LoadBalancer来定义Service，一个简单的例子如下：



```yaml
kind: Service
apiVersion: v1
metadata:
  name: my-service
spec:
  selector:
    app: MyApp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 9376
  clusterIP: 10.0.171.239
  loadBalancerIP: 78.11.24.19
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
    - ip: 146.148.47.155
```

### 参考文章

- [https://kubernetes.io/docs/concepts/services-networking/service/](https://link.jianshu.com?t=https%3A%2F%2Fkubernetes.io%2Fdocs%2Fconcepts%2Fservices-networking%2Fservice%2F)
- [https://kubernetes.feisky.xyz/zh/concepts/service.html](https://link.jianshu.com?t=https%3A%2F%2Fkubernetes.feisky.xyz%2Fzh%2Fconcepts%2Fservice.html)



作者：伊凡的一天
链接：https://www.jianshu.com/p/c24fd0d132f6
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。