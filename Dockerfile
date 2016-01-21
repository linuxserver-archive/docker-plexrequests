FROM linuxserver/baseimage
MAINTAINER zaggash <zaggash@users.noreply.github.com>

ENV APTLIST="git curl"
ENV COPIED_APP_PATH="/tmp/git-app"
ENV BUNDLE_DIR="/tmp/bundle-dir"

ENV ENV NODE_VERSION=0.10.41
ENV NODE_ARCH=x64
ENV NODE_DIST=node-v${NODE_VERSION}-linux-${NODE_ARCH}

#Install package
RUN apt-get update -q && \
	apt-get install $APTLIST -qy && \
	
	HOME=/tmp curl -sL https://install.meteor.com | sed s/--progress-bar/-sL/g | /bin/sh && \
	
	apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN cd /tmp && \
	curl -s -O -L http://nodejs.org/dist/v${NODE_VERSION}/${NODE_DIST}.tar.gz && \
	tar xzf ${NODE_DIST}.tar.gz && \
	rm -rf /opt/nodejs && \
	mv ${NODE_DIST} /opt/nodejs && \
	ln -sf /opt/nodejs/bin/node /usr/bin/node && \
	ln -sf /opt/nodejs/bin/npm /usr/bin/npm


RUN git clone -q https://github.com/lokenx/plexrequests-meteor.git $COPIED_APP_PATH && \
	cd $COPIED_APP_PATH && \
	HOME=/tmp meteor build --directory $BUNDLE_DIR --server=http://localhost:3000 && \
	cd $BUNDLE_DIR/bundle/programs/server/ && \
	npm i && \
	mv $BUNDLE_DIR/bundle /app && \
	chown -R abc.abc /app

RUN rm -rf $COPIED_APP_PATH && \
	rm -rf $BUNDLE_DIR && \
	rm /usr/local/bin/meteor && \
	rm -rf /usr/share/doc /usr/share/doc-base && \
	rm -rf /tmp/* && \
	npm cache clear  /dev/null 2>&1

#Adding Custom files
#ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh


# Volumes and Ports
VOLUME /app
EXPOSE 3000
