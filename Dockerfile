FROM linuxserver/baseimage
MAINTAINER zaggash <zaggash@users.noreply.github.com>, sparklyballs <sparklyballs@linuxserver.io>

ENV APTLIST="nodejs" \
COPIED_APP_PATH="/tmp/git-app" \
BUNDLE_DIR="/tmp/bundle-dir" \
MONGO_VERSION=3.2.1

#Install package
RUN curl -sL https://deb.nodesource.com/setup_0.10 | bash - && \
	apt-get install $APTLIST -qy && \
	npm install -g npm@latest && \
	apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN curl -o /tmp/mongo.tgz -L https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-$MONGO_VERSION.tgz  && \
	mkdir -p /tmp/mongo_app && \
        tar xf /tmp/mongo.tgz -C /tmp/mongo_app --strip-components=1 && \
        mv /tmp/mongo_app/bin/mongod /usr/bin/ && \
	rm -rf /tmp/*
	
# Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh

# Volumes and Ports
VOLUME /config
EXPOSE 3000
