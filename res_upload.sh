#!/bin/bash
#
# Description : Prepare a png image and upload it through ftp protocol. Then copy to clipboard and print on screen the file path on Markdown format
# Author      : Jose Cerrejon Gonzalez (ulysess@gmail_dot._com)
# Version     : 0.1 (2/14/16)
# Dependencies:
# On OSX:
# brew install pngquant optipng imagemagick
# On Debian:
# sudo apt-get install -y pngquant optipng imagemagick
#
# Next line necessary if you want to invoke the code from Automator

declare -a FTP=(
    "your_user" # user
    "your_psswd" # password
    "your_site.com" # url
    "/images/2016/$(date +"%m")/" # /path inside ftp
)

for f in "$@"
do
    IMGNAME=${f##*/}
    IMGNOEXT=${IMGNAME%.png}
    OUTPUT_MSG="![$IMGNOEXT](http://${FTP[2]}${FTP[3]}$IMGNAME)"
    # Resize to a temporal file
    convert -resize 512 "$f" "$IMGNOEXT"_res.png
    # Backup original file
    mv "$f" "${f%.png}".bak.png
    # Optimize the file with pngquant, optipng
    pngquant --output "$IMGNOEXT"_lossy.png --force --quality 60-80 -- "${IMGNOEXT}"_res.png
    optipng -o7 -strip all -out "$f" "$IMGNOEXT"_lossy.png
    # Cleaning da house
    rm "$IMGNOEXT"_lossy.png "$IMGNOEXT"_res.png

    # Do the magic with ftp upload
    curl -T "$f" -u ${FTP[0]}:${FTP[1]} ftp://${FTP[2]}${FTP[3]}
    # Copy to clipboard on OSX
    echo "$OUTPUT_MSG" | pbcopy 
    # On Debian, you can use the package xclip and uncomment the next two lines
    # echo "$OUTPUT_MSG" | xclip -selection clipboard
    # notify-send "Uploaded image copied to clipboard" --icon=mail-signed-verified
done
