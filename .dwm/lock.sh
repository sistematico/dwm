#!/usr/bin/env bash

# StandBy / Suspend / Off
# xset dpms 900 1200 1800


lock=${LOCK:-$(xset -q | awk '/timeout:/{print $2}')}
SUSPEND=${SUSPEND:-$(xset -q | awk '/timeout:/{print $4}')}
suspend=$((SUSPEND-LOCK))

xidlehook --not-when-fullscreen --not-when-audio --timer $lock 'slock' '' --timer $suspend 'systemctl suspend' ''
