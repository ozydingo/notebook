## Guestbook app

Web app + redis backend

## Instructions

Create each deployment

```sh
kubectl apply -f ./redis-master-deployment.yaml
kubectl apply -f ./redis-master-service.yaml
...
```

Or in one line:

```sh
kubectl apply -f ./redis-master-deployment.yaml -f ./redis-master-service.yaml ...
```

Or slurp all config files in the directory

```sh
kubectl apply -f .
```

## Viewing the service

The `redis-master` and `redis-slave` services are the default `ClusterIP` type, which means they are only accessible internally. The `frontend` service is `NodePort`, or could be set to `LoadBalancer` in a cloud provider.

To visit the application:

* If the service is type NodePort on `minikube`, use `minikube service frontend --url` to view the URL to visit in a browser
* If the service is type LoadBalancer, use `kubectl get services -l app=guestbook -l tier=frontend` to view the service's external IP to visit in a browser.

## Scaling

```sh
kubectl scale deployment frontend --replicas 2
```

Or edit `frontend-deployment.yaml` and `kubectl apply -f frontend-deployment.yaml` it.

## Cleanup

```sh
kubectl delete deployment -l app=redis
kubectl delete service -l app=redis
kubectl delete deployment -l app=guestbook
kubectl delete service -l app=guestbook
```

Or slurping

```sh
kubectl delete -f .
```
