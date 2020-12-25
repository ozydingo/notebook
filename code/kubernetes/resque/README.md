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

Enqueue a job:

* Get into the container: `kubectl exec -it $POD_NAME -- sh`.
* Inside the container, enqueue a job: `bundle exec rake enqueue`

Or

* Port forward for local redis: `kubectl port-forward redis-master-85547b7b9-49sd8  6379:6379`
* Enqueue from host: `bundle exec rake enqueue`

Or

* Port forward using a custom port: `kubectl port-forward redis-master-85547b7b9-49sd8  36379:6379`
* Enqueue from the host: `redis_host="127.0.0.1:36379" bundle exec rake enqueue`

View logs to show evidence of busybee working: `kubectl logs $POD_NAME`

TODO: use init containers to delay worker start until redis is ready

### Docker-compose

Yes, this is about k8s, but let's do docker-compose as well.

`docker-compose up`

Enqueue a job:

* Get into a container: `docker container ls` then `dockeer exec -it $CONTAINER_ID sh`
* Enqueue a job: `bundle exec rake enqueue`

Or do it locally, since the `docker-compose` file exposes port 6379 already:

* `bundle exec rake enqueue`

Similar to the k8s setup above, you can change the port forwarding in the `docker-compose` file to use a custom local port, e.g.

```yaml
ports:
  - "36379:6379"
```
