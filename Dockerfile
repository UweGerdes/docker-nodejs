FROM uwegerdes/baseimage
MAINTAINER Uwe Gerdes <entwicklung@uwegerdes.de>

ARG UID='1000'
ARG GID='1000'
ARG NPM_PROXY
ARG NPM_LOGLEVEL

ENV USER_NAME node
ENV NODE_HOME /home/${USER_NAME}
ENV NODE_PATH ${NODE_HOME}/node_modules:/usr/lib/node_modules
ENV NPM_PROXY ${NPM_PROXY}
ENV NPM_LOGLEVEL ${NPM_LOGLEVEL}

# Set development environment as default
ENV NODE_ENV development

# Install Utilities
RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y \
				apt-utils \
				build-essential \
				gcc \
				graphviz \
				imagemagick \
				make \
				libkrb5-dev \
				libpng-dev \
				python \
				ssh && \
	apt-get clean  &&\
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install nodejs, use http:// for apt-cacher-ng
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
	sed -i -e "s/https:/http:/" /etc/apt/sources.list.d/nodesource.list && \
	apt-get update && \
	apt-get install -y \
				nodejs && \
	apt-get clean  &&\
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	mkdir -p ${NODE_HOME} && \
	groupadd --gid ${GID} ${USER_NAME} && \
	useradd --uid ${UID} --gid ${GID} --home-dir ${NODE_HOME} --shell /bin/bash ${USER_NAME} && \
	adduser ${USER_NAME} sudo && \
	echo "${USER_NAME}:${USER_NAME}" | chpasswd && \
	chown -R ${USER_NAME}:${USER_NAME} ${NODE_HOME}

CMD [ "/bin/bash" ]
