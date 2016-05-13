#/bin/bash

while [ 1 ]; do
	# Make sure key files + folders exist
	mkdir zips_downloaded/
	mkdir cached/
	mkdir slides/
	touch instructions.json

	echo "Downloading instructions.\n"
	instructions_path=$(jq < instructions.json '.fetch.instructions.path' --raw-output)
	wget https://www.dropbox.com/s/${instructions_path}?dl=0 -O instructions.json

	if [ $? -eq 0 ]
	then
		# Perform some parsing
		path=$(jq < instructions.json '.fetch.slides.path' --raw-output)
		folder_name=$(jq < instructions.json '.fetch.slides.folder_name' --raw-output)
		zip_type=$(jq < instructions.json '.fetch.slides.zip_type' --raw-output) # either 'files' or 'folders'

		# TODO: Support looping through a list of zips to get
		if [ -e "zips_downloaded/$folder_name.zip" ];
		then
			echo "Previously downloaded ${folder_name}.zip. Skipping.\n\n"
		else
			# TODO: Perform removals. Note that according to current logic, doing so here would only perform removals run when a new zip exists. Be careful to set removal commands since some zips may be zips containing a _set_ of folders instead of files (which end up in a folder by the same name as the zip).

			echo "Downloading new content: ${folder_name}.\n"
			wget https://www.dropbox.com/s/${path}?dl=0 -O cached/${folder_name}.zip

			# if download is successful, unzip and update slideshow
			if [ $? -eq 0 ]
			then
				cd cached/
				echo "Downloading new zip ${folder_name}.\n"
				unzip -o ${folder_name}.zip
				rm ${folder_name}.zip

				if [ "$zip_type" = "files" ]
				then
					mkdir ../slides/${folder_name}
					mv * ../slides/${folder_name}/
				else
					mv * ../slides/
				fi
				# TODO: update slideshow to use this folder--move it to correct location; is restart required?
				echo "Done getting new zip ${folder_name}.zip\n"
				cd ../

				# This is just a sentinel folder. Existence of a file indicates that it has been downloaded before. Keeping the contents of the file is redundant with the decompressed versions.
				touch zips_downloaded/${folder_name}.zip
			fi

			# cleanup
			rm -rf cached/*
		fi

		prog_path=$(jq < instructions.json '.fetch.prog.path' --raw-output)
		echo "Downloading new prog.\n"
		wget https://www.dropbox.com/s/${prog_path}?dl=0 -O cached/prog.sh

		# if download is successful, unzip and update slideshow
		if [ $? -eq 0 ]
		then
			chmod +x cached/prog.sh
			mv cached/prog.sh ./
		else
			echo "Error: Not able to download latest prog!\n"
		fi
	else
		echo "Error: Had trouble downloading instructions.json!\n"
	fi

	# sleep
	echo "Sleeping for 600s"
	sleep 600s
done
