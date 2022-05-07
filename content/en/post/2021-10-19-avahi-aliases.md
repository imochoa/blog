---
title: Avahi-aliases
subtitle: Who even am I?
date: 2021-10-06T18:00:00+02:00
tags: ['mDNS', 'avahi']
bigimg: [{ src: '/img/backgrounds/annie-spratt-313521-unsplash.jpg' }]
draft: true
---

# Scammers love subdomains
Registering a good domain name is tricky, since most of the cool ones are already taken — **you can't just choose whatever you want**.

However, once you have a domain (say `coolpage.com`) you can configure any subdomain you want, since you are no longer "competing" for that address online.

In most cases, that just means that you can host multiple apps on your server and redirect them using the subdomain in the URL:

- `www.coolpage.com` which just points to the same server's `coolpage.com` (yes, `www.` is just a meaningless subdomain!)
- `github.coolpage.com` which redirect you to your github page
- `blog.coolpage.com` for your self-hosted wordpress instance on the same server
- `nextcloud.coolpage.com` for your self-hosted nextcloud (maybe on a different server this time?)

Scammers like to take advante of this by registering a cryptic domain (eg. `2YlkF.com`) and then set up a subdomain like `paypal.2YlkF.com` which takes you to a fake paypal page that will try to steal your password.

But subdomains aren't only good for scamming, they let you easily redirect traffic with a single entrypoint.

# mDNS + subdomains?
If you're hosting anything on your local network you've probably already set up mDNS (multicast DNS) so that you can access your server using its **hostname** as the subdomain (eg. `pi.local`) instead of its IP address (eg. `192.168.0.27`).
Without getting lost in the weeds, what happens is that your host is sending its details using a dedicated multicast address. 
That way, anyone who's listening knows how to find it.

On debian systems, that's pretty straightforward to set up using [avahi](https://www.avahi.org/). 

However, what if you wanted to host multiple services on the same device? 
We could try to use an extra subdomain like before (eg. `hole.pi.local`, `nginx.pi.local`, `admin.pi.local`), but in this situation now we have **2 subdomains** and sadly that's not supported by mDNS due to the so-called "two-label limit heuristic".

So we need a different way of exposing multiple services.
There's a python2 package called [avahi-aliases](https://github.com/airtonix/avahi-aliases) that lets you publish multiple hostnames (eg. `pi.local`, `me.local`, `you.local`). 
That sounds promising since we could use a reverse-proxy like NGINX to route the traffic from each host to the corresponding endpoint.

However, it's a bit outdated so to get it working with python3 the user george-hawkins set up some instructions on the [avahi-aliases-notes](https://github.com/george-hawkins/avahi-aliases-notes) repository. 
The basic process is to:

1. Try to install it from your package manager (if you can)

  {{< highlight shell "linenos=table" >}}
  sudo apt update
  sudo apt install python3-avahi
  {{</ highlight >}}

If that works, great. If not, you'll have to find and install the `python3-avahi.deb` for your distribution manually from [~yavdr/.../experimental-main](https://launchpad.net/~yavdr/+archive/ubuntu/experimental-main/+packages). 
For Ubuntu 20.04, that would be [this one](https://launchpad.net/~yavdr/+archive/ubuntu/experimental-main/+files/python3-avahi_0.0.1-1yavdr6~focal_all.deb`))

After downloading, you can just install it with `sudo apt install python3-avahi.deb`

2. From the [avahi-aliases-notes](https://github.com/george-hawkins/avahi-aliases-notes) repository, download the [./avahi-alias](https://github.com/george-hawkins/avahi-aliases-notes/blob/master/avahi-alias) script.
This would already be usable, but in the next step we'll look at a more-practical way of using this script.

2. To set it up as a systemd service (so it starts automatically and loads your aliases from a file), you'll need to download the the [./avahi-alias.service](https://github.com/george-hawkins/avahi-aliases-notes/blob/master/avahi-alias.service) script from the [avahi-aliases-notes](https://github.com/george-hawkins/avahi-aliases-notes) repository and follow the instructions there.

You'll have to create a file `/etc/avahi/aliases.d/default` to store your desired aliases

{{< highlight "linenos=table" >}}
me.local
pi.local
you.local
oog.local
{{</ highlight >}}

Whenever that file changes, you'll have to restart the service

{{< highlight shell "linenos=table" >}}
sudo systemctl restart avahi-alias
sudo /etc/init.d/avahi-daemon restart
{{</ highlight >}}

# Setting up the reverse proxy
I'll cover this in its own dedicated post.
