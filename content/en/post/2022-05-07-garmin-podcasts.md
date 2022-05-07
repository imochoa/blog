---
title: Setting up Garmin Podcasts on Linux
subtitle: Initial exploration
date: 2022-05-07T18:00:00+02:00
tags: ['Garmin', 'Music', 'ffmpeg']
bigimg: [{ src: '/img/backgrounds/jack-cairney-223226.jpg' }]
draft: false
---

# The problem

I like to go on long runs, and sometimes I use that as an opportunity to catch up on my favorite podcasts.
Phones are nice, but they're delicate and don't particularly like getting wet. Unless I really need my phone, I use my [Garmin fēnix 6](https://www.garmin.com/en-US/p/641479/pn/010-02158-01) to listen to them.

Sounds easy right? Well, you'd be surprised. There are 2 main problems:

- The Spotify app for the Garmin watch is surprisingly bad and there's no Linux client for loading `.mp3` files onto the watch
- If you start listening to a 2h podcast and don't finish it, next time you try you'll spend the rest of your life fast-forwarding to where you left off last time

I would like to make a more detailed post in the future, but this should be enough to get you going.

# The solution


## How to load audio files onto the watch

Thankfully, Garmin did not "pull an Apple".
What I mean by that is that, if you plug your watch into your computer it will show up as an external storage device that you can just copy/paste from/to. The name is a bit cryptic, but I can access the audio files under: `mtp://67******************39/Primary/Music/`

(I added the asterisks just in case this id is important. It probably isn't, but I'd rather not take my chances — there are some pretty crazy people on the internet 👀)

I'm not sure what audio formats are officially supported, but `.mp3` files seem to work fine

So that's it, you can now listen to the podcast without leaving your linux distro!


## How to make listening to long audio files feasible

Technically, you could already listen to whatever you wanted. But there's still that pesky issue with the player forgetting where you stopped last time. My hunch is that Garmin's player does not store the progress made on 'standalone' audio files.

One way you can get around this is by turning it into a **playlist**. Playlists are supposed to be long, so maybe that's why Garmin decided to keep track of your progression in this case.

Ok, so what actually is a playlist and how can we make one? It is actually surprisingly simple: you just need to add an `.m3u8` file, which is explained [here](https://en.wikipedia.org/wiki/M3U). For our application, you just need to know that it's a list of **relative** paths to the audio files that make up the playlist, for example:

{{< highlight shell "linenos=table" >}}
part1.mp3
part2.mp3
part3.mp3
{{</ highlight >}}


Let's put that all together in a basic exapmle:

- Go to `mtp://67******************39/Primary/Music/Unknown/CoolPlaylist`
    - `Primary` refers to your device's "primary storage"
    - `Music` points to the audio files
    - `Unknown` I haven't tested this, but I would guess it's used to detect some metadata (eg. the genre or album )
    - `CoolPlaylist` the directory for your new files
- Lets add 2 files:
    - `mtp://.../CoolPlaylist/audio.mp3`
        - your podcast
    - `mtp://.../CoolPlaylist/playlist.m3u8`
        - the file that tells your watch it's a playlist
        - it's just a file with one line, `audio.mp3`, pointing to the one and only song in the playlist


## Future optimization

That should work, but I'm still doing something slightly less efficient: I'm splitting my long podcasts into 10-minute files so that I can quickly skip to where I want in case the playlist strategy fails.

I think this should not be necessary, but as I said I'm still optimizing this process 😁

In case anyone is interested in how I'm **currently** splitting the audio file and generating the `.m3u8`, I left that at the end of this post. I'll eventually follow-up with a nicer tool for it.

{{< highlight shell "linenos=table" >}}
#!/usr/bin/env sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# CONVERT TO MP3
# ffmpeg -v 5 -y -i input.m4a -acodec libmp3lame -ac 2 -ab 192k output.mp3


# Common functions
# ----------------------------------------------------------------------------------------- #
_log() { printf "$1$2${NC}\n"; }
log_debug() { _log ${GREEN} "$1"; }
log_info() { _log ${CYAN} "$1"; }



splitaudio() {

  [ -x "$(command -v ffmpeg)" ] || (echo "ffmpeg is not installed" && exit 1)


  default_outdir="`pwd`";
  default_seconds=600;



  # Help 
  if [ "$1" = "-h"  -o "$1" = "--help" -o -z "$1" ] ;
    then
      echo -e "Split file #1 into dir #2 (into #3 [s] segments)";
      echo -e "\tDefaults: ";
      echo -e "\t>>>> #1    (audo): REQUIRED";
      echo -e "\t>>>> #2     (dir): ${default_outdir}";
      echo -e "\t>>>> #3 (seconds): ${default_seconds} [s]";

      return 0;
  fi

  inaudio=$1;
  outdir=${2:-$default_outdir};
  seconds=${3:-$default_seconds};

  outdir="$(realpath ${outdir})";
  prefix="$(basename "${inaudio}"     \
            | rev | cut -d. -f2 | rev \
            | tr -d ' $\\/%'          \
            | head -c 10              \
      )";
  # Remove the extension (1)
  # Escape problematic characters (2)
  # Only keep the first 10 chars (3)

  log_info "Splitting ${inaudio} to ${outdir} into ${seconds}[s] segments...";
  # no video
  # -vn
  ffmpeg -i "${inaudio}" -vn -f segment -segment_time "${seconds}" -c copy "${outdir}/${prefix}_%04d.mp3"

  echo -e "Creating the playlist file ${outdir}/${prefix}.m3u8"

  (cd "${outdir}" && ls "${prefix}"* > "${prefix}".m3u8 )


}

{{</ highlight >}}

