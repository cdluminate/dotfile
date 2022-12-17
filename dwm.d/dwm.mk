dwm:
	keyrate || xset r rate 160 160 # dwm keyrate
	feh --bg-scale $(BGIMG) --bg-fill || xsetroot -solid gray # dwm background

	-pkill -f -u $$USER '.*/bin/sh.*-c.*while true.*dwmstatus.*done'
	while true; do dwmstatus; done & # dwm status bar

	-pkill -u $$USER dunst;
	dunst & # dwm notification

	-pkill -u $$USER xbindkeys;
	xbindkeys  # dwm shortcuts

# Copyq + Dwm: https://github.com/hluk/CopyQ/issues/620
	-pkill -u $$USER copyq;
	copyq & # clipboard

	-pkill -u $$USER compton;
	-pkill -u $$USER xcompmgr;
	compton || xcompmgr & # transparent bar patch

	sct 5000 # set screen color temperature to 5000
