#/bin/bash

# Mirror this in Dockerfile
# Ubuntu requirements (actual Ubuntu typically comes with xterm, etc., but safest to be explicit)
apt-get install -y x11-xserver-utils xterm wget fbi jq fbi jq

#
default_loc=$(pwd)/slides/
temp=$1
slide_loc=${temp:-$default_loc}

# Set up bashrc
echo "Setting up ~/.bashrc"
echo "" >> ~/.bashrc
echo "## Appended automatically by slideshare" >> ~/.bashrc
echo "cd $(pwd) && ./setup.sh" >> ~/.bashrc
echo "cd $(pwd) && ./dl.sh $slide_loc &" >> ~/.bashrc
echo "cd $(pwd) && ./view.sh $slide_loc" >> ~/.bashrc

# Set up xinit
echo "Setting up ~/.xinitrc"
echo "" >> ~/.xinitrc
echo "## Appended automatically by slideshare" >> ~/.xinitrc
cat .xinitrc >> ~/.xinitrc

echo "If you are running rasbian, you need to turn on auto-login. Restart typically required."
