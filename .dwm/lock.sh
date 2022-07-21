#!/usr/bin/env bash

lock=${LOCK:-$(xset -q | awk '/timeout:/{print $2}')}
SUSPEND=${SUSPEND:-$(xset -q | awk '/timeout:/{print $4}')}
suspend=$((SUSPEND-LOCK))

xidlehook --not-when-fullscreen --not-when-audio --timer $lock 'slock' '' --timer $suspend 'systemctl suspend' ''
