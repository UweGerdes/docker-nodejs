# Baseimage for Node.js applications

```bash
$ docker build -t uwegerdes/nodejs .
```

## Build with npm-proxy-cache on localhost-ip (accessed from docker internal network)

```bash
$ docker build -t uwegerdes/nodejs \
	--build-arg NPM_PROXY="http://192.168.1.18:3143" \
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

If you want to install node modules in the container and not your working directory please use the following commands:

```bash
$ cd ${HOME} && \
	cp ${APP_HOME}/package.json . && \
	npm install --save-dev node_module && \
	cp package.json ${APP_HOME}/ && \
	cd ${APP_HOME}
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

