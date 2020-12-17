# Hello Kube

A small express.js app run in a Kubernetes environment

## hello-node

This is the Express.js app. From the `app` directory, run it locally using `npm start`. Set it up using `npm install`. This app listens on port 8080.

## Dockerfile

Using `export user=ozydingo; export image=hello-node`

This builds the docker container that will run the Express app. Build it with `docker build -t $user/$image .` from this `hello-kube` directory.

To run the docker container without Kubernetes: `docker run -p 49160:8080 -d $user/$image`. Send a request to the app using `curl -i localhost:49160`. Stop the container using `docker stop $CONTAINER_ID`.

Push the image so minikube can pull it: `docker push $user/$image`.

## Kubernetes

Use `minikube` to run Kubernetes locally: `minikube start`.

### Imperative

```bash
kubectl create deployment hello-node --image=$user/$image
kubectl proxy # do this in a separate terminal
# confirm proxy is running:
curl localhost:8001/version
# get the pod name:
kubectl get pods
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy # ?? this does not function as expected.
```

Get into the pod:

```bash
kubectl exec -it $POD_NAME -- bash
# Send a localhost request to verify serever is running
curl localhost:8080
^D
```

Expose a service

```bash
# Expose the service on the node
kubectl expose deployment/hello-node --type=NodePort --port 8080
# Set up a tunnel to the minikube env from Darwin
minikube service hello-node --url
# Get the url & port from the above output
curl 127.0.0.1:53125
```
