FROM ubuntu:14.04
MAINTAINER Michael Bean <michael.bean@emc.com>

# Download latest package list (required)
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y x11-xserver-utils xterm wget fbi jq
# RUN apt-get install -y xvfb

WORKDIR /main
ADD *.sh ./
ADD *.json ./
ADD *.xinitrc ./

# ENV TERM xterm
# RUN export TERM=xterm
# DISPLAY=:0 xterm
# xterm -e top
ADD .xinitrc /root/
CMD /main/dl.sh
CMD "/.xinitrc && /main/setup.sh && /main/view.sh"
