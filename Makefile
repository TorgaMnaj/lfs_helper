#! /usr/bin/make -f

help:  		## This help dialog.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

bootstrap:  	## Bootstrap project or fix existing copy
	sudo apt update
	cat requirements.apt | xargs sudo apt install -y

run:  		## Start application
	bash lfs_helper.sh

bashtests:  	## Run bash scripts tests
	bash ./.devbin/shtests.sh

commit:  	## Deploy, test, commit changes to git and push on github
	bash ./.devbin/bigcommit.sh
