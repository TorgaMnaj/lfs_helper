#!/bin/bash
#Copyright (c) 2020 Jan Magrot

#Permission is hereby granted, free of charge, to any person obtaining a
#copy of this software and associated documentation files (the
#'Software'), to deal in the Software without restriction, including
#without limitation the rights to use, copy, modify, merge, publish,
#distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to
#the following conditions:
#The above copyright notice and this permission notice shall be included
#in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS
#OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# In 1st stage we are preparing partition and geting packages from internet.


RDIR="$(pwd)"
export LFS=/mnt/lfs

clear
echo -e "

  Welcome to Linux From Scratch helper...
  Press enter to continue...

"
read -r > /dev/null

echo -e "

  Now I will check for development dependencies
  giving You full output and output with filtered error
  lines. Press enter.

"
read -r > /dev/null

python3 ./lib/dev_dep_check.py

echo -e "
Please enter path to the partiotion
on which You would like to have new lfs system: "
read -r path

while true
do
  echo -e "
  Would You like to format partiotion? Y/N
  "
  read -r partitioning
  case "${partitioning}" in
  Y|y)
    sudo bash ./bin/prep_partition.sh "$path"
    break
    ;;

  N|n)
    break
    ;;
  *)
    echo -e "\nWrong answer. Again.\n"
    sleep 2s
    ;;
  esac
done

# Caution
# Do not forget to check that LFS is set whenever you leave and reenter the current working environment (such
# as when doing a su to root or another user). Check that the LFS variable is set up properly with:
# echo $LFS
echo "Mounting directory..."
if [[ ! -d $LFS ]]
then
  sudo mkdir -pv $LFS
fi
sudo mount -v -t ext4 "$path" $LFS

echo "Making sources directory..."
if [[ ! -d $LFS/sources ]]
then
  sudo mkdir -v $LFS/sources
fi

#Make this directory writable and sticky. “Sticky” means that even if multiple users have write permission on a directory,
#only the owner of a file can delete the file within a sticky directory. The following command will enable the write
#and sticky modes:
sudo chmod -v a+wt $LFS/sources
cd $LFS/sources || exit 1
sudo python3 "$RDIR"/lib/get_packages.py "$RDIR"/data/packages.txt "$RDIR"/data/patches.txt

exit 0
