This stack consists of a web app, Redis instance, and worker instances.

## Cheatsheet

Build:

```
cd workers && docker build -t workers-web .
```

Publish

```
docker tag workers-web ozydingo/workers-web:latest
docker push ozydingo/workers-web:latest
```

Start swarm and deploy stack locally

```
docker-machine ls  # => get IP address machine to use as manager
eval $(docker-machine env myvm1)
docker swarm init --advertise-addr 192.168.99.102 # => get token from output
docker-machine ssh myvm2 "docker swarm join --token $TOKEN_FROM_ABOVE 192.168.99.102:2377"
docker stack deploy -c docker-compose.yml $STACK_NAME
```

Navigate to `192.168.99.100` in a browser to view the web app.

View logs:

```
docker service logs $SERVICE_NAME
# e.g.
docker service logs ${STACK_NAME}_web
```

Get a terminal in a stack container:

```
docker ps
docker exec -it $CONTAINER_ID bash
```

## More depth

Deploy a stack using a swarm: `docker swarm init` from the manager and `docker swarm join ...` from the workers.

Locally, use `docker-machine create --driver virtualbox my-vm1` to create VMs that can acts as workers. `docker-machine ssh my-vm1 "..."` runs a command on the specified VM.

To start a VM as the node manager, use `docker-machine ssh myvm1 docker swarm init --advertise-addr $IP_ADDRESS`, where `$IP_ADDRESS` does NOT include the protocol or port, or uses port 2377 (not 2376!).

Run `docker-machine env my-vm1` to configure the shell to issue docker commands to `my-vm1` -- this is especially useful for accessing local files in commands without copying them to the VM. To leave, `docker-machine env -u`

Create a `data` folder that will be used by redis on the manager. TODO: do this in a Dockerfile for the redis image.

```
docker-machine ssh myvm1 "mkdir ./data"
```

Deploy: `docker stack deploy -c docker-compose.yml STACK_NAME`
