#!/usr/bin/env bash

# One Dark
bg="^c#1f2227^"
fg="^c#abb2bf^"
cyan="^c#88c0d0^"
green="^c#a3be8c^"
red="^c#bf616a^"
yellow="^c#d7ba7d^"
blue="^c#5e81ac^"
magenta="^c#b48ead^"
orange="^c#fb7d47^"

fixed() {
    printf '%-2s' $1
}

SEP(){
    echo -n " " # "^c#666666^$sep"
}

NEWS() {
    [ "$(stat -c %y /tmp/news 2>/dev/null | awk '{ print substr($0, 0, 13) }')" = "$(date '+%Y-%m-%d %H')" ] || \
        curl -sGd 'limit=1&t=all' \
            -A "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0" \
            'https://www.reddit.com/r/worldnews.json' | \
            jq '.data.children[0].data.title' | \
            sed -e 's/^"//' -e 's/"$//' > /tmp/news

    news=$(cat /tmp/news | awk -v len=50 '{ if (length($0) > len) print substr($0, 1, len-3) "..."; else print; }')
    echo -n "${red} ${fg}${news}"
}

DOWNLOADS() {
    inst=$(ps -ef | grep yt-dlp | grep -v grep | wc -l)
    [ $inst -gt 0 ] && echo -n "${orange}${inst}${fg}" || echo ""
}

CRYPTO() {
    [ "$(stat -c %y /tmp/crypto 2>/dev/null | awk '{ print substr($0, 0, 13) }')" = "$(date '+%Y-%m-%d %H')" ] || curl -sf "brl.rate.sx/1btc" > /tmp/crypto
    crypto=$(printf "R$ %.2f" $(cat /tmp/crypto))
    echo -n "${green} ${fg}${crypto}"
}

WEATHER() {
    [ "$(stat -c %y /tmp/weather 2>/dev/null | awk '{ print substr($0, 0, 13) }')" = "$(date '+%Y-%m-%d %H')" ] || curl -sf 'wttr.in/Campo%20Grande?format=%t' > /tmp/weather
    weather="$(cat /tmp/weather)"
    echo -n "$yellow ${fg}${weather}"
}

MOON() {
    [ "$(stat -c %y /tmp/moonfile 2>/dev/null | cut -d' ' -f1)" = "$(date '+%Y-%m-%d')" ] ||
    { curl -sf "wttr.in/?format=%m" > /tmp/moonfile ;}

    icon="$(cat /tmp/moonfile)"

    case "$icon" in
        🌑) name="nova" ;;
        🌘) name="minguante" ;;
        🌗) name="quarto minguante" ;;
        🌖) name="minguante convexa" ;;
        🌕) name="cheia" ;;
        🌔) name="crescente convexa" ;;
        🌓) name="quarto crescente" ;;
        🌒) name="crescente" ;;
        *) name="" ;;
    esac

    echo -n "${blue} ${fg}$name"
}

UPDATES() {
    updates=$(checkupdates 2>/dev/null | wc -l)
    
    if [ $updates == 0 ]; then
        echo -n "${green} ${fg}atualizado"
    else
        echo -n "${cyan} ${fg}${updates}"
    fi
}

TEMP(){
    temp=$(sensors | grep 'AMD TSI Addr 98h:' | awk 'NR==1 {print $5}' | sed 's/+//g')
    #temp=$(sensors | grep 'Package id 0:' | awk 'NR==1 {print $4}' | sed 's/+//g')
    echo -n "${red}${temp}${fg}"
}

UPTIME(){
    uptime=$(uptime --pretty | sed -e 's/up //g' -e 's/ days/d/g' -e 's/ day/d/g' -e 's/ hours/h/g' -e 's/ hour/h/g' -e 's/ minutes/m/g' -e 's/ minute/m/g' -e 's/, / /g')
    echo -n "${green}${uptime}${fg}"
}

VOL(){
    sink=$( pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1 )
    #vol=$( pactl list sinks | grep '^[[:space:]]Volume base:' | head -n $(( $sink + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' )
    vol=$( pactl list sinks | grep '^[[:space:]]Volume: front-left:' | head -n $(( $sink + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' )
    echo -n "${yellow}${vol}%${fg} "
}

CPU(){
    cpu=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    #cpu=$(fixed $cpu)
    echo -n "${blue}${cpu}%${fg}"
}

MEM(){
    mem=$(free -h | awk '/^Mem.:/ {print $3}' | sed 's/i//g')
    echo -n "${magenta}${mem}${fg}"
}

DISK(){
    echo -n "${red}$(df -h | awk '/home/{print $5}')${fg}"
}

TIME(){
    time=$(date '+%I:%M%p')
    echo -n "${cyan} ${time}${fg}"
}

while true; do
    xsetroot -name "$(printf '%s %s %s %s %s %s' "$(DOWNLOADS)" "$(MOON)" "$(CPU)" "$(DISK)" "$(TEMP)" "$(VOL)" "$(TIME)")"
    sleep 5
done
