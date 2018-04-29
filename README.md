# Baseimage for Node.js applications

```bash
$ docker build -t uwegerdes/nodejs .
```

## Build with npm-proxy-cache on localhost-ip (accessed from docker internal network)

```bash
$ export NODE_VERSION=8.x
$ docker build -t uwegerdes/nodejs \
	-t uwegerdes/nodejs:${NODE_VERSION} \
	--build-arg NODE_VERSION="${NODE_VERSION}" \
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

Or start a container (in your node project directory) with:

```bash
$ docker run -it \
	--name nodejs \
	-v $(pwd):/home/node/app \
	uwegerdes/nodejs \
	bash
```

Restart it with:

```bash
$ docker start -ai nodejs
```

Inside the container you can use `npm init` in the app directory.

If you want to install node modules in the container please use the following commands:

```bash
$ npmis module     # for npm install --save
$ npmisd module    # for npm install --save-dev
```

## Settings

The user `node` with password `node` and home directory `/home/node` is created.

The following variables are set:

* `USER_NAME=node`
* `HOME=/home/node`
* `NODE_HOME=/home/node`
* `NODE_PATH=/home/node/node_modules:/usr/lib/node_modules`
* `NODE_ENV=development`
* `APP_HOME=/home/node/app`

Optional parameter from build command:

* `NPM_PROXY`
* `NPM_LOGLEVEL`

