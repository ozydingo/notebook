from flask import Flask, request
from redis import Redis, RedisError
import sys
import os
import socket
from rq import Queue

app = Flask(__name__)

redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

@app.route("/")
def hello():
    q = Queue(redis);
    q.enqueue(redis.decr, "counter"))

    try:
        visits = redis.get("counter")
    except RedisError:
        visits = "<i>cannot connect to Redis, counter disabled</i>"

    return f'<div>{visits}</div><p>Hello, world'

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
