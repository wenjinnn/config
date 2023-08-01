#!/bin/bash
$wp=${find /my/dir/blah/blah -type f | shuf -n 1}
echo -ne "preload = $wp \n wallpaper = DP-1,$wp" > ~/.config/hypr/hyprpaper.conf
hyprpaper
