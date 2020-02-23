# 第13章 Docker+DevOps实战--过程和工具
> 本章的目标如下：
![基于k8s的devops实战](images/基于k8s的devops实战.png)

## 13.1 本章简介
完全采用免费的工具实现上面的基于k8s的devops
+ gitlab代替github
+ GitlabCI代替Jenkins或者TravisCI
+ 私有registry代替dockerhub

## 13.2 搭建gitlab
> 直接用共有的吧~公司内部也有

本地搭建参考[gitlab-server搭建](环境搭建脚本/labs/gitlab-server.md)

## 13.2 搭建GitlabCi和Pipeline
> 参考博客[GitLab CI介绍——入门篇](https://blog.csdn.net/Choerodon/article/details/97751754)

+ [gitlab-ci搭建](环境搭建脚本/labs/gitlab-ci.md)