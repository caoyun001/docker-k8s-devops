# Docker环境搭建

> 本文是先在Windows或者Mac上用VirtualBox+Vagrant搭建虚拟机，然后在虚拟机里安装配置Docker.

如果自己在公司里有虚拟机了，直接安装Docker即可

## 1.下载需要的VirtualBox、Vagrant镜像Vagrant镜像

> [2.软件>1.代码开发>Vagrant](https://pan.baidu.com/disk/home?#/all?vmode=list&path=%2F2.软件%2F1.代码开发%2FVagrant),百度云分享链接: https://pan.baidu.com/s/1w6EH4OzCFc2CumiTgg1rlA 提取码: fntd 

## 2.依次安装VirtualBox、Vagrant
+ 1.安装VirtualBox：双击VirtualBox-6.0.14-133895-Win.exe，一步一步安装即可
+ 2.安装Vagrant：双击vagrant_2.2.6_x86_64.msi，一步一步安装即可
+ 3.添加镜像，以centos为例：cd到vagrant-centos-7.box所在路径，执行`vagrant box add centos/7 ./vagrant-centos-7.box`即可

## 3.Vagrant操作Centos镜像的相关命令(Ubuntu、Debian也是类似的)
>  先创建centos需要的文件夹：`mkdir centos & cd centos`下面是相关命令
+ `vagrant init centos/7` 获取centos7的Vagrantfile下来
+ `vagrant up`  根据Vagrantfile中指定的box去获取，然后在visualbox中启动起来
+ `vagrant ssh` 通过ssh进入刚创建的虚拟机中，然后执行centos中的命令即可
+ `exist` 退出虚拟机
+ `vagrant status` 看虚拟机的状态
+ `vagrant halt` 停掉目前运行的虚机
+ `vagrant destroy` 删掉虚机，在visualbox中就没有了

完整的命令如下：
```shell
vagrant -v          # 查看版本
vagrant status      # 查看状态
vagrant up          # 启动虚拟机
vagrant ssh         # 访问虚拟机
vagrant reload      # 重启虚拟机
vagrant suspend     # 挂起虚拟机（虚拟机内存都保存在硬盘上，启动可快速恢复）
vagrant resume      # 恢复虚拟机(与挂起对应)
vagrant halt        # 关闭虚拟机
vagrant destroy     # 销毁虚拟机
vagrant package     # 打包镜像（以后任何地方都能用）

# box
vagrant box list    # 镜像列表
vagrant box add     # 添加镜像
vagrant box remove  # 删除镜像
```

Vagrantfile中指定的内容不同，下不同的虚拟机类型，一个中也可以创建多台


## 直接使用[廖师兄的微信点餐系统](https://coding.imooc.com/down/187.html)的[centos.ova](https://git.imooc.com/coding-187/doc/src/master/虚拟机下载.md)，直接导入VirtualBox即可

* [VirtualBox-5.2.26(Windows版)](https://file.mukewang.com/shizhan/file/117/VirtualBox-5.2.26-128414-Win.exe)
* [VirtualBox-5.2.26(Mac版)](https://file.mukewang.com/shizhan/file/117/VirtualBox-5.2.26-128414-OSX.dmg)
* [Centos7.4（直接导入，不要解压！）](https://file.mukewang.com/shizhan/file/187/centos7.4-d886.ova)

虚拟机账号：root   
密码：123456


> docker镜像加速

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://sa30pn3u.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

上面所有的文件都放在百度网盘里了，`2.软件>1.代码开发>VirtualBox`链接分享：https://pan.baidu.com/s/1BZXjZONhJnkziffBgCvijg  提取码：34sn