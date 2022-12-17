# lumin's xinitrc
# referece: https://wiki.archlinux.org/index.php/I3
export _JAVA_AWT_WM_NONREPARENTING=1
xautolock -time 1 -locker "slock" &
while true; do xsetroot -name "$(date)"; sleep 1; done &
xset r rate 160 160
feh --bg-scale /usr/share/backgrounds/gnome/adwaita-day.jpg
#xsetroot -gray
#xsetroot -solid "#333333"
exec dwm
