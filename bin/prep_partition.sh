#!/bin/bash

echo -e "Please enter path to the partiotion
on which You would like to have new lfs system: "
read -r path
sudo mkfs -v -t ext4 "$path"

exit 0
