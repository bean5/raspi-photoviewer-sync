#/bin/bash

# Handle some USB mounting--working around the fact that GUI which is still running may automatically mount stuff.
sudo umount /dev/sda1
sudo mkdir /media/pi/SLIDESHARE
sudo mount -t vfat /dev/sda1 /media/pi/SLIDESHARE -o uid=1000,gid=100,utf8,dmask=027,fmask=137
sleep 2s


PHOTODIR=$1
# 1 second on raspbi is more like 5 due to slowness (loading big images takes time, even with caching enabled)
INTERVAL=1

fbi --noverbose --readahead --cachmem 200 -a -t $INTERVAL -u ${PHOTODIR}/**/*
# fbi --noverbose -a -t $INTERVAL -u `find $PHOTODIR -iname "*.jpg"`
# fbi --noverbose -a -u -t 3 /home/pi/slideshare/slides/**/*
