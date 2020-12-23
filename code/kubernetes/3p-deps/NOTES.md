## 2020-12-22

First need: mysql. Strategy: plain mysql image, imperative commands to run `db:seed` on it.

Docker-only:

```sh
docker pull mysql
docker run mysql -it bash
```

>  2020-12-22 18:13:30+00:00 [ERROR] [Entrypoint]: Database is uninitialized and password option is not specified
	You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD

```sh
docker run -e MYSQL_ROOT_PASSWORD=$PW -d mysql
docker exec -e MYSQL_ROOT_PASSWORD=$PW -it $CONAINTER_ID mysql -u root -p
```

Create the db and allow non-localhost connections

```sql
CREATE DATABASE threeplay_development
UPDATE mysql.user SET host = '%' WHERE user='root';
```

Get the container's IP

```sh
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID
mysql -h $IP -u root -p
```

Process hangs. Suspect I need to expose a port in the ccontainer.

```sh
docker stop 5d2eee720a8
docker run --name my-mysql -p 3306 -e MYSQL_ROOT_PASSWORD=$PW -d mysql
docker container ls
```

output now contains `33060/tcp, 0.0.0.0:55009->3306/tcp`

```sh
mysql -h $IP -P 55009 -u root -p
```

Hangs, then `ERROR 2003 (HY000): Can't connect to MySQL server on '172.17.0.2' (51)`

Answer: user 127.0.0.1, not docker IP.

```sh
mysql -h 127.0.0.1 -P 55009 -u root -p
```

To use the same port (is this port forwarding?):

```sh
docker run --rm --name my-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=$PW -d mysql
mysql -h 127.0.0.1 -u root -p
```

Now `rails c` can connect using 127.0.0.1 in the database.yml file

```sh
bundle exec rake db:reset
```

Mostly success, but:

> ActiveRecord::StatementInvalid: Mysql2::Error: Cannot drop table 'accounts' referenced by a foreign key constraint 'fk_rails_9045715423' on table 'referral_partner_accounts'.: DROP TABLE `accounts` CASCADE

Hack: comment out the `add_foreign_key` statements in `schema.rb`. That works!

In Rails [Issue 14708](https://github.com/rails/rails/issues/14708) they outline the problem, and one solution is to use `db:test:prepare` for a test env. For dev, the individual commands:

```
bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:schema:load
```

still do not work. The true culprit: the db commands are done on dev and test dbs, in sequence. Our default database.yml results in our test and dev dbs being the same; hence, commands are run twice on the same db. See https://stackoverflow.com/questions/42541195/rake-dbreset-execute-in-development-and-test-environment and the comment with a link to he Rails source code.

Solution: Modify database.yml (or, quick version, locals.yml) to make sure dev and test dbs are not the same.

This works whe ndirectly modifying database.yml, but using env variables set up by application.rb EnvLoader seem to not take effect.

### Running in k8s.
