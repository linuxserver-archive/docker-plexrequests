![http://linuxserver.io](http://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

## This is a Container in active development, and should not be used by the general public.
If you are curious about the current progress or want to comment\contribute to this work, feel free to join us at our irc channel:
[IRC](https://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`.

or visit our website at [https://linuxserver.io](https://www.linuxserver.io/)

Try it :

To make it work it needs to be in the same netork with a mongo container.

1 - Create the network ( Newer version, older use link : see below )

docker network create -d bridge plexreq_nw

2 - Start mongo

docker run -d -h mongo --name mongo --net seedbox_nw zaggash/docker-mongo

3 - Start plexrequests

docker run -d -h plexreq --name plexreq -e MONGO_URL=mongodb://mongo:27017 -e ROOT_URL=http://localhost -p 3000:3000 --net seedbox_nw zaggash/docker-plexrequests

( 3b - For older version : use link )
docker run -d -h plexreq --name plexreq -e MONGO_URL=mongodb://mongo:27017 -e ROOT_URL=http://localhost -p 3000:3000 --link mongo zaggash/docker-plexrequests

The link behaviour wil be depracated on futur version, perfere the network if available
