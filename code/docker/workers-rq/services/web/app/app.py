import sys, os, socket, json
from flask import Flask, request
from redis import Redis, RedisError
from rq import Queue
from rq.connections import NoRedisConnectionException

import my_worker

app = Flask(__name__)

redis = Redis(host="redis", db=0, socket_connect_timeout=10, socket_timeout=10)

@app.route("/")
def hello():
    try:
        queue = Queue(connection=redis);
        queue.enqueue(my_worker.work)
        response = {
            'success': True,
            'message': "Work enqueued",
        }
    except (RedisError, NoRedisConnectionException) as err:
        print(err)
        response = {
            'success': True,
            'message': str(err),
        }

    return json.dumps(response);

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
