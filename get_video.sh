#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Usage: script.sh <video_number> [Video name]"
else
    #Get the token and the signature
    at_json=$(curl -sf https://api.twitch.tv/api/vods/$1/access_token -H "Client-ID: kimne78kx3ncx6brgo4mv6wki5h1ko")

    #Parse the token
    token=$(echo -n ${at_json} | jq '.token')
    token_g1=$(echo -n $token | tr -d '\\')
    token_re=${token_g1:1:${#token_g1}-2}

    #Parse the signature
    sig=$(echo -n ${at_json} | jq '.sig')
    sig_re=${sig:1:${#sig}-2}

    #Obtain the urls that tell us where the video is stored
    ttvn=$(curl -sfG --data-urlencode "allow_source=true" --data-urlencode "sig=$sig_re" --data-urlencode "token=$token_re" "https://usher.ttvnw.net/vod/$1.m3u8" | grep -v '#' )
    #Parse only the url
    ttvn_u=$(echo -n ${ttvn} | awk '{print $1}')

    #Get all the chunked videos
    chunked=$(curl -sf $ttvn_u | grep -v '#' | grep -v ',')

    #Parse the url for download the videos
    vid_u=$(echo -n ${ttvn_u} | sed 's/\(.*\)\/\(.*\)/\1\//')

    #For every part download it
    for i in $chunked
    do
        #Final url where the video is stored
        url_c=$vid_u$i
        curl -sf $url_c --output $i
        echo "$i --> Done"
    done

    #Put together all the video parts
    if [ -z "$2" ]
    then
        mencoder -ovc x264 -oac pcm -o Video.avi $chunked
    else
        mencoder -ovc x264 -oac pcm -o $2 $chunked
    fi

    #Delete all parts
    for d in $chunked
    do
        rm $d
    done
fi
