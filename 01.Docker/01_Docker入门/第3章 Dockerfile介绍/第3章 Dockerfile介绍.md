# Dockerfile介绍(例子见d2文件夹)

> 阿里云加速：https://sa30pn3u.mirror.aliyuncs.com

> 在阿里云上查看的时候的用户名就是阿里云账号，密码是19921023wr


## 第一个Demo

### 代码

```Dockerfile
FROM alpine:latest
MAINTAINER lsg
CMD [ "echo","lsg say hello docker"]
```

### build自己镜像的命名

在上面的Dockerfile所在的路径执行如下的命令
`docker build -t hello_docker .`
**-t**表示构建好的自己的镜像的名称；最后的.表示把当前目录的所有文件都打包到生成的image中去

## Dockerfile语法

+ FROM       : 选取基础镜像(base image)
+ RUN        : 执行命令
+ COPY       ：添加文件(尽可以复制本地的文件或目录到镜像中)
+ ADD        : 添加文件(不仅可以复制本地的文件或目录，还可以复制远程共享或者FTP中的文件到镜像中
+ CMD        : 执行命令
+ EXPOSE     ；容器启动的时候对外暴露的端口
+ WORKDIR    : 指定路径 
+ MAINTAINER : 维护者
+ ENV        : 环境变量
+ ENVIROMENT : 容器入口
+ USER       : 指定用户
+ VOLUME     : mount point 挂载点
