# Baseimage for Node.js applications

```bash
$ docker build -t uwegerdes/nodejs .
```

## Build with npm-proxy-cache on localhost-ip (accessed from docker internal network)

The build is based on my (docker-baseimage)[https://github.com/UweGerdes/docker-baseimage]

On a Raspberry Pi you should build the baseimage from my (docker-baseimage-arm23v7)[https://github.com/UweGerdes/docker-baseimage-arm32v7].

```bash
$ export NODE_VERSION=10.x
$ docker build -t uwegerdes/nodejs \
	-t uwegerdes/nodejs:${NODE_VERSION} \
	--build-arg NODE_VERSION="${NODE_VERSION}" \
	--build-arg NPM_PROXY="http://$(hostname -i):3143" \
	--build-arg NPM_LOGLEVEL="warn" \
	.
```

Replace the $(hostname -i) with your proxy address if it's not on localhost - or remove that line.

Replace `$(hostname -i)` with your proxy cache ip if you have a npm proxy on another machine. If you use a hostname please make sure to add `--network=host` to this and all subsequent build and run commands or supply a DNS server ip in your local net to resolve the hostname.

On loglevel `warn` you have to wait a while if a greater amount of packages have to be loaded, use `info` for much more output.

You may add `--build-arg BASEIMAGE_VERSION="latest"` depending on the baseimages you have prepared.

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

