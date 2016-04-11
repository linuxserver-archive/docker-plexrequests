#!/bin/bash
##Variables
export HOME="/tmp"
COPIED_APP_PATH="/tmp/git-app"
BUNDLE_DIR="/tmp/bundle-dir"
VERSION=$(curl -sX GET  "https://api.github.com/repos/lokenx/plexrequests-meteor/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]')

##Execution
curl -o "/tmp/source.tar.gz" -L "https://github.com/lokenx/plexrequests-meteor/archive/$VERSION.tar.gz" && \
mkdir -p $COPIED_APP_PATH && \
tar xvf /tmp/source.tar.gz -C $COPIED_APP_PATH --strip-components=1 && \
cd $COPIED_APP_PATH && \
curl -sL https://install.meteor.com | sed s/--progress-bar/-sL/g | /bin/sh && \
meteor build --directory $BUNDLE_DIR --server=http://localhost:3000 && \
cd $BUNDLE_DIR/bundle/programs/server/ && \
npm i && \
mv $BUNDLE_DIR/bundle /app && \
rm /usr/local/bin/meteor && \
rm -rf /usr/share/doc /usr/share/doc-base && \
npm cache clear > /dev/null 2>&1 && \
rm -rf /tmp/* /tmp/.??* /root/.meteor
