#!/usr/bin/env bash

xidlehook --not-when-fullscreen --not-when-audio --timer 60 'xrandr --output "$PRIMARY_DISPLAY" --brightness .1' 'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
  --timer 10 'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; i3lock' '' \
  --timer 3600 'systemctl suspend' ''
