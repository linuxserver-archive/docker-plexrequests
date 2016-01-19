#!/bin/bash
#Moving to Working Dir
cd /config

#Install/Update PlexRequests
if [ ! -d "plexrequests-meteor" ]; then
	git clone https://github.com/lokenx/plexrequests-meteor.git
else
	cd plexrequests-meteor
	git reset --hard
	git pull
fi


chown -R abc:abc /config
chmod -R g+rw /config
