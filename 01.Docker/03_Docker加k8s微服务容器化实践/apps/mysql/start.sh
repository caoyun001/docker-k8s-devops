#!/bin/bash
docker stop imooc-mysql
docker rm imooc-mysql
docker run --name imooc-mysql -v $PWD/conf:/etc/mysql/conf.d -v $PWD/data:/var/lib/mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=aA111111 -e MYSQL_DATABASE=imooc -d mysql:5.7.15
