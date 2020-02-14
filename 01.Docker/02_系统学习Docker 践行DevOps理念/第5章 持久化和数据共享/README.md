# 持久化和数据共享

## Docker 特久化数据的方案

+ 基于本地文件系统的Volume
  > 可以在执行 Dockercreate 或 Docker run 时,通过- v 参数将主机的目录作为容器的数据卷。这部分功能便是基于本地文件系统的 volume 管理
+ 基于plugin的Volume的存储方案
  > 比如 NAS , aws

## Volume的类型

+ 1.受管理的data Volume,由docker后台自动创建
+ 2.绑定挂载的Volume，具体挂载位置可以由用户指定

## Volume操作

+ 查看volume:`docker volume ls`
+ 删除volume:`docker volume rm volume号`
+ 删除所有的volume:`docker volume prune`
+ 查看volume的详细信息(尤其是挂载信息**Mountpoint**)：`docker volume inspect`

## 持久化方式1 ： -v 挂载地址来声明挂载到的本地路径

+ 1.创建MySQL的镜像：`docker run -d -v mysql:/var/lib/mysql --name mysql1 -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql`
+ 2.强制删除正在执行地mysql1:`docker rm -f mysql1`
+ 3.创建mysql2仍然可以直接使用mysql1的volume，证明了volume的持久性,可以自己在mysql1的时候添加个数据库试试，看看在mysql2中是否仍然存在：`docker run -d -v mysql:/var/lib/mysql --name mysql2 -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql`

## 持久化方式2(推荐)： Bind Mounting

+ 在docker run的时候通过-v参数来指定`docker run -d -v $PWD:/usr/share/nginx/html -p 8888:80 --name web waterknife/docker-nginx`

> 名为`Page Auto Refresh`的Chrome插件很不错~！

## flask-skeleton例子对应的命令

+ `docker build -t waterknife/flask-skeleton .` : 构建镜像
+ `docker run -d -p 8080:5000 -v $PWD:/skeleton --name flask waterknife/flask-skeleton`:-p把服务端口映射到本地本地,-v把本地地址和容器地址弄好映射(关键)

## 5-5 Dcoker + Mount 作为开发的利器

通过-v把本地的代码映射到容器，当本地代码修改时，容器内的代码实时变化，可以实时看到效果，这样就可以不需要每个人都部署一套开发环境了，大家只需要都采用一个Docker镜像即可。

自动刷新页面的Chrome插件可以用Page Auto Refresh.当开发前端(比如Vue和React等自带热加载)的项目时，不需要此插件。Django也是是
