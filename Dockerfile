FROM linuxserver/baseimage
MAINTAINER zaggash <zaggash@users.noreply.github.com>

ENV APTLIST="git nodejs"
ENV COPIED_APP_PATH="/tmp/git-app"
ENV BUNDLE_DIR="/tmp/bundle-dir"

#Install package
RUN curl -sL https://deb.nodesource.com/setup_0.10 | bash - && \
	apt-get update -q && \
	apt-get install $APTLIST -qy && \
	npm install -g npm@latest && \
	HOME=/tmp curl -sL https://install.meteor.com | sed s/--progress-bar/-sL/g | /bin/sh && \
	apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN git clone -q https://github.com/lokenx/plexrequests-meteor.git $COPIED_APP_PATH && \
	cd $COPIED_APP_PATH && \
	HOME=/tmp meteor build --directory $BUNDLE_DIR --server=http://localhost:3000 && \
	cd $BUNDLE_DIR/bundle/programs/server/ && \
	npm i && \
	mv $BUNDLE_DIR/bundle /app && \
	chown -R abc.abc /app/bundle && \
	rm /usr/local/bin/meteor && \
	rm -rf $COPIED_APP_PATH && \
	rm -rf $BUNDLE_DIR && \
	rm -rf /usr/share/doc /usr/share/doc-base && \
	npm cache clear > /dev/null 2>&1 && \
	rm -rf /tmp/* /tmp/.??*
	
#Adding Custom files
#ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh


# Volumes and Ports
VOLUME /app
EXPOSE 3000
