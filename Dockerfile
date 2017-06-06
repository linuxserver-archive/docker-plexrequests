FROM lsiobase/xenial
MAINTAINER zaggash <zaggash@users.noreply.github.com>, sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# package versions
ARG MONGO_VERSION="3.2.9"
ARG PLEXREQ_BRANCH="master"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

COPY install.sh /tmp/install.sh

# install packages
RUN /bin/bash -xe /tmp/install.sh "${PLEXREQ_BRANCH}"

# add local files
COPY root/ /

# ports and volumes
EXPOSE 3000
VOLUME /config
