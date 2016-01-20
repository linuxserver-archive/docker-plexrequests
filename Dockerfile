FROM linuxserver/baseimage
MAINTAINER zaggash <zaggash@users.noreply.github.com>

ENV APTLIST="git curl"
ENV COPIED_APP_PATH="/tmp/git-app"
ENV BUNDLE_DIR="/tmp/bundle-dir"


#Install package
RUN apt-get update -q && \
	apt-get install $APTLIST -qy && \
	apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh


# Volumes and Ports
VOLUME /app
EXPOSE 3000
