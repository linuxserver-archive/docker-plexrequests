FROM lsiobase/xenial
MAINTAINER zaggash <zaggash@users.noreply.github.com>, sparklyballs

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ARG COPIED_APP_PATH="/tmp/git-app"
ARG BUNDLE_DIR="/tmp/bundle-dir"
ARG MONGO_VERSION="3.2.7"

# install packages
RUN \
 curl -sL \
 https://deb.nodesource.com/setup_0.10 | bash - && \
 apt-get install -y \
	--no-install-recommends \
	nodejs=0.10.46-1nodesource1~xenial1 && \
 npm install -g npm@latest && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# install plexrequests
RUN \
 curl -o \
 /tmp/source.tar.gz -L \
	https://github.com/lokenx/plexrequests-meteor/tarball/master && \
 mkdir -p \
	$COPIED_APP_PATH && \
 tar xvf \
 /tmp/source.tar.gz -C \
	$COPIED_APP_PATH --strip-components=1 && \
 cd $COPIED_APP_PATH && \
 HOME=/tmp \
 curl -sL \
	https://install.meteor.com | \
	sed s/--progress-bar/-sL/g | /bin/sh && \
 HOME=/tmp \
 meteor build \
	--directory $BUNDLE_DIR \
	--server=http://localhost:3000 && \
 cd $BUNDLE_DIR/bundle/programs/server/ && \
 npm i && \
 mv $BUNDLE_DIR/bundle /app && \
 rm \
	/usr/local/bin/meteor && \
 rm -rf \
	/usr/share/doc \
	/usr/share/doc-base && \
 npm cache clear > /dev/null 2>&1 && \
 rm -rf \
	/tmp/* \
	/tmp/.??* \
	/root/.meteor

# install mongo
RUN \
 curl -o \
 /tmp/mongo.tgz -L \
	https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-$MONGO_VERSION.tgz  && \
 mkdir -p \
	/tmp/mongo_app && \
 tar xf \
 /tmp/mongo.tgz -C \
	/tmp/mongo_app --strip-components=1 && \
 mv /tmp/mongo_app/bin/mongod /usr/bin/ && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config
EXPOSE 3000
