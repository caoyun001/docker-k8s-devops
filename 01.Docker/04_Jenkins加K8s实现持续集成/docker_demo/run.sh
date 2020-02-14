docker build -t nginx_l00379880:1.0.0 .
docker run -p 9999:80 --name nginx-hell-lsg -d nginx_l00379880:1.0.0
