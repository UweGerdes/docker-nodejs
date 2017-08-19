# Baseimage for Node.js applications

```bash
$ docker build -t uwegerdes/nodejs .
```

## Build with npm-proxy-cache on localhost-ip (accessed from docker internal network)

```bash
$ docker build -t uwegerdes/nodejs \
	--build-arg NPM_PROXY="--proxy http://$(hostname -i):3143 --https-proxy http://$(hostname -i):3143 --strict-ssl false" \
	--build-arg NPM_LOGLEVEL="--loglevel warn" \
	.
```

## Usage

Use this baseimage in other `Dockerfile`s:

```
FROM uwegerdes/nodejs
```

## Settings

The user `node` with password `node` and home directory `/home/node` is created.

The following variables are set:

* `USER_NAME=node`
* `NODE_HOME=/home/node`
* `NODE_PATH=/home/node/node_modules:/usr/lib/node_modules`
* `USER_HOME=/home/node`
* `NODE_ENV=development`

Optional parameter from build commandcd :

* `NPM_PROXY`
* `NPM_LOGLEVEL`
