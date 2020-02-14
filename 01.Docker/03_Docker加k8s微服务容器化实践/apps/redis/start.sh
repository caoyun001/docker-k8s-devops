docker stop myredis
docker rm myredis
docker run -idt --name myredis -p 6379:6379 -v $PWD/data:/data -v $PWD/redis.conf:/etc/redis/redis_default.conf redis