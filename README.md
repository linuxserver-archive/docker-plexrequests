[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/index.php/irc/
[podcasturl]: https://www.linuxserver.io/index.php/category/podcast/

[![linuxserver.io](https://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/plexrequests
[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/plexrequests.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/plexrequests.svg)][hub][![Build Status](http://jenkins.linuxserver.io:8080/buildStatus/icon?job=Dockers/LinuxServer.io/linuxserver-plexrequests)](http://jenkins.linuxserver.io:8080/job/Dockers/job/LinuxServer.io/job/linuxserver-plexrequests/)
[hub]: https://hub.docker.com/r/linuxserver/plexrequests/

Simple automated way for users to request new content for Plex Users can search for content to request. Integrates with couchpotato, sonarr and sickrage etc... [Plexrequests](http://plexrequests.8bits.ca/)

[![plexrequests](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/plexrequests.jpg)][plexrequestsurl]
[plexrequestsurl]: http://plexrequests.8bits.ca/

## Usage

```
docker create \
    --name=plexrequests \
    -v /etc/localtime:/etc/localtime:ro \
    -v <path to data>:/config \
    -e PGID=<gid> -e PUID=<uid>  \
    -e URL_BASE=</name> \
    -p 3000:3000 \
    linuxserver/plexrequests
```

**Parameters**

* `-p 3000` - the port(s)
* `-v /etc/localtime` for timesync - *optional*
* `-v /config` - where plexrequests should store its config files
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e URL_BASE` - used for reverse proxy, see below for explanation

It is based on ubuntu xenial with s6 overlay, for shell access whilst the container is running do `docker exec -it plexrequests /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
      uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

Webui is at `<your-ip>:3000`, sign in with your plex username. More info from the plexrequest website [FAQ](http://plexrequests.8bits.ca/faq/).

If you need to use a reverse proxy for plexrequest, set `URL_BASE` to `/<name>`. The `/` before the name is important.

## Logs and shell
* To monitor the logs of the container in realtime `docker logs -f plexrequests`.
* Shell access whilst the container is running: `docker exec -it plexrequests /bin/bash`

## Versions

+ **12.09.16:** Rebase to ubuntu xenial
+ **27.02.16:** Bump to latest release
+ **05.02.16:** Initial Release.
