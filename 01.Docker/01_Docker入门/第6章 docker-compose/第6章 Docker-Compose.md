# 第6章 Docker-Compose

## Linux上安装docker-compose

+ 下载可执行文件到本地：`curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose`
+ 赋予文件执行权限，`a+x`表示任何人都可以执行：`chmod a+x /usr/local/bin/docker-compose`

## 以博客为例实战docker-compose

 > 见当前目录下的ghost文件夹

## docker-compose 常用命令

+ build : 本地创建镜像
+ command : 覆盖缺省命令
+ depends_on : 连接容器
+ ports : 暴露接口
+ volumes: 卷(持久化)
+ image : pull镜像
+ up : 启动服务
+ down : 停止服务
+ rm : 删除服务器中的各个容器
+ logs : 观察各个容器的日志
+ ps : 列出服务相关的容器