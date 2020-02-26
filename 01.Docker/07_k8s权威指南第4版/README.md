# [k8s权威指南第4版](https://item.jd.com/12601558.html)
![k8s权威指南](k8s权威指南.png)

## 第1章 Kubernetes入门 1

+ 1.1 Kubernetes是什么 2
+ 1.2 为什么要用Kubernetes 5
+ 1.3 从一个简单的例子开始 6
  + 1.3.1 环境准备 7
  + 1.3.2 启动MySQL服务 7
  + 1.3.3 启动Tomcat应用 10
  + 1.3.4 通过浏览器访问网页 12
+ 1.4 Kubernetes的基本概念和术语 13
  + 1.4.1 Master 16
  + 1.4.2 Node 16
  + 1.4.3 Pod 19
  + 1.4.4 Label 24
  + 1.4.5 Replication Controller 28
  + 1.4.6 Deployment 31
  + 1.4.7 Horizontal Pod Autoscaler 34
1.4.8 StatefulSet 36
1.4.9 Service 37
1.4.10 Job 45
1.4.11 Volume 45
1.4.12 Persistent Volume 49
1.4.13 Namespace 51
1.4.14 Annotation 52
1.4.15 ConfigMap 53
1.4.16 小结 54

第2章 Kubernetes安装配置指南 55

2.1 系统要求 56

2.2 使用kubeadm工具快速安装Kubernetes集群 57

2.2.1 安装kubeadm和相关工具 57

2.2.2 kubeadm config 58

2.2.3 下载Kubernetes的相关镜像 59

2.2.4 运行kubeadm init命令安装Master 59

2.2.5 安装Node，加入集群 61

2.2.6 安装网络插件 62

2.2.7 验证Kubernetes集群是否安装完成 63

2.3 以二进制文件方式安装Kubernetes集群 64

2.3.1 Master上的etcd、kube-apiserver、kube-controller-manager、kube-scheduler服务 66

2.3.2 Node上的kubelet、kube-proxy服务 71

2.4 Kubernetes集群的安全设置 73

2.4.1 基于CA签名的双向数字证书认证方式 73

2.4.2 基于HTTP Base或Token的简单认证方式 78

2.5 Kubernetes集群的网络配置 80

2.6 内网中的Kubernetes相关配置 80

2.6.1 Docker Private Registry（私有Docker镜像库） 80

2.6.2 kubelet配置 81

2.7 Kubernetes的版本升级 81

2.7.1 二进制升级 81

2.7.2 使用kubeadm进行集群升级 82

2.8 Kubernetes核心服务配置详解 84

2.8.1 公共配置参数 84

2.8.2 kube-apiserver启动参数 85

2.8.3 kube-controller-manager启动参数 97

2.8.4 kube-scheduler启动参数 107

2.8.5 kubelet启动参数 113

2.8.6 kube-proxy启动参数 128

2.9 CRI（容器运行时接口）详解 132

2.9.1 CRI概述 132

2.9.2 CRI的主要组件 133

2.9.3 Pod和容器的生命周期管理 133

2.9.4 面向容器级别的设计思路 135

2.9.5 尝试使用新的Docker-CRI来创建容器 136

2.9.6 CRI的进展 137

2.10 kubectl命令行工具用法详解 137

2.10.1 kubectl用法概述 137

2.10.2 kubectl子命令详解 139

2.10.3 kubectl参数列表 142

2.10.4 kubectl输出格式 143

2.10.5 kubectl操作示例 145

第3章 深入掌握Pod 149

3.1 Pod定义详解 150

3.2 Pod的基本用法 156

3.3 静态Pod 161

3.4 Pod容器共享Volume 162

3.5 Pod的配置管理 165

3.5.1 ConfigMap概述 165

3.5.2 创建ConfigMap资源对象 165

3.5.3 在Pod中使用ConfigMap 173

3.5.4 使用ConfigMap的限制条件 179

3.6 在容器内获取Pod信息（Downward API） 180

3.6.1 环境变量方式：将Pod信息注入为环境变量 180

3.6.2 环境变量方式：将容器资源信息注入为环境变量 182

3.6.3 Volume挂载方式 184

3.7 Pod生命周期和重启策略 186

3.8 Pod健康检查和服务可用性检查 187

3.9 玩转Pod调度 190

3.9.1 Deployment或RC：全自动调度 193

3.9.2 NodeSelector：定向调度 194

3.9.3 NodeAffinity：Node亲和性调度 197

3.9.4 PodAffinity：Pod亲和与互斥调度策略 198

3.9.5 Taints和Tolerations（污点和容忍） 202

3.9.6 Pod Priority Preemption：Pod优先级调度 206

3.9.7 DaemonSet：在每个Node上都调度一个Pod 209

3.9.8 Job：批处理调度 211

3.9.9 Cronjob：定时任务 215

3.9.10 自定义调度器 219

3.10 Init Container（初始化容器） 220

3.11 Pod的升级和回滚 224

3.11.1 Deployment的升级 225

3.11.2 Deployment的回滚 231

3.11.3 暂停和恢复Deployment的部署操作，以完成复杂的修改 234

3.11.4 使用kubectl rolling-update命令完成RC的滚动升级 236

3.11.5 其他管理对象的更新策略 239

3.12 Pod的扩缩容 240

3.12.1 手动扩缩容机制 240

3.12.2 自动扩缩容机制 241

3.13 使用StatefulSet搭建MongoDB集群 264

第4章 深入掌握Service 276

4.1 Service定义详解 277

4.2 Service的基本用法 279

4.2.1 多端口Service 282

4.2.2 外部服务Service 283

4.3 Headless Service 284

4.3.1 自定义SeedProvider 285

4.3.2 通过Service动态查找Pod 286

4.3.3 Cassandra集群中新节点的自动添加 289

4.4 从集群外部访问Pod或Service 291

4.4.1 将容器应用的端口号映射到物理机 291

4.4.2 将Service的端口号映射到物理机 292

4.5 DNS服务搭建和配置指南 294

4.5.1 在创建DNS服务之前修改每个Node上kubelet的启动参数 296

4.5.2 创建CoreDNS应用 297

4.5.3 服务名的DNS解析 301

4.5.4 CoreDNS的配置说明 302

4.5.5 Pod级别的DNS配置说明 304

4.6 Ingress：HTTP 7层路由机制 306

第5章 核心组件运行机制 326

5.1 Kubernetes API Server原理解析 327

5.1.1 Kubernetes API Server概述 327

5.1.2 API Server架构解析 330

5.1.3 独特的Kubernetes Proxy API接口 334

5.1.4 集群功能模块之间的通信 336

5.2 Controller Manager原理解析 337

5.2.1 Replication Controller 338

5.2.2 Node Controller 339

5.2.3 ResourceQuota Controller 341

5.2.4 Namespace Controller 343

5.2.5 Service Controller与Endpoints Controller 343

5.3 Scheduler原理解析 344

5.4 kubelet运行机制解析 348

5.4.1 节点管理 349

5.4.2 Pod管理 349

5.4.3 容器健康检查 351

5.4.4 cAdvisor资源监控 352

5.5 kube-proxy运行机制解析 354

第6章 深入分析集群安全机制 358

6.1 API Server认证管理 359

6.2 API Server授权管理 361

6.2.1 ABAC授权模式详解 362

6.2.2 Webhook授权模式详解 365

6.2.3 RBAC授权模式详解 368

6.3 Admission Control 384

6.4 Service Account 388

6.5 Secret私密凭据 393

6.6 Pod的安全策略配置 396

第7章 网络原理 410

7.1 Kubernetes网络模型 411

7.2 Docker网络基础 413

7.2.1 网络命名空间 413

7.2.2 Veth设备对 416

7.2.3 网桥 419

7.2.4 iptables和Netfilter 421

7.2.5 路由 424

7.3 Docker的网络实现 426

7.4 Kubernetes的网络实现 435

7.4.1 容器到容器的通信 435

7.4.2 Pod之间的通信 436

7.5 Pod和Service网络实战 439

7.6 CNI网络模型 454

7.6.1 CNM模型 454

7.6.2 CNI模型 455

7.6.3 在Kubernetes中使用网络插件 467

7.7 Kubernetes网络策略 467

7.7.1 网络策略配置说明 468

7.7.2 在Namespace级别设置默认的网络策略 470

7.7.3 NetworkPolicy的发展 472

7.8 开源的网络组件 472

7.8.1 Flannel 472

7.8.2 Open vSwitch 477

7.8.3 直接路由 483

7.8.4 Calico容器网络和网络策略实战 486

第8章 共享存储原理 508

8.1 共享存储机制概述 509

8.2 PV详解 510

8.2.1 PV的关键配置参数 511

8.2.2 PV生命周期的各个阶段 515

8.3 PVC详解 516

8.4 PV和PVC的生命周期 518

8.4.1 资源供应 518

8.4.2 资源绑定 519

8.4.3 资源使用 519

8.4.4 资源释放 519

8.4.5 资源回收 519

8.5 StorageClass详解 521

8.5.1 StorageClass的关键配置参数 521

8.5.2 设置默认的StorageClass 524

8.6 动态存储管理实战：GlusterFS 524

8.7 CSI存储机制详解 537

8.7.1 CSI的设计背景 538

8.7.2 CSI存储插件的关键组件和部署架构 539

8.7.3 CSI存储插件的使用示例 540

8.7.4 CSI的发展 556

第9章 Kubernetes开发指南 560

9.1 REST简述 561

9.2 Kubernetes API详解 563

9.3 使用Java程序访问Kubernetes API 577

9.3.1 Jersey 577

9.3.2 Fabric8 590

9.3.3 使用说明 591

9.3.4 其他客户端库 615

9.4 Kubernetes API的扩展 616

9.4.1 使用CRD扩展API资源 617

9.4.2 使用API聚合机制扩展API资源 626

第10章 Kubernetes集群管理 635

10.1 Node的管理 636

10.1.1 Node的隔离与恢复 636

10.1.2 Node的扩容 637

10.2 更新资源对象的Label 638

10.3 Namespace：集群环境共享与隔离 639

10.3.1 创建Namespace 639

10.3.2 定义Context（运行环境） 640

10.3.3 设置工作组在特定Context环境下工作 641

10.4 Kubernetes资源管理 643

10.4.1 计算资源管理 645

10.4.2 资源配置范围管理（LimitRange） 655

10.4.3 资源服务质量管理（Resource QoS） 662

10.4.4 资源配额管理（Resource Quotas） 670

10.4.5 ResourceQuota和LimitRange实践 676

10.4.6 资源管理总结 685

10.5 资源紧缺时的Pod驱逐机制 686

10.5.1 驱逐策略 686

10.5.2 驱逐信号 686

10.5.3 驱逐阈值 688

10.5.4 驱逐监控频率 689

10.5.5 节点的状况 689

10.5.6 节点状况的抖动 690

10.5.7 回收Node级别的资源 690

10.5.8 驱逐用户的Pod 691

10.5.9 资源最少回收量 692

10.5.10 节点资源紧缺情况下的系统行为 692

10.5.11 可调度的资源和驱逐策略实践 694

10.5.12 现阶段的问题 694

10.6 Pod Disruption Budget（主动驱逐保护） 695

10.7 Kubernetes集群的高可用部署方案 697

10.7.1 手工方式的高可用部署方案 698

10.7.2 使用kubeadm的高可用部署方案 709

10.8 Kubernetes集群监控 717

10.8.1 通过Metrics Server监控Pod和Node的CPU和内存资源使用数据717

10.8.2 Prometheus+Grafana集群性能监控平台搭建 720

10.9 集群统一日志管理 732

10.9.1 系统部署架构 733

10.9.2 创建Elasticsearch RC和Service 733

10.9.3 在每个Node上启动Fluentd 736

10.9.4 运行Kibana 738

10.10 Kubernetes的审计机制 742

10.11 使用Web UI（Dashboard）管理集群 746

10.12 Helm：Kubernetes应用包管理工具 750

第11章 Trouble Shooting指导 763

11.1 查看系统Event 764

11.2 查看容器日志 766

11.3 查看Kubernetes服务日志 767

11.4 常见问题 769

11.5 寻求帮助 773

第12章 Kubernetes开发中的新功能 777

12.1 对Windows容器的支持 778

12.1.1 Windows Node部署 778

12.1.2 Windows容器支持的Kubernetes特性和发展趋势 790

12.2 对GPU的支持 791

12.2.1 环境准备 792

12.2.2 在容器中使用GPU资源 795

12.2.3 发展趋势 797

12.3 Pod的垂直扩缩容797

12.3.1 前提条件798

12.3.2 安装Vertical Pod Autoscaler 798

12.3.3 为Pod设置垂直扩缩容 798

12.3.4 注意事项 800

12.4 Kubernetes的演进路线和开发模式 801