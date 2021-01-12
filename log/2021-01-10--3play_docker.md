## Build a worker image

### Bind-mount app directory to allow live updates

Bind-mounting full app directory causes node_modules to be that of the host, which fails yarn integrity check.

Be aware! Cannot mount read-only as rails won't run. So logs, node_module copies, and everything else will get propagated to the host.

Could possibly only mount app, config, and lib, and possibly as read-only.

Two solutions from https://stackoverflow.com/questions/29181032/add-a-volume-to-docker-but-exclude-a-sub-folder:

1. Specify a `VOLUME` in the dockerfile and use a `build` command in the docker-compose file
2. Add another (anonymous) volume at the subdirectory (`node_modules`) location. Use the `-V` flag to `docker-compose` to not persist this volume between invocations.

Confirmed solution:

```
docker run --rm -it -v $(pwd):/worker -v node_modules:/worker/node_modules -it 3play/worker bash
```

### Get secrets into container at runtime, don't build them into the image

Use env file; but we must modify the env secrets loader to respect env variables over configs. While we could rely on host directory bind-mounting for dev secrets, we need to be able to override the db settings to use the docker-compose network.

Alternatively, we could have the default dev setup made to work with the docker-compose network.

### Networking

Use this locals.yml setup to successfully connect to the mysql service.

```
database_host: "mysql"
database_port: "3306"
```

In more details, this uses the docker-compose default network, `app3_default`, and connects to `mysql://mysql:3306`, where the `mysql://` comes from Rails setting the "mysql" adapter, the hostname `mysql` corresponds to the service name in the `docker-compose` file, and `3306` is the container port, *not* the host port.

To support connecting to the mysql service from the host as well for the web app, we need to be able to set these networking configs such as `database_host` differently for the docker-compose services than the host. Using env vars is a good solution, and requires us to modify the env loader to support env vars as overrides.

### Imperative commands during development

* `db:migrate`. This could run from the host as a viable solution until we fully dockerize all app components. At that time, `docker exec` should prove to be a solution.
* `bundle install` for gem updates needs to run in the worker container.
* `docker-compose restart [services]` can restart workers.

### Scaling workers

```
docker-compose up -V -d --scale worker=3
```

### Using multiple files

```
docker-compose -f docker-compose-deps.yml -f docker-compose-workers.yml up -V -d --scale worker=3
```
