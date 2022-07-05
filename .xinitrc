#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# PATHs
[ -d ${HOME}/bin ] && export PATH=$PATH:$HOME/bin
[ -d ${HOME}/.local/bin ] && export PATH=$PATH:$HOME/.local/bin
[ -d ${HOME}/.npm/bin ] && export PATH=${PATH}:${HOME}/.npm/bin
[ -d ${HOME}/.composer ] && export COMPOSER_HOME=${HOME}/.composer
[ ! -z "${COMPOSER_HOME}" ] && [ -d ${COMPOSER_HOME}/vendor/bin ] && export PATH=${PATH}:${COMPOSER_HOME}/vendor/bin

if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
  eval `dbus-launch --sh-syntax --exit-with-session`
fi

# D-BUS
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# Display
systemctl --user import-environment DISPLAY

# Gnome Keyring
#eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)

# Vars
export TERMINAL=st
export BROWSER=firefox
export EDITOR=nano
export VISUAL=codium

# Dunst
[ ! -d ${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services ] && mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services"
ln -sfT \
    "/usr/share/dbus-1/services/${SERVICE:-org.freedesktop.Notifications}.service" \
    "${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services/org.freedesktop.Notifications.service"

# Autostart
xrandr --output HDMI-1 --primary --mode "2560x1440" &
numlockx on &
#feh --bg-fill $HOME/img/dracula/arch.png &
feh --bg-fill $HOME/img/unsplash/eberhard-grossgasteiger-8z9nQEZlIZs-unsplash.jpg
dunst -conf $HOME/.dwm/dunst.conf &
#picom --config $HOME/.dwm/picom.conf &

$HOME/.dwm/bar.sh &

xautolock -time 10 -locker slock -nowlocker slock -detectsleep -corners 000+ -cornerdelay 3 &
#xautolock -time 5 -locker fuzzy_lock -notify 20 -notifier 'xset dpms force off' &
#exec --no-startup-id xautolock -notify 30 -notifier "notify-send -u critical -t 10000 'LOCKING in 30s'" -time 15 -locker "systemctl suspend" -corners "--00"

exec dwm
