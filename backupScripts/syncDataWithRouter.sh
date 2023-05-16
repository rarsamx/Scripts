#/bin/bash
mkdir router-data
sudo mount -t cifs -o username=admin,password=Los3Cochinitos //rt-n56u-c659/Data/ router-data
unison "Sync Data with router" -batch -fat
sudo umount router-data
rmdir router-data


