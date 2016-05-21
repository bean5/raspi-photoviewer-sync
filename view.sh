#/bin/bash

PHOTODIR=$1
# 1 second on raspbi is more like 5 due to slowness (loading big images takes time, even with caching enabled)
INTERVAL=1

fbi --noverbose --readahead --cachmem 200 -a -t $INTERVAL -u ${PHOTODIR}/**/*
# fbi --noverbose -a -t $INTERVAL -u `find $PHOTODIR -iname "*.jpg"`
# fbi --noverbose -a -u -t 3 /home/pi/slideshare/slides/**/*
