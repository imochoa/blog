---
title: Setting up Garmin Podcasts on Linux
subtitle: Much easier approach
date: 2022-05-08T18:00:00+02:00
tags: ['Garmin', 'Music' ]
bigimg: [{ src: '/img/backgrounds/aman-dhakal-205796.jpg', desc: "Aman Dhakal" }]
draft: false
---

# Garmin came through
Turns out that you don't have to go as "overkill" as I did [in my last post]( {{< relref "post/2022-05-07-garmin-podcasts.md" >}}).
Garmin's audio player is nicer than I gave it credit for — it will remember the progress of audio files that are placed under: 
- `mtp://67******************39/Primary/Podcasts/yourPodcast.mp3`

So there's actually no need to split it into small `.mp3` files and turn them into a playlist using `.m3u8`...
Although it was still nice to learn about how that works ¯\\\_(ツ)_/¯

I'd like to look into whether you can nest directories there or if that would mess with the discovery of the files.
But one nice functionality is that if the `.mp3` came with metadata, that will be displayed instead of just the filename.

That's a really nice quality-of-life improvement, since most podcast downloads are usually just named after the episode numer or some weird UUID.

I'm not sure why this doesn't work for `.mp3` files under the `Music` directory.
Maybe it does and I just fumbled the button while running... I wouldn't be surprised. 
