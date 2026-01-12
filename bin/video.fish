# Resize video to max 1000 px tall
ffmpeg -i input.mp4 -vf "scale=h=1024:w=-1" output.mp4
# Resize video to max 1000 px wide
ffmpeg -i input.mp4 -vf "scale=w=1024:h=-1" output.mp4

# Shorten video
ffmpeg -t 00:00:20 -i input.mp4 -async 1 -c copy output-short.mp4

# Make a thumbnail from the first frame of video
ffmpeg -i input.mp4 -frames:v 1 -an -vf "setsar=1" -y output.jpg