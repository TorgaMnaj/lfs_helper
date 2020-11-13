#!/bin/bash


while true
do
  echo -e "\n
  Would You like to wipe out partition?
  (Takes time..) Y/N
  "
  read -r answer
  case $answer in
    Y|y)
      sudo dd if=/dev/zero of="${1}" status=progress
      break
      ;;
    N|n)
      break
      ;;
    *)
      echo -e "\nIncorrect answer. Again.\n"
      sleep 2s
      ;;
  esac
done

sudo mkfs.ext4 -L lfs "$1"
sudo mkfs -v -t ext4 "$1"

exit 0
