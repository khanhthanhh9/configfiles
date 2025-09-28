#!/usr/bin/env bash

# Search recursively for common video files and fuzzy-pick one
video=$(find ~/personal/airvideo \
    -type f \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.mov' -o -iname '*.avi' \) \
    2>/dev/null | fzf)

# If the user picked something, open it with VLC
[ -n "$video" ] && vlc "$video" &

