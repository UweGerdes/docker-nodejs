# base image with node (selectable version) and some essentials, user 'node' in /home/node, APP_HOME /home/node/app

ARG BASEIMAGE_VERSION=latest
FROM uwegerdes/baseimage:${BASEIMAGE_VERSION}

LABEL org.opencontainers.image.authors="entwicklung@uwegerdes.de"

ARG UID='1000'
ARG GID='1000'
ARG NODE_VERSION='22.x'
ARG NPM_LOGLEVEL

ENV NODE_VERSION=${NODE_VERSION}
ENV NODE_ENV=development
ENV USER_NAME=node
ENV NODE_HOME=/home/${USER_NAME}
ENV NODE_PATH=${NODE_HOME}/node_modules:/usr/lib/node_modules
ENV HOME=${NODE_HOME}
ENV APP_HOME=${NODE_HOME}/app

WORKDIR ${NODE_HOME}

# Install Utilities
RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y \
				build-essential \
				gcc \
				g++ \
				gnupg \
				make \
				libkrb5-dev \
				python3 && \
	curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
	sed -i -e "s/https:/http:/" /etc/apt/sources.list.d/nodesource.list && \
	apt-get update && \
	apt-get install -y \
				nodejs && \
	apt-get clean

RUN if [ -d /home/ubuntu ]; then \
		usermod -l ${USER_NAME} ubuntu && \
		groupmod -n ${USER_NAME} ubuntu && \
		usermod -c "${USER_NAME}" ${USER_NAME} ; \
	else \
		mkdir -p ${APP_HOME} && \
		groupadd --gid ${GID} ${USER_NAME} && \
		useradd --uid ${UID} --gid ${GID} --home-dir ${NODE_HOME} --shell /bin/bash ${USER_NAME} && \
		adduser ${USER_NAME} sudo ; \
	fi && \
	echo "${USER_NAME}:${USER_NAME}" | chpasswd && \
	if [ "${NPM_LOGLEVEL}" != '' ]; then \
		npm -g config set loglevel ${NPM_LOGLEVEL} ; \
	fi && \
	npm install -g --cache /tmp/root-cache \
				npm \
				npm-check-updates && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY .bash_aliases ${NODE_HOME}/

RUN chown -R ${USER_NAME}:${USER_NAME} ${NODE_HOME}

WORKDIR ${APP_HOME}

USER ${USER_NAME}

## not setting volume - it will fix ownership of contents to root
VOLUME [ "${APP_HOME}" ]

CMD [ "/bin/bash" ]

