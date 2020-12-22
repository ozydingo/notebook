## Basics

* A *cluster* consists of a master and node processes.
* A *node* is a VM.
  * Each node runs *kubelet*, and agent that interfaces nodes and manages containers in the node.
  * Each node has a container runtime, such as docker.
* A *pod* is a group of containers on a node.
  * Pods share resources such as storage and networking.
  * K8s deploys pods as an atomic unit, not the containers themselves.
* A *deployment* manages the lifecycle of one or many replica *pod*s
* A *service* exposes an application running on one or more pods via an IP and port.
  * The pods that define a service can be distributed across multiple nodes.

`minikube` is a local environment for running k8s processes. Specifically, it runs a single-node k8s cluster.
`kubectl` interfaces with clusters via an API exposed on the master.

## Basic kubectl

```sh
kubectl get pods
kubectl get deployments
kubectl get services
kubectl get services/$NAME
kubectl describe ...
```

## Basic minikube

```sh
minikube ip
```

## Deployments

### Imperative

Create a deployment and expose it as a service

```sh
kubectl create deployment $NAME --image=$USER/$IMAGE
kubectl expose deployment/$NAME --type=NodePort --port 8080
```

The service type `NodePort` exposes a service directly via the port to outside the cluster. The default service type, `ClusterIP`, exposes a service only internally to the cluster. Type `LoadBalancer` is avaialble on cloud providers.

To expose the service in minikube (command returns url and port of service):

```sh
minikube service $NAME --url
```

Scale your deployment

```sh
kubectl scale deployments/$NAME --replicas=$NUMBER
```

Rolling update

```sh
kubectl set-image deployments/$DEPLOYMENT_NAME $CONTAINER=$IMAGE
```

Roll back

```sh
kubectl rollout undo deployments/$NAME
```

## Configuration

```sh
kubectl create configmap $NAME [--from-literal|--from-file|--from-end-file] $SOURCE
kubectl create secret [docker-registry|generic|tls] [--from-literal|--from-file|--from-end-file] $SOURCE
```

### ConfigMaps

### Secrets
