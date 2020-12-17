## Basics

* A *ckuster* consists of a master and node processes.
* A *node* is a VM.
  * Each node runs *kubelet*, and agent that interfaces nodes and manages containers in the node.
  * Each node has a container runtime, such as docker.
* A *pod* is a group of containers on a node.
  * Pods share resources such as storage and networking.
  * K8s deploys pods as an atomic unit, not the containers themselves.
* A *service* exposes an application running on one or more pods via an IP and port.
  * The pods that define a service can be distributed across multiple nodes.

`minikube` is a local environment for running k8s processes. Specifically, it runs a single-node k8s cluster.
`kubectl` interfaces with clusters via an API exposed on the master.
