---
title: Avahi-aliases
subtitle: Who even am I?
date: 2021-10-06T18:00:00+02:00
tags: ['mDNS', 'avahi']
bigimg: [{ src: '/img/backgrounds/annie-spratt-313521-unsplash.jpg' }]
draft: false
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

Most people wouldn't think that `paypal.?????.com` is too suspicious. But not you 👀

But subdomains aren't only good for scamming, they let you easily redirect traffic with a single entrypoint.

# mDNS + subdomains?
If you're hosting anything on your local network you've probably already set up mDNS (multicast DNS) so that you can access your server using its **hostname** as the subdomain (eg. `pi.local`) instead of its IP address (eg. `192.168.0.27`).
Without getting lost in the weeds, what happens is that your host is sending its details using a dedicated multicast address. 
That way, anyone who's listening knows how to find it.

On debian systems, that's pretty straightforward to set up using [avahi](https://www.avahi.org/). 
However, this means your server is already using one submain. What if you wanted to host multiple services on the same device? Would it be possible to use mDNS with multiple addresses like `hole.pi.local`, `nginx.pi.local`, `admin.pi.local`

avahi doesn't work with subdomains...

There's a python2 package called [avahi-aliases](https://github.com/airtonix/avahi-aliases) that gets around that issue.

However, it's a bit outdated so to get it working with python3 the user george-hawkins set up some instructions on the [avahi-aliases-notes](https://github.com/george-hawkins/avahi-aliases-notes) repository.

If you can, run:
{{< highlight shell "linenos=table" >}}
sudo apt update
sudo apt install python3-avahi
{{</ highlight >}}

If that works, great. If not, you'll have to find and install the `.deb` manually.

 1. Go to  [~yavdr/.../experimental-main](https://launchpad.net/~yavdr/+archive/ubuntu/experimental-main/+packages)

 2. Find the `python3-avahi` package for your version (the download link should look something like: `https://launchpad.net/~yavdr/+archive/ubuntu/experimental-main/+files/python3-avahi_0.0.1-1yavdr6~focal_all.deb`)

 3. Download and install it (`sudo apt install python3-avahi.deb`)

 4. From the [avahi-aliases-notes](https://github.com/george-hawkins/avahi-aliases-notes) repository, download the [./avahi-alias](https://github.com/george-hawkins/avahi-aliases-notes/blob/master/avahi-alias) script and run it

## Setting it up as a systemd service

From the [avahi-aliases-notes](https://github.com/george-hawkins/avahi-aliases-notes) repository, download the [./avahi-alias.service](https://github.com/george-hawkins/avahi-aliases-notes/blob/master/avahi-alias.service) script and follow the commands

That's great, but 
What if y

But subdomains are not 
Like most useful things, you c

#py3
https://github.com/george-hawkins/avahi-aliases-notes

# Download python3-avahi

https://launchpad.net/~yavdr/+archive/ubuntu/experimental-main/+files/python3-avahi_0.0.1-1yavdr6~focal_all.deb

# Restart

{{< highlight shell "linenos=table" >}}
sudo systemctl restart avahi-alias
sudo /etc/init.d/avahi-daemon restart
{{</ highlight >}}

