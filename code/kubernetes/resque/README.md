# Resque

Resque workers in K8s

## Manifest

* workers: source code for workers and resque environment

## Running

### Start a redis server:

Local:

* Install `redis`
* In one terminal, run `redis-server`

or using docker:

```sh
docker run --name my-redis --rm -d -p 6379:6379 redis
```

### Setup and run the workers:

* Run `bunndle isntall` from the `workers` directory
* Terminal 1: `QUEUE=* bundle exec rake resque:work`
* Terminal 2: `bundle exec rake enqueue`

The worker in terminal 1 should output some dummy work logs.

## Docker development

Build the workers image (from `workers`) `docker build -t ozydingo/busybee .`

Push it: `docker push ozydingo/busybee`

On its own, this image builds but cannot successfully run as there is no redis to connect to. We can give it one using docker-compose or kubernetes.

### K8s

From the root `resque` directory, apply the k8s config: `kubectl apply -f ./k8s`

Get into the container: `kubectl exec -it $POD_NAME -- sh`

Inside the container, enqueue a job: `bundle exec rake enqueue`

From host, view the logs proving the busybee is at work: `kubectl logs $POD_NAM`

TODO: use init containers to delay worker start until redis is ready
