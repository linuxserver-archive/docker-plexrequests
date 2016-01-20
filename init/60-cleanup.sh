#!/bin/bash

rm -rf $COPIED_APP_PATH
rm -rf $BUNDLE_DIR
rm /usr/local/bin/meteor
rm -rf /usr/share/doc /usr/share/doc-base 
rm -rf /tmp/*
npm cache clear  /dev/null 2>&1
