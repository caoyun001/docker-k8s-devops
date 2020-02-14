# 第5章：Docker仓库

## 搭建本地仓库

### 创建本地仓库

```Bash
docker run -d -p 5000:5000 registory
```

### 给本地镜像按照规范命名

```Bash
docker tag 镜像名或id 私有仓库IP:端口/镜像名
# 比如
docker tag ubuntu:14.04 10.134.129.25:5000/test
```

### 推送本地镜像到私有仓库

```Bash
docker push 私有仓库IP:端口/镜像名
# 例如：
docker push 10.134.129.25:5000/test
```

### 查询私有仓库中的镜像

```Bash
curl http://私有仓库IP:端口/v1/search
```

### 从其他机器上pull镜像

```Bash
docker pull 私有仓库IP:端口/镜像名
# 比如
docker pull 10.134.129.25:5000/test
```