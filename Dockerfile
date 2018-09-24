# base image with node 6.x or 8.x and some essentials, user 'node' in /home/node, APP_HOME /home/node/app

FROM uwegerdes/baseimage
MAINTAINER Uwe Gerdes <entwicklung@uwegerdes.de>

ARG UID='1000'
ARG GID='1000'
ARG NODE_VERSION='8.x'
ARG NPM_PROXY
ARG NPM_LOGLEVEL

ENV NODE_VERSION ${NODE_VERSION}
ENV NODE_ENV development
ENV USER_NAME node
ENV NODE_HOME /home/${USER_NAME}
ENV NODE_PATH ${NODE_HOME}/node_modules:/usr/lib/node_modules
ENV HOME ${NODE_HOME}
ENV APP_HOME ${NODE_HOME}/app

COPY .bashrc ${NODE_HOME}/

WORKDIR ${NODE_HOME}

# Install Utilities
RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y \
				build-essential \
				gcc \
				gnupg \
				make \
				libkrb5-dev \
				python && \
	curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
	sed -i -e "s/https:/http:/" /etc/apt/sources.list.d/nodesource.list && \
	apt-get update && \
	apt-get install -y \
				nodejs && \
	if [ "${NODE_VERSION}" == '6.x' ]; then \
		apt-get install -y \
				npm ; \
	fi && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	mkdir -p ${APP_HOME} && \
	groupadd --gid ${GID} ${USER_NAME} && \
	useradd --uid ${UID} --gid ${GID} --home-dir ${NODE_HOME} --shell /bin/bash ${USER_NAME} && \
	adduser ${USER_NAME} sudo && \
	echo "${USER_NAME}:${USER_NAME}" | chpasswd && \
	npm -g config set user ${USER_NAME} && \
	if [ "${NPM_PROXY}" != '' ]; then \
		echo "proxy = ${NPM_PROXY}" >> ${NODE_HOME}/.npmrc ; \
		echo "https-proxy = ${NPM_PROXY}" >> ${NODE_HOME}/.npmrc ; \
		echo "strict-ssl = false" >> ${NODE_HOME}/.npmrc ; \
	fi && \
	if [ "${NPM_LOGLEVEL}" != '' ]; then \
		echo "loglevel = ${NPM_LOGLEVEL}" >> ${NODE_HOME}/.npmrc ; \
	fi && \
	npm install -g \
				npm-check-updates && \
	chown -R ${USER_NAME}:${USER_NAME} ${NODE_HOME}

WORKDIR ${APP_HOME}

USER ${USER_NAME}

## not setting volume - it will fix ownership of contents to root
##VOLUME [ "${APP_HOME}" ]

CMD [ "/bin/bash" ]

