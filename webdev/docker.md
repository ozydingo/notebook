## Guide cheatsheets:

Resource: https://docs.docker.com/get-started/

## Concepts

Container runs on Docker; it's OS-native and runs just like any other executable. VMs, by contrast, have their own guest OS and share a "hypervisor" to have virtual access to host OS resources.

## Code

### Basics

`./Dockerfile` defines commands to set up an image, e.g. `FROM python:2.7-slim` and `COPY . /app`

```
docker build -t friendlyhello .  # Create image using this directory's Dockerfile
docker run -it freindlyhello bash   # Run image interactively, run command `bash`
docker run -u $(id -u):$(id -g) ...   # Run as current user / group for correct permissions on mounted volumens.
docker run -p 4000:80 friendlyhello  # Run "friendlyname" mapping port 4000 to 80
docker run -d -p 4000:80 friendlyhello         # Same thing, but in detached mode
docker container ls                                # List all running containers
docker container ls -a             # List all containers, even those not running
docker container stop <hash>           # Gracefully stop the specified container
docker container kill <hash>         # Force shutdown of the specified container
docker container rm <hash>        # Remove specified container from this machine
docker container rm $(docker container ls -a -q)         # Remove all containers
docker image ls -a                             # List all images on this machine
docker image rm <image id>            # Remove specified image from this machine
docker image rm $(docker image ls -a -q)   # Remove all images from this machine
docker login             # Log in this CLI session using your Docker credentials
docker tag <image> <username>/<repository>:<tag>  # Tag <image> for upload to registry
docker push <username>/<repository>:<tag>            # Upload tagged image to registry
docker run <username>/<repository>:<tag>                   # Run image from a registry
```

### Services

Use a yml file, e.g. `docker-compose.yml`, to specify service configuration. Specify image, num replicas, port mapping, etc. Easy defaults for load balancing, web settings.

Service full names are `${stack}_${service}`, e.g. `gettingstartedlab_web`

`docker stack deploy` can do an in-place update of a stack, no need for tear-down or downscaling. It does not update app code; for that you need `docker restart`. Protip: `docker restart $(docker ps -q)`.

```
docker stack ls                                            # List stacks or apps
docker stack deploy -c <composefile> <appname>  # Run the specified Compose file
docker service ls                 # List running services associated with an app
docker service ps <service>                  # List tasks associated with an app
docker inspect <task or container>                   # Inspect task or container
docker container ls -q                                      # List container IDs
docker stack rm <appname>                             # Tear down an application
docker swarm leave --force      # Take down a single node swarm from the manager

docker stack ps <stackname>         # List tasks on the stack
docker stack services <stackanme>   # List services on the stack
```

### Swarms

Run `docker swarm join-token -q worker` from a manager to see the join token for a worker again. (Use `manager` instead of `worker` to see the token for joining as a manager)

`docker swarm join --token $TOKEN 192.168.99.100:2377`

`docker-machine env` to get the command to specify a swarm manager as the current active docker machine (instead of local docker). `eval $(docker-machine env $DOCKER_MACHINE_NAME)` to do it. `docker` commands will not route to the specified manager.

```
docker-machine create --driver virtualbox myvm1 # Create a VM (Mac, Win7, Linux)
docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm1 # Win10
docker-machine env myvm1                # View basic information about your node
docker-machine ssh myvm1 "docker node ls"         # List the nodes in your swarm
docker-machine ssh myvm1 "docker node inspect <node ID>"        # Inspect a node
docker-machine ssh myvm1 "docker swarm join-token -q worker"   # View join token
docker-machine ssh myvm1   # Open an SSH session with the VM; type "exit" to end
docker node ls                # View nodes in swarm (while logged on to manager)
docker-machine ssh myvm2 "docker swarm leave"  # Make the worker leave the swarm
docker-machine ssh myvm1 "docker swarm leave -f" # Make master leave, kill swarm
docker-machine ls # list VMs, asterisk shows which VM this shell is talking to
docker-machine start myvm1            # Start a VM that is currently not running
docker-machine env myvm1      # show environment variables and command for myvm1
eval $(docker-machine env myvm1)         # Mac command to connect shell to myvm1
& "C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env myvm1 | Invoke-Expression   # Windows command to connect shell to myvm1
docker stack deploy -c <file> <app>  # Deploy an app; command shell must be set to talk to manager (myvm1), uses local Compose file
docker-machine scp docker-compose.yml myvm1:~ # Copy file to node's home dir (only required if you use ssh to connect to manager and deploy the app)
docker-machine ssh myvm1 "docker stack deploy -c <file> <app>"   # Deploy an app using ssh (you must have first copied the Compose file to myvm1)
eval $(docker-machine env -u)     # Disconnect shell from VMs, use native docker
docker-machine stop $(docker-machine ls -q)               # Stop all running VMs
docker-machine rm $(docker-machine ls -q) # Delete all VMs and their disk images
```
