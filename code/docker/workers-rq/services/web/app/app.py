import sys, os, socket, json
from flask import Flask, request
from redis import Redis, RedisError
from rq import Queue
from rq.connections import NoRedisConnectionException
from rq.job import Job
from rq.exceptions import NoSuchJobError

import my_worker

app = Flask(__name__)

redis = Redis(host="redis", db=0, socket_connect_timeout=10, socket_timeout=10)

@app.route("/")
def index():
    return "<p>Hello, workers.</p>"

@app.route("/work")
def work():
    try:
        queue = Queue(connection=redis);
        job = queue.enqueue(my_worker.work)
        response = {
            'success': True,
            'job': {
                'id': job.id,
                'enqueued_at': str(job.enqueued_at),
            },
            'message': "Work enqueued",
        }
    except (RedisError, NoRedisConnectionException) as err:
        print(err)
        response = {
            'success': True,
            'message': str(err),
        }

    return json.dumps(response);

@app.route("/jobs/<id>")
def job(id):
    try:
        job = Job.fetch(id, connection=redis)
    except NoSuchJobError:
        return json.dumps({
            'success': False,
            'job': None,
            'message': "Job not found",
        })

    return json.dumps({
        'task': job.func_name,
        'args': job.args,
        'sttatus': job.get_status(),
        'result': job.result,
        'enqueued_at': str(job.enqueued_at),
        'started_at': str(job.started_at),
        'ended_at': str(job.ended_at),
    })

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
