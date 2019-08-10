from flask import Flask
from redis import Redis, RedisError
import sys
import os
import socket

import whale.greeter as greeter

# Connect to Redis
redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

app = Flask(__name__)

@app.route("/")
def hello():
    try:
        visits = redis.incr("counter")
    except RedisError:
        visits = "<i>cannot connect to Redis, counter disabled</i>"

    name = os.getenv("NAME", "world")
    greeting = greeter.greet(name)
    host = socket.gethostname()

    html = f"<h3>Hello {name}!</h3>" \
        f"<b>Hostname:</b> {host}<br/>" \
        f"<b>Visits:</b> {visits}<br/>" \
        f"{greeting}<br/>"\
         "<img src='/static/assets/whale.png' />"

    return html

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
