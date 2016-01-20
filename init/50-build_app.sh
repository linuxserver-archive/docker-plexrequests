#!/bin/bash
set -e

git clone -q https://github.com/lokenx/plexrequests-meteor.git $COPIED_APP_PATH

cd $COPIED_APP_PATH
meteor build --directory $BUNDLE_DIR --server=http://localhost:3000

cd $BUNDLE_DIR/bundle/programs/server/
npm i

mv $BUNDLE_DIR/bundle /app
