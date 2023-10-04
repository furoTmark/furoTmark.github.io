---
layout: post
title: Remove subtitles automatically from video files
comments: true
tags: mkv video mkvmerge shell bash mkvtoolnix raspberry plex sub subtitles inotifywait 
---

Shell scripts still rule!

I have my personal PLEX setup at home running from a Raspberry Pi. It is easy to manage and is useful in many occasions.

My Samsung TV has issues when loading a video file that has over 30 tracks (video/audio/subtitles). This was not a general problem in the past, but I am glad that the PLEX [documentation](https://support.plex.tv/articles/203810286-what-media-formats-are-supported/) mentions it. (It was hard to find) 

### Removing subtitles

Trying to fix the issue I came across `mkvtoolnix` tool that helps re-muxing the video files and remove all the tracks that I do not need. 

The command to do so is quite simple. First one selects 2 & 3 subtitle tracks (Subtitle Id can differ). The second command just removes all subtitles from the video file.

```shell
mkvmerge -o output.mkv -s 2,3 input.mkv
or
mkvmerge -o output.mkv --no-subtitles input.mkv
```

I quickly created a small shell script that iterates through my video files and creates new versions for me.

```shell
for file in *mkv; do
 sudo mkvmerge -o "${file%.mkv}".PLEX.mkv -s 2,3 "$file"
done
```

Super! My issue is fixed, but I don't want to manually log on to my Pi every time and run the command. This lead me to automate this task even further.

### Automating subtitles removal

Then I found `inotifywait` from `inotify-tools`. This monitors directory tree for changes and can call an action on events like file created, modified, etc.

This prompted me to write a script combining the two tools and also adding some logic to the script. Ended up with the following script:

<script src="https://gist.github.com/furoTmark/dea17c409cf028a745c382a831805a9a.js"></script>

This script activates on new files. Filters out files created after the subtitles have been removed and also files that do not meet a certain criteria. I also automated the removal of these files. If the original file is not present anymore then this script also removes the altered version.

### Making it a service

The next step is to create a service out of this script that is started at system boot.

For this a file must be created at `/etc/systemd/system/sub-remover.service`

The contents should be:

```shell
[Unit]
Description=Subtitle Remover Service
After=network.target

[Service]
ExecStart=/mnt/subremover/subremover.sh /mnt
Restart=always
User=pi

[Install]
WantedBy=multi-user.target
```

The important part is the `ExecStart` this should point to the shell script file and should also have the folder it will be looking at. In this case the `subremover.sh` path with `/mnt` as the folder it should look at.

To enable the service run:

```shell
sudo systemctl daemon-reload
sudo systemctl enable sub-remover.service
```

For managing the service you can use:
```shell
sudo systemctl start sub-remover.service
sudo systemctl stop sub-remover.service
sudo systemctl status sub-remover.service
```

For checking the logs of the service:
``` shell
sudo journalctl -u sub-remover.service -f 
```
Use `-f` to follow the logs live.

