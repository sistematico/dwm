#!/bin/bash

#$HOME/bitbucket/dwm-tools/xssstate/xsidle.sh slock &
#xautolock -time 10 -locker slock -nowlocker slock -detectsleep -corners 000+ -cornerdelay 3 &
#xautolock -time 5 -locker fuzzy_lock -notify 20 -notifier 'xset dpms force off' &
#xautolock -notify 30 -notifier "notify-send -u critical -t 10000 'LOCKING in 30s'" -time 15 -locker "systemctl suspend" -corners "--00" &

# Working
#xautolock -time 3 -locker slock -detectsleep & 

xautolock -time 3 -locker slock -notify 10 -notifier 'xset dpms force off' &
LOCKER_PID=$!
sleep 15m 
kill -0 $LOCKER_PID && systemctl suspend