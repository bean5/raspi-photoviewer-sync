Syncing Slideshow for Raspberry Pi: A Dropbox public sync work-around
===

# Introduction
A quick way to share dropbox folders with a remote device for use as a slideshow. For example, sharing public links to zip files with a raspberry pi that polls for new data.

This bypasses the need for Dropbox syncing on the raspberry pi. Dropbox doesn't work on ARM processors, making work-arounds like this kinda necessary.

# Install
Docker support may come later. For now, to install, place the contents of this somewhere on your raspberry pi. As root, cd into this folder and run the following: `./install.sh`. If you want to specify that it store files on an external device you can use the equivalent of `./install /dev/sda1/`. This will set up `.bashrc` to call the donwloader which will loop in the background.

# ToDo Items
Of course, this project could be improved. Following are some ways.

* Ability to dockerize the downloader and the fbi viewer
* Ability to remove files via remote command
* Ability to switch to a movie mode
* Ability to switch between random vs. ordered image viewing
* An uninstall file

O, this can be simplified down to to something of a cron job. The downloader will call reboot if necessary. Really, the crux of this is that fbi is run upon login to make the raspberry pi just work upon boot.


# A Note
This program attempts to download a new version of itself after running. Of course, if git is possible, then that can be used. But since wget was the dependency of choice here, I continued with it to keep things light-weight, simple, and less dependent. Really, I'm hoping Dropbox comes out with ARM support sooner than later. It would deprecate a lot of this quite rapidly.
