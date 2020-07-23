# TwichVideos
Simple and dirty script to download any twich video

## Resume
It download every part of the video and then put it all together.
The conversion and putting all together depends on the length of the video, and maybe took too long, you can avoid this part just commenting that part of the script

### Requirements
It needs the following packages to work

```
apt install curl gridsite-clients jq mencoder
```

### Usage:
```
./get_video.sh <video_number> [Video_name]
```
 You need to provide a video number (just the end of an url on any video on twich tv)
 And optional a name for the video to store, if not provide a name it would store as Video.mpeg
