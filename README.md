# Baseimage for Node.js applications

```bash
$ docker build -t uwegerdes/nodejs .
```

## Build with npm-proxy-cache on localhost-ip (accessed from docker internal network)

```bash
$ docker build -t uwegerdes/nodejs \
	--build-arg NPM_PROXY="http://$(hostname -i):3143" \
	--build-arg NPM_LOGLEVEL="warn" \
	.
```

Replace the $(hostname -i) with your proxy address if it's not on localhost - or remove that line.

On loglevel `warn` you have to wait a while if a greater amount of packages have to be loaded, use `info` for much more output.

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
* `NODE_ENV=development`

Optional parameter from build command:

* `NPM_PROXY`
* `NPM_LOGLEVEL`
