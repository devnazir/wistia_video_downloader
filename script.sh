#!/bin/bash

# Download video from Wistia
# Usage: bash script.sh <quality> <topic>
# Example: bash script.sh 1080p "Data Structures and Algorithms"

# Check if the user has provided the quality and topic
if [ $# -ne 2 ]; then
    echo "Usage: bash script.sh <quality> <topic>"
    exit 1
fi

# Check if topic contains spaces, if contains spaces, replace it with underscore
if echo "$2" | grep -q ' '; then
    topic=$(echo $2 | tr ' ' '_')
else
    topic=$2
fi

quality=$1
target_dir="$HOME/Downloads/$topic"

if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
fi

# Get the video ID from target.txt
video_ids=$(cat target.txt)
count=1
 
for video_id in $video_ids
do
    json=$(curl -s "https://fast.wistia.net/embed/medias/$video_id.json")

    # Get title of the video
    title=$(echo $json | jq '.media.name' | cut -d "/" -f 4 | tr -d '"' | cut -d "_" -f 2- | sed -E 's/(\.mp4|\.mov)//g')
    echo "Downloading video: $title"

    file_name="${count}_${title}.mp4"

    if [ -f "$target_dir/$file_name" ]; then
        echo -e "\e[33mVideo already exists\e[0m\n"
        count=$((count+1))
        continue
    fi

    # Download the video
    echo $json \
    | jq '[.media.assets[] | select(.display_name == "'$quality'").url] | first' \
    | sed 's/bin/mp4/' \
    | xargs curl -s --output "$target_dir/$file_name"

    if [ $? -eq 0 ]; then
        echo -e "\e[32mVideo downloaded successfully\e[0m\n"
    else
        echo -e "\e[31mFailed to download the video\e[0m\n"
    fi

    count=$((count+1))
done