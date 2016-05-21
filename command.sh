#/bin/bash

bash /main/setup.sh
bash /main/dl.sh &
bash /main/view.sh &

while [ 1 ]; do
	sleep 3600s
	# restart
done
