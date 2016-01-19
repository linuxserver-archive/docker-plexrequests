#!/bin/bash
#Moving to Working Dir
cd /config

#Install/Update PlexRequests
if [ ! -d "plexrequests-meteor" ]; then
	git clone -q https://github.com/lokenx/plexrequests-meteor.git
else
	cd plexrequests-meteor
	git reset -q --hard
	git pull -q
fi


chown -R abc:abc /config
chmod -R g+rw /config
