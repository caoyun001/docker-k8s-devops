# 要创建的镜像的基础镜像
FROM ubuntu
# 镜像的创建人
MAINTAINER l00379880
# 更新下ununtu的镜像
RUN apt-get update
# -y是不询问的意思，所有的选项都选yes
RUN apt-get install -y nginx
# 把当前路径下的index.html拷贝到nginx下的/var/www/html路径下面
COPY index.html /var/www/html
# 将nginx在前台执行，而不是作为守护进行执行(daemon off;)
ENTRYPOINT [ "/usr/sbin/nginx","-g","daemon off;" ]
# 容器对外的访问端口是80
EXPOSE 80