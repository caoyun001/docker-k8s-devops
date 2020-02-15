# Docker环境搭建

> 本文是先在Windows或者Mac上用VirtualBox+Vagrant搭建虚拟机，然后在虚拟机里安装配置Docker.

如果自己在公司里有虚拟机了，直接安装Docker即可

## 1.下载需要的VirtualBox、Vagrant镜像Vagrant镜像

> https://pan.baidu.com/disk/home?#/all?vmode=list&path=%2F2.软件%2F1.代码开发%2FVagrant

百度云分享链接: https://pan.baidu.com/s/1w6EH4OzCFc2CumiTgg1rlA 提取码: fntd 

## 2.依次安装VirtualBox、Vagrant
+ 1.安装VirtualBox：双击VirtualBox-6.0.14-133895-Win.exe，一步一步安装即可
+ 2.安装Vagrant：双击vagrant_2.2.6_x86_64.msi，一步一步安装即可
+ 3.添加镜像，以centos为例：cd到vagrant-centos-7.box所在路径，执行`vagrant box add centos/7 ./vagrant-centos-7.box`即可

## 3.Vagrant操作Centos镜像的相关命令(Ubuntu、Debian也是类似的)
>  先创建centos需要的文件夹：`mkdir centos & cd centos`下面是相关命令
+ vagrant init centos/7 获取centos7的Vagrantfile下来
+ vagrant up  根据Vagrantfile中指定的box去获取，然后在visualbox中启动起来
+ vagrant ssh 通过ssh进入刚创建的虚拟机中，然后执行centos中的命令即可
+ exist 退出虚拟机
+ vagrant status 看虚拟机的状态
+ vagrant halt 停掉目前运行的虚机
+ vagrant destroy 删掉虚机，在visualbox中就没有了

Vagrantfile中指定的内容不同，下不同的虚拟机类型，一个中也可以创建多台
