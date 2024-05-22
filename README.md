## WISTIA VIDEO DOWNLOADER

This is a simple script to download videos from Wistia.

### How to use

1. Clone this repository
2. Install `jq` https://jqlang.github.io/jq/
3. Copy video ID value from the video URL (right-click on the video and select "Copy link and thumbnail"), there will be query like `?wvideo=xxxxx`
4. Paste the video ID in the target.txt (look at the target.example.txt)
5. Run the script

```bash
bash script.sh <quality> <topic>

# quality: 1080p, 720p, 540p, 360p
# topic: the name of the folder where the video will be saved
# Example: bash script.sh 1080p "Data Structures and Algorithms"
```