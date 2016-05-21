# http://raspberrypi.stackexchange.com/questions/752/how-do-i-prevent-the-screen-from-going-blank

xset s off         # don't activate screensaver
xset -dpms         # disable DPMS (Energy Star) features.
xset s noblank     # don't blank the video device
