# Baseimage for Node.js applications

Used in my node js projects. The `node_modules` is not in the development directory but in the docker container.

## Building

```bash
$ docker build -t uwegerdes/nodejs .
```

## Building with arguments

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

`NODE_VERSION` is found on (github.com/nodesource)[https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions]. The above command builds image tags `latest` and `10.x`.

The argument `NPM_PROXY` expects a running (`folha/npm-proxy-cache`)[https://hub.docker.com/r/folha/npm-proxy-cache] on localhost. Replace $(hostname -i) with your proxy address if it's not on localhost - or remove that line if you don't want to use a proxy. If you use a hostname please make sure to add `--network=host` to this and all subsequent build and run commands or supply a DNS server ip in your local net to resolve the hostname. The `NPM_PROXY` will be used for your images build with `FROM uwegerdes/nodejs`.

On loglevel `warn` you have less output on npm install operations. Don't think nothing happens if the build of a image seems busy - you know npm install usually has a lot of things to do. You may want to use `info` for much more output.

You may add `--build-arg BASEIMAGE_VERSION="latest"` depending on the `uwegerdes/baseimage` tags you have prepared.

If you are working on a linux system and are not on user id 1000 you should use `--build-arg UID=$(id -u)` and `--build-arg GID=$(id -g)`.

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

This installs the packages in the container directory `/home/node/node_modules/` and not in `home/node/app/` - your project directory will not have `node_modules` which makes backups and other things simpler.

## Settings

The user `node` with password `node` and home directory `/home/node` is created with user id 1000.

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

