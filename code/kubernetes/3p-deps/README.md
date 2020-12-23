# 3p-deps

First attempt at running 3play app dependencies (mysql, mongo, redis) in a containerized environment.

## Dipping your toes: connect 3play app to mysql in docker

```sh
docker run --rm --name my-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=$PW -d mysql
bundle exec rake db:reset
```

Note -- this currently errors out due to how the 3play app database.yml is set up, but that's actually OK since it's just for test.

## Testing the waters: connect 3play app to mysql in k8s

```sh
minikube start
kubectl apply -f ./k8s
kubectl port-forward deployments/mysql-master 3306:3306
```

Add in the redis service port

```sh
kubectl port-forward deployments/mysql-master 3306:3306 6379:
6379
```
