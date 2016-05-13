Syncing Slideshow for Raspberry Pi: A Dropbox public sync work-around
===

# Introduction
A quick way to share dropbox folders with a remote device for use as a slideshow. For example, sharing public links to zip files with a raspberry pi that polls for new data.

This bypasses the need for Dropbox syncing on the raspberry pi. Dropbox doesn't work on ARM processors, making work-arounds like this kinda necessary.

# A Note
This program attempts to download a new version of itself after running. Of course, if git is possible, then that can be used. But since wget was the dependency of choice here, I continued with it to keep things light-weight, simple, and less dependent. Really, I'm hoping Dropbox comes out with ARM support sooner than later. It would deprecate a lot of this quite rapidly.
