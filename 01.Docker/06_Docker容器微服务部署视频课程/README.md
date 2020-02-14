# [Docker容器微服务部署视频课程](https://edu.51cto.com/course/15694.html)

> 非常重要，对接下来公司内的微服务改造比较重要！！！

## 第1章Docker容器基本应用

+ 1-1.Docker课程大纲
+ 1-2.Docker简介
+ 1-3.Docker容器vs虚拟化技术
+ 1-4.在Ubuntu安装Docker
+ 1-5.Docker启动与停止
+ 1-6.配置ustc加速源
+ 1-7.Docker镜像命令
+ 1-8.Docker运行容器-交互式容器
+ 1-9.Docker运行容器-守护式容器
+ 1-10.Docker容器停止与运行
+ 1-11.Docker文件拷贝
  + 从宿主机拷贝到容器内部：`docker cp 宿主机目录 容器名称:容器目录`
    + 例如本地文件覆盖nginx容器中的文件：`docker cp index.html mynginx:/usr/share/nginx/html/index.html`
  + 从容器内部拷贝到宿主机：`docker cp 容器名称:容器目录 宿主机目录`
    + 例如nginx容器中的文件覆盖本地文件：`docker cp mynginx:/usr/share/nginx/html/index.html index.html`
+ 1-12.Docker目录挂载
+ 1-13.Docker安装MySQL软件
+ 1-14.Docker安装Redis软件
+ 1-15.Docker安装Tomcat软件

## 第2章微服务部署

+ 2-1.文章微服务-搭建文章微服务架构10:46
+ 2-2.文章微服务-开发文章CRUD业务逻辑18:57
+ 2-3.搭建注册中心Eureka微服务[免费试看]06:33
+ 2-4.搭建Zuul微服务网关04:33
+ 2-5.文章微服务和Zuul注册到Eureka08:28
+ 2-6.Dockerfile常用命令说明04:31
+ 2-7.使用Docker构建jdk1.8镜像10:17
+ 2-8.使用Dockerfile构建Eureka镜像11:58
+ 2-9.使用Dockerfile构建文章和zuul镜像08:04
+ 2-10.使用DockerMaven插件自动化部署微服务12:31
+ 2-11.修复无法启动文章微服务的Bug02:02
+ 2-12.Docker下安装Rancher并连接Docker06:04
+ 2-13.使用Rancher部署和管理微服务04:16
+ 2-14.Rancher进行微服务扩容和缩容11:53
+ 2-15.Docker私服registry管理镜像12:16
+ 2-16.Docker课程总结开始学习
