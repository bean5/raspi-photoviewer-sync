#/bin/bash
slides=$1
restart=false
while [ 1 ]; do
	# Make sure key files + folders exist
	mkdir zips_downloaded/
	mkdir cached/
	mkdir ${slides}
	touch instructions.json
	cp instructions.json instructions.json_bak

	echo "Downloading instructions.\n"
	instructions_path=$(jq < instructions.json '.fetch.instructions.path' --raw-output)

	# Get instructions
	wget https://www.dropbox.com/s/${instructions_path}?dl=0 -O instructions.json
	if [ $? -ne 0 ]
	then
		echo "Error: Had trouble downloading instructions.json!\n"
		mv instructions.json_bak instructions.json
	else
		# Perform some parsing
		path=$(jq < instructions.json '.fetch.slides.path' --raw-output)
		folder_name=$(jq < instructions.json '.fetch.slides.folder_name' --raw-output)
		zip_type=$(jq < instructions.json '.fetch.slides.zip_type' --raw-output) # either 'files' or 'folders'

		# TODO: Support looping through a _list_ of zips to get
		if [ -e "zips_downloaded/$folder_name.zip" ];
		then
			echo "Previously downloaded ${folder_name}.zip. Skipping.\n\n"
		else
			# TODO: Perform removals. Note that according to current logic, doing so here would only perform removals run when a new zip exists. Be careful to set removal commands since some zips may be zips containing a _set_ of folders instead of files (which end up in a folder by the same name as the zip).

			echo "Downloading new content: ${folder_name}.\n"
			wget https://www.dropbox.com/s/${path}?dl=0 -O cached/${folder_name}.zip

			# if download is successful, unzip and update slideshow
			if [ $? -ne 0 ]
			then
				echo "Downloading of zip failed. Will try again later."
				rm cached/${folder_name}.zip
			else
				restart=true
				cd cached/
				echo "Downloading new zip ${folder_name}.\n"
				unzip -o ${folder_name}.zip
				rm ${folder_name}.zip

				#  Get rid of some MAC garbage
				rm -rf __MAC*
				rm -rf .DS_Store*
				if [ "$zip_type" = "files" ]
				then
					mkdir ${slides}/${folder_name}
					mv * ${slides}/${folder_name}/
				else
					mv * ${slides}/
				fi
				echo "Done getting new zip ${folder_name}.zip\n"
				cd ../

				# This is just a sentinel folder. Existence of a file indicates that it has been downloaded before. Keeping the contents of the file is redundant with the decompressed versions.
				touch zips_downloaded/${folder_name}.zip
			fi
		fi

		# Back up dl in case download fails
		cp dl.sh dl.sh_bak

		dl_path=$(jq < instructions.json '.fetch.dl.path' --raw-output)
		echo "Downloading new download manager.\n"
		wget https://www.dropbox.com/s/${dl_path}?dl=0 -O cached/dl.sh

		# if download is successful, unzip and update slideshow
		if [ $? -ne 0 ]
		then
			echo "Error: Not able to download latest download manager!\n"
			mv dl.sh_bak dl.sh
		else
			chmod +x cached/dl.sh
			cmp --silent dl.sh cached/dl.sh
			if [[ $? -eq 1 ]]; then
				mv cached/dl.sh ./
				restart=true
			else
				rm dl.sh_bak
			fi
		fi

		# Back up view.sh in case download fails
		cp view.sh view.sh_bak

		view_path=$(jq < instructions.json '.fetch.view.path' --raw-output)
		echo "Downloading new view manager.\n"
		wget https://www.dropbox.com/s/${view_path}?dl=0 -O cached/view.sh

		# if download is successful, unzip and update slideshow
		if [ $? -ne 0 ]
		then
			echo "Error: Not able to download latest view manager!\n"
			mv view.sh_bak view.sh
		else
			chmod +x cached/view.sh
			cmp --silent view.sh cached/view.sh
			if [[ $? -eq 1 ]]; then
				mv cached/view.sh ./
				restart=true
			else
				rm view.sh_bak
			fi
		fi

		# cleanup
		rm -rf cached/*
	fi

	if [[ "$restart" = true ]]; then
		shutdown -r now
	fi

	# sleep
	echo "Sleeping for 600s"
	sleep 600s
done
