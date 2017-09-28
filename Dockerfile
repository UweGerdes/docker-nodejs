# base image with node 6 and some essentials, user 'node' in /home/node

FROM uwegerdes/baseimage
MAINTAINER Uwe Gerdes <entwicklung@uwegerdes.de>

ARG UID='1000'
ARG GID='1000'
ARG NPM_PROXY
ARG NPM_LOGLEVEL

ENV USER_NAME node
ENV NODE_HOME /home/${USER_NAME}
ENV NODE_PATH ${NODE_HOME}/node_modules:/usr/lib/node_modules

# Set development environment as default
ENV NODE_ENV development

# Install Utilities
RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y \
				build-essential \
				gcc \
				make \
				libkrb5-dev \
				python && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
	sed -i -e "s/https:/http:/" /etc/apt/sources.list.d/nodesource.list && \
	apt-get update && \
	apt-get install -y \
				nodejs && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	mkdir -p ${NODE_HOME} && \
	groupadd --gid ${GID} ${USER_NAME} && \
	useradd --uid ${UID} --gid ${GID} --home-dir ${NODE_HOME} --shell /bin/bash ${USER_NAME} && \
	adduser ${USER_NAME} sudo && \
	echo "${USER_NAME}:${USER_NAME}" | chpasswd && \
	if [ "${NPM_PROXY}" != '' ]; then \
		echo "proxy = ${NPM_PROXY}" >> ${NODE_HOME}/.npmrc ; \
		echo "https-proxy = ${NPM_PROXY}" >> ${NODE_HOME}/.npmrc ; \
		echo "strict-ssl = false" >> ${NODE_HOME}/.npmrc ; \
	fi && \
	if [ "${NPM_LOGLEVEL}" != '' ]; then \
		echo "loglevel = ${NPM_LOGLEVEL}" >> ${NODE_HOME}/.npmrc ; \
	fi && \
	chown -R ${USER_NAME}:${USER_NAME} ${NODE_HOME}

CMD [ "/bin/bash" ]
