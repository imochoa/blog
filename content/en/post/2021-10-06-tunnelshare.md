---
title: Sharing through tunnels
subtitle: A worse, albeit cooler, way to share files
date: 2021-10-06T18:00:00+02:00
tags: ['docker']
bigimg: [{ src: '/img/backgrounds/bobby-johnson-406717.jpg' }]
draft: false
---

# Plumbing pipes

[Local Tunnel](https://github.com/localtunnel/localtunnel) is a great program that lets you share something running on your localhost with _anyone_. And one of the most boring things you can host is, of course, one of your directories.
The "good old" [python server](https://docs.python.org/3/library/http.server.html): `python3 -m http.server 8000`

So there's nothing stopping us from connecting the two together.
You can now share `/tmp/share` with anyone by running:

{{< highlight shell "linenos=table" >}}
cd /tmp/share
python3 -m http.server 8000 & # _&_ makes it run in the background!
node /usr/bin/lt -p 8000
{{</ highlight >}}
And it works! You _could_ have downloaded my data if you happened to be on `https://silent-mule-93.loca.lt` at the time:

![Python server localtunnel](/img/post/tunnelshare/pythonshare.png)

But that listing is kind of boring so let's upgrade to using [express](https://expressjs.com/) instead. And let's let [Docker Compose](https://docs.docker.com/compose/) handle all the messy installing and plumbing.

# Docker Compose to the rescue

{{< highlight yaml "linenos=table" >}}
version: "3.9"
services:
  webserver:
    image: node:10
    volumes:
      - type: bind
        source: ${DIR2SHARE:-.}
        read_only: true
        target: /home
    environment:
      - U=${U:-username}
      - P=${P:-pass123}
    entrypoint: bash
    working_dir: /home
    command: -c "npm install http-server -g && http-server --port 8000 --username ${U} --password ${P} "
  localtunnel:
    image: efrecon/localtunnel
    links:
      - webserver
    command:
      --local-host webserver --port 8000
{{</ highlight >}}

So what's going on here?

- L1
- L2 
- L3

So how do you run it?

{{< highlight shell "linenos=table" >}}
DIR2SHARE='/tmp/share' \
U='username' \
P='secret' \
docker-compose --file share-compose-nodejs.yaml up
{{</ highlight >}}

## Here's how that looks now

### The simple login screen

![Login Prompt](/img/post/tunnelshare/login.png)

### The updated directory listing

![NodeJS share](/img/post/tunnelshare/nodeshare.png)
