import socket
from redis import Redis
from flask import Flask
import os


app = Flask(__name__)
redis = Redis(host=os.environ.get('REDIS_HOST','127.0.0.1'),port=6379)

@app.route('/')
def hello():
    redis.incr('hits')
    return 'Hello Container ! I have been seen %s times and my hostname is %s.\n' % (redis.get('hits'),socket.gethostname())

def main():
    app.run(host="0.0.0.0", port=5000, debug=True)

if __name__ == '__main__':
    main()