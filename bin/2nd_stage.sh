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

# In 2nd stage we are making directories on patiotion, creating lfs user and
# setting up his enviroment.

# RDIR="$(pwd)"
export LFS=/mnt/lfs

# Create the required directory layout by running the following as root:
r=( "$LFS"/{bin,etc,lib,sbin,usr,var} )

echo -e "Creating directories..."
for i in "${r[@]}"
do
  if [[ ! -d $i ]]
  then
    sudo mkdir -pv "$i"
  fi
done

case $(uname -m) in
x86_64)
  if [[ ! -d $LFS/lib64 ]]
  then
    sudo mkdir -pv $LFS/lib64
  fi
  ;;
esac

if [[ ! -d $LFS/tools ]]
then
  sudo mkdir -pv $LFS/tools
fi

#When logged in as user root, making a single mistake can damage or destroy a
#system. Therefore, the packages in the next two chapters are built as an
#unprivileged user. You could use your own user name, but to make it easier to set
#up a clean working environment, create a new user called lfs as a member of a new
#group (also named lfs) and use this user during the installation process. As
#root, issue the following commands to add the new user:

echo -e "
Adding user. Press enter to continue..
"
read -r > /dev/null

echo -e "Enter Password for new lfs user:"
sudo groupadd lfs
sudo useradd -s /bin/bash -g lfs -m -k /dev/null lfs
echo -e "Changing ownership  to lfs user..."
sudo chown -v lfs $LFS/{usr,lib,var,etc,bin,sbin,tools}
sudo chown -v lfs $LFS/sources
case $(uname -m) in
x86_64) sudo chown -v lfs $LFS/lib64 ;;
esac

# login as lfs and setup enviroment
echo -e "Setting lfs enviroment via passing commands to its user..."
(sudo su - lfs)< lib/lfs_scripts/set_enviroment

exit 0
