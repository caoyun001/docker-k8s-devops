# 第11章 k8s的基本概念与操作

## 11.1 kubectl的基本使用
### kubectl命令自动补全功能
我们在管理k8s集群的时候，避免不了使用kubectl命令工具，但是该命令还是挺复杂的，使用中也记不住那么多的api选项，故这里介绍一下kubectl命令补全工具的安装。

1：安装bash-completion：
```shell
# yum install -y bash-completion 
# source /usr/share/bash-completion/bash_completion
```
2：应用kubectl的completion到系统环境：
```shell
# source <(kubectl completion bash)
# echo "source <(kubectl completion bash)" >> ~/.bashrc
```
3.效果演示,打入首字母就会自动显示可能的命令
```shell
[root@k8s-master ~]# kubectl get p
persistentvolumeclaims             poddisruptionbudgets.policy        podsecuritypolicies.policy         priorityclasses.scheduling.k8s.io
persistentvolumes                  pods                               podtemplates
```

### kubectl的配置
> 在`~/.kube`目录下，只有在master节点上有这个文件，所以只有master上才能用Kubectl。其他安装了kubectl的节点想访问可以把本文件的contexts节点内容拷贝到同名文件中

```shell
[root@k8s-master .kube]# pwd
/root/.kube
[root@k8s-master .kube]# tree -L 1
.
├── cache
├── config
└── http-cache

2 directories, 1 file
[root@k8s-master .kube]# cat config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJd01ESXlNakV4TlRnd00xb1hEVE13TURJeE9URXhOVGd3TTFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBSmJmCm1rN0pEZ1ZVUXhHZlVZMUwyWDZ5SFVFTGNGRndOY2xvQWJSai9HLzVUclBTa0k4YUNOT1ZYODNCWUZpd3RvcFMKSWU4ZTNYdUVsZ3Y0OVFDc0ZPQWx4WW5KbDhJSk9ybTdNV2dkWFRoVUNqVzFhZFVsQ0JZeVp1TlY2aUw2emc5ZApaaGdDbkJPbkJiTHZWSDBqUmJLUkExNDg3Z2dGc1JuM3FjQ2RDbUhzZERsTSsvNTVDb3poUFZRMmVvUlA4QUxmCjlIMzI5OU5sUmZvY0xjV25hY2JvcDRkTktUbGY0SVp4bDlXa3VycUlzWXdwKzVYRm90cHNpZ1EyTVNXU3ZLbloKRk41NlV6TXNBa3JvUWxJSGhMcXllVEZrUTZuQW1uOU9zTW5iV3o4ZWNqMDJUY2JOaFhlNHNBWW1wUlFOUUpXMQpsL1RvRXlzMFZpSnY1ckRlWFBVQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFGR2hVSWx3b3RveHU2OWJBbjl5N1lDZWZERWsKOEVHTE1PTmpEWklMc3JvTlJxdFZXVFZhemRzcFJ0VzY4SmRldlMxQmV6L2t3bWd4R2tsckVRSjZYaTNXN0NTZApnRlBVNHo3bm1GY1ZVdFpRbXkydnFZbyt3eHVKcnBXME5BSUVSRWdPcHhUYzEzZ0g2RGd1T282K3FxRkM4bTd5CllrK1ROSnQ2S01maml6TnNLNm10S3gvMmd4d0hiSlpaYTVUVklOOXNaRG9BVzlWcnNqUmVISnR1OUVYRE1VVEUKNTZkRGFGM3hDbTFlVUtWZEQrOStFYXlYMnR1QURialZiSG94Nmxob1d4Yit5Zm5aaGM4c0JscSs1aHRDMEpzLwp5MWNlQzkyUWQybkpsbXdabk9yUk5HVzdkTkVTdVcyTDUzajBPTWliUitBOHhxWGtOeFpETVlzQ2tYQT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://192.168.100.120:6443 # 集群的server地址，
  name: kubernetes # 集群名
contexts: # 集群内容(复数表示多个集群)
- context:
    cluster: kubernetes # 集群名
    user: kubernetes-admin # 集群的用户名
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM4akNDQWRxZ0F3SUJBZ0lJWVBKNlF2RG9sbzR3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TURBeU1qSXhNVFU0TUROYUZ3MHlNVEF5TWpFeE1UVTRNRFZhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXZnRXFKWnEyZ3UvUm5TdHkKWmUzaEdtdVVLeVRjbmRzczhMQ3hFZnFKamVicUkvT0gyM0g5b3ZBclhjYkYrYStScWdSWTV5ekpYYVBXN3RzRgorU0VmRC9QRW9XcW9mQmZ4TVZVaWtXN3M2WU5yTnZuT0FHdEZtUm5Vd2ZUSDBuNWlISWZGNlVNdjByZFRLOGpQCkM4UDZYN0lZQmthS3hOWjl2dDFWajd5M1BKOFdxWllpU3JWYi85Y2RWUmlKTXZFUUJLZXpwOVNTS0d0bDNWYlUKSDlGNEpOdTRCQWgvMlRKU1BwNzI5ZC8yYUFxNzVnOWRBRmpwTFNYN2Q1NXZNeFNkZTQxUjN1OW5TaTM5ZmxJWQpOdkJPZk1VTm5RZ2hvZDRkWGY1bi8zZElmTithcEZ6TTlWQXBnS1o3QVYwQmNBQUJBTjNQbkpjZlNZSjRtQU9FCk54elVCUUlEQVFBQm95Y3dKVEFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFDVGhJbm51bXY5MC8wNnY4R2JFMzNNSGdWZk95V2NnUU5tYgpoR1pxbjV1a1JBT1RCK3VmdTlWbDlTTEwxeUhiV3JHU2RETWVwam9HbjJmaGI2VXY3ck9LMW80YkNoSVZoYVBKCk9uN0RRU2R5UzJCazdyaUdxWEJKdEFEdXZBK0FxTk9OcksvMXluNWNKS05Db1ROZ1lhRzdrUSsvbDZZa3Zoak8KSVNhTXdVUkN6eEVBUW52dmg1eGExeFlieWZZNHRRVTgvSkZnMGRnZnhQd2I0ak1HMU9JS3gxK3FoOW9qd0g0UApJSExoYUJFT1h6bm9Qbm1VNkNFcjVSeUlXTGZKSlRnMzNZd3BZenFsdkdPRXpOQ0NKN3Rra29BRzlhUTJWS1JICnkzOEZBc3ptWTlneWtpUlo3dDlCTkJNWnBTbFZqK1IxdlBhT1hzRjlFMWxHQ05GMkpzQT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcFFJQkFBS0NBUUVBdmdFcUpacTJndS9SblN0eVplM2hHbXVVS3lUY25kc3M4TEN4RWZxSmplYnFJL09ICjIzSDlvdkFyWGNiRithK1JxZ1JZNXl6SlhhUFc3dHNGK1NFZkQvUEVvV3FvZkJmeE1WVWlrVzdzNllOck52bk8KQUd0Rm1SblV3ZlRIMG41aUhJZkY2VU12MHJkVEs4alBDOFA2WDdJWUJrYUt4Tlo5dnQxVmo3eTNQSjhXcVpZaQpTclZiLzljZFZSaUpNdkVRQktlenA5U1NLR3RsM1ZiVUg5RjRKTnU0QkFoLzJUSlNQcDcyOWQvMmFBcTc1ZzlkCkFGanBMU1g3ZDU1dk14U2RlNDFSM3U5blNpMzlmbElZTnZCT2ZNVU5uUWdob2Q0ZFhmNW4vM2RJZk4rYXBGek0KOVZBcGdLWjdBVjBCY0FBQkFOM1BuSmNmU1lKNG1BT0VOeHpVQlFJREFRQUJBb0lCQVFDTHROZUVwdW1rQlNvZgpZcDdQQzhZRVl5MmpPNHRzRm9oSXdlS3cwWUxxNytzaFhDTjgyNmdmY25Dd2wwTmlnQkdlN1d0aEw3RXdSUlA0CnROc0RmN01UUzY0ODhldklzdUlKNEF0MjNCVWU3aDZiWWJweTNHMWtVWFg2MXoxR0xOOS9FdVlXeWV3VUIvQUQKdGJkbmMwWlpydDJ6WDVNUmdKVWREaW1uY3A5WTFteC9MaVBQZ2NLUHNZYUNQMDFtUXdLak02TGFiMjJSNFNaRQpvTnllOHlmUXJ1ejExdzdrR0dRdHBIWXBVNHZtY21xMXBkRUIva29URFhWUFl4WCtaOEpLK0RFUnlUQWVlalIvCnNIN0U3STlKS21BZFZ1bFlzbHRMRHp0c3dkdXBrV1diak9YTFZIVy9PSjdIWW50OE5vMnh3Qjg3alAwaGFkb0IKM2JWV2RVOEJBb0dCQU5QY2VPMFZKYkVzVWRpeUFHOExHdlJRWXZPenV4cFUrVUF2d082YS91Wk1nbFZTeUtiOQpMUjJyWnloUnZMeUYrQTVjdHRaM0lqTzE2Um80d0NReW0yOEpDdGFTUm1FU0lYVXg4M3dhR3l1dStOZlZyakY5ClRFSm9oQk94SEQwN1lVTGR1RFoxbDRjSGRWN09HZDRzNENxTHZiN2hPbWRvRmttRzRONHdlNVIxQW9HQkFPV1cKK2QvUlMzeG9ocDNOd1RaZUVIK3NsYzdjTGxYczAwZld1dmlxaXV2QlVodjN6TFhOSUxrSmsrS0xBc3E4QmVFUgpVb3BHNnNnb290dHdsMnFpcFJTWHVnZDUwM05jZXdSampGTzB1MXZFS1o1ay9XRXNtcGJTMDZiTWpaM3l4d3M2CllRRml2dEFPZTRSMEJwK2FmblJOT3FwTzRSVGhKdGtNU3JXUEVBOVJBb0dCQUlIaThoUlAyYnJrZEExSkcvRDQKT3Y4NzVWNkpleFVxc1dFRHBlSGpEcEU4cU04TW9NMlgvRGZyWktRWWNJQ1lGYnNnWmt2WDRCVVoycDVqMnBDVwpvaXFSdlo1Tk1XN0R3ZFZxMlY3bFZuRVNwYWNWYnVVU2IxVnJaRVg2V0ZqRjlkd2J1SnRTdnFKZkZUc1pXa3lXCjhKdkU3b0IrN3VLRXN0MURIc3U1cDVvZEFvR0FRZFFyS3pDUWkwaFJLTmdCQ1R5cFVHSkV4ZjQ5enVkTG9US0IKZzZFcW1mUmhQYUdzY1lneVZMdlpTa0IvZVcrMTQ5V2FyQWt2Y2xxc2IyejJEVjQ3SlE5b0NKSzJ2VUlNQjdNZgpYalRZNzdQc0Z2MXY1VGZyejBqOTVMcUw5SGpTOTNZeXNEb0c2aExzK1lwbkI4WTljYzFlLzh3RUgzOTdLd3FxCk5TcWkrVEVDZ1lFQXM5Q05keDFLODZYc0dWNU5TdXR3dVpDVzhHZzFIZzFVczB0L3lqcnNBYjlrenoxWENIZFUKUlgvOUJsY0RyOTJYRzA4RU1GSjd6Z0s2N3ZxTGxkL2JUVkFnaUVXSVJwS1Y5ZUthTWZyVXZ0QTlwanRzU2hWegpVWHR0WDBORFE1T29iVjlDQTZ2WmZ4cGtjVWhtbE92RzRJQ0pmZEgxbEVqWWY1MzlRWEl6YVBNPQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=
```

## 11.2 k8s的节点(node)、标签(label)、角色(role)
### 节点node操作
```shell
[root@k8s-master .kube]# kubectl get n // 补全
namespaces                         networkpolicies.networking.k8s.io  nodes
[root@k8s-master .kube]# kubectl get nodes // 查看所有节点
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   14h   v1.17.3
k8s-node01   Ready    <none>   13h   v1.17.3
k8s-node02   Ready    <none>   13h   v1.17.3
[root@k8s-master .kube]# kubectl get nodes k8s-master // 只看master节点的详细信息
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   14h   v1.17.3
[root@k8s-master .kube]# kubectl describe nodes k8s-master // 查看节点的详细信息
[root@k8s-master .kube]# kubectl get nodes -o wide // 显示节点的更多信息
NAME         STATUS   ROLES    AGE   VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION          CONTAINER-RUNTIME
k8s-master   Ready    master   14h   v1.17.3   192.168.100.120   <none>        CentOS Linux 7 (Core)   3.10.0-693.el7.x86_64   docker://1.13.1
k8s-node01   Ready    <none>   13h   v1.17.3   192.168.100.121   <none>        CentOS Linux 7 (Core)   3.10.0-693.el7.x86_64   docker://1.13.1
k8s-node02   Ready    <none>   13h   v1.17.3   192.168.100.122   <none>        CentOS Linux 7 (Core)   3.10.0-693.el7.x86_64   docker://1.13.1
[root@k8s-master .kube]# kubectl get nodes -o yaml // yaml格式显示节点信息
......
[root@k8s-master .kube]# kubectl get nodes -o json // json格式显示节点信息
......
```
### 标签label操作
```shell
[root@k8s-master ~]# kubectl get nodes --show-labels // 显示所有节点的标签
NAME         STATUS   ROLES    AGE   VERSION   LABELS
k8s-master   Ready    master   14h   v1.17.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s-master,kubernetes.io/os=linux,node-role.kubernetes.io/master=
k8s-node01   Ready    <none>   13h   v1.17.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s-node01,kubernetes.io/os=linux
k8s-node02   Ready    <none>   13h   v1.17.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s-node02,kubernetes.io/os=linux
[root@k8s-master ~]# kubectl label nodes k8s-master env=test // 给master节点设置标签
node/k8s-master labeled
[root@k8s-master ~]# kubectl get nodes --show-labels
NAME         STATUS   ROLES    AGE   VERSION   LABELS
k8s-master   Ready    master   14h   v1.17.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,env=test,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s-master,kubernetes.io/os=linux,node-role.kubernetes.io/master=
k8s-node01   Ready    <none>   13h   v1.17.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s-node01,kubernetes.io/os=linux
k8s-node02   Ready    <none>   13h   v1.17.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s-node02,kubernetes.io/os=linux
[root@k8s-master ~]# kubectl label nodes k8s-master env- // 删除master的env标签
node/k8s-master labeled
[root@k8s-master ~]# kubectl get nodes --show-labels
NAME         STATUS   ROLES    AGE   VERSION   LABELS
k8s-master   Ready    master   14h   v1.17.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s-master,kubernetes.io/os=linux,node-role.kubernetes.io/master=
k8s-node01   Ready    <none>   13h   v1.17.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s-node01,kubernetes.io/os=linux
k8s-node02   Ready    <none>   13h   v1.17.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s-node02,kubernetes.io/os=linux
```
### 角色操作
```shell
[root@k8s-master ~]# kubectl get nodes // 显示所有的节点，可以看到两个非master节点并没有角色(ROLES)
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   14h   v1.17.3
k8s-node01   Ready    <none>   13h   v1.17.3
k8s-node02   Ready    <none>   13h   v1.17.3
[root@k8s-master ~]# kubectl label nodes k8s-node01 node-role.kubernetes.io/worker= // node01设置为wroker角色
node/k8s-node01 labeled
[root@k8s-master ~]# kubectl get nodes // 查看角色可以看到设置成功了
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   14h   v1.17.3
k8s-node01   Ready    worker   13h   v1.17.3
k8s-node02   Ready    <none>   13h   v1.17.3
[root@k8s-master ~]# kubectl label nodes k8s-node02 node-role.kubernetes.io/worker= // node01设置为wroker角色
node/k8s-node02 labeled
[root@k8s-master ~]# kubectl get nodes // 查看角色可以看到设置成功了
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   14h   v1.17.3
k8s-node01   Ready    worker   13h   v1.17.3
k8s-node02   Ready    worker   13h   v1.17.3
```