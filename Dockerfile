FROM linuxserver/baseimage
MAINTAINER zaggash <zaggash@users.noreply.github.com>

ENV APTLIST="nodejs mongodb-server"
ENV COPIED_APP_PATH="/tmp/git-app"
ENV BUNDLE_DIR="/tmp/bundle-dir"

#Install package
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && \
        echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list && \
        curl -sL https://deb.nodesource.com/setup_0.10 | bash - && \
	apt-get install $APTLIST -qy && \
	npm install -g npm@latest && \
	apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN curl -o /tmp/source.tar.gz -L https://github.com/lokenx/plexrequests-meteor/tarball/master && \
	mkdir -p $COPIED_APP_PATH && \
        tar xvf /tmp/source.tar.gz -C $COPIED_APP_PATH --strip-components=1 && \
        cd $COPIED_APP_PATH && \
	HOME=/tmp curl -sL https://install.meteor.com | sed s/--progress-bar/-sL/g | /bin/sh && \
	HOME=/tmp meteor build --directory $BUNDLE_DIR --server=http://localhost:3000 && \
	cd $BUNDLE_DIR/bundle/programs/server/ && \
	npm i && \
	mv $BUNDLE_DIR/bundle /app && \
	rm /usr/local/bin/meteor && \
	rm -rf /usr/share/doc /usr/share/doc-base && \
	npm cache clear > /dev/null 2>&1 && \
	rm -rf /tmp/* /tmp/.??* /root/.meteor
	
#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh


# Volumes and Ports
VOLUME /app /config
EXPOSE 3000
