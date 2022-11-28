## Basics

- A _cluster_ consists of a master and node processes.
- A _node_ is a VM.
  - Each node runs _kubelet_, and agent that interfaces nodes and manages containers in the node.
  - Each node has a container runtime, such as docker.
- A _pod_ is a group of containers (often just 1) on a node.
  - Pods share resources such as storage and networking.
  - K8s deploys pods as an atomic unit, not the containers themselves.
  - A Pod is a unit of scaling; you cannot scale containers inside a pod.
- A _deployment_ manages the lifecycle of one or many replica *pod*s
- A _service_ exposes an application running on one or more pods via an IP and port.
  - The pods that define a service can be distributed across multiple nodes.

`minikube` is a local environment for running k8s processes. Specifically, it runs a single-node k8s cluster.
`kubectl` interfaces with clusters via an API exposed on the master.

## Basic minikube

```sh
minikube ip
minikube start
```

## Basic declarative configuration

Ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/

Declare resources in configuration yaml (or json) files. Most resources have a `spec` (desired) and `status` (current; read-only). In the configuration file, specify a `kind`, `metadata`, and `spec` for each resource.

## Basic kubectl

```sh
kubectl get pods
kubectl get deployments
kubectl get services
kubectl get services/$NAME
kubectl describe ...
kubectkl apply ...
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

Create a secret name my-secret with key-value pairs: {FILE1: FILE1-contents, FILE2: FILE2-contents}

```sh
kubectl create secret generic --from-file FILE1 --from-file FILE2
```

Override the keys

```sh
kubectl create secret generic --from-file key1=FILE1 --from-file key2=FILE2
```

From literal

```sh
kubectl create secret generic --from-literal key1=value1 --from-literal key2=value2
```

From an env file

```sh
kubectl create secret generic --from-env-file path/to/file.env
```

## DNS

Service: `service_name.namesapce_name.svc.cluster-domain.example`; e.g. `redis-master.default.svc.cluster.local`
