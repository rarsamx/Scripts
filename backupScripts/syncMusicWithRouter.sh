#/bin/bash
mkdir router
sudo mount -t cifs -o username=admin,password=Los3Cochinitos //rt-n56u-c659/My_Passport/ router
unison "Sync media with router" -batch -fat
sudo umount router
rmdir router


