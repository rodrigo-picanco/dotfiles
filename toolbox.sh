#! /bin/bash
source ./log.sh

function help() {
   echo 
   echo "Syntax: ./toolbox.sh [option]"
   echo "options:"
   echo "help (h)   Print this Help"
   echo "create     Create development toolbox"
   echo "rm         Delete development toolbox"
   echo
}

function _rm() {
	podman image rm -f localhost/development:latest
	toolbox rm -f dev
}

function _create() {
	podman build . -t development
	toolbox create dev -i development
}

function _test() {
	_create
	podman image exists localhost/development:latest &> /dev/null
	if [ $? -eq 0 ]; then
		log success "create OK - created development image"
		if toolbox list | grep -q 'dev'; then
			log success "create OK - created dev toolbox"
			packages=( "node" "gh"  "nvim")
			for item in "${packages[@]}";
			do
				toolbox run --container dev $item "-v"
				if [ $? -eq 0 ]; then
					log success "create OK - ${item} on container"
				else
					log error "create FAIL - ${item} not in container"
				fi
			done
		else
			log error "create FAIL - toobox not created"
		fi
	else 
		log error "create FAIL - image not created"
		exit
	fi
	
	_rm &> /dev/null
	podman image exists localhost/development:latest &> /dev/null
	if [ $? -eq 0 ]; then
		log error "remove FAIL - image not removed"
		exit
	else 
		log success "remove OK - removed development image"
		if toolbox list | grep -q 'dev'; then
			log error "rm FAIL - dev toobox not removed"
		else
			log success "rm OK - removed dev toolbox"
		fi
	fi
}

case $1 in
	help)
	   help
	   exit;;
	h)
	   help
	   exit;;
	rm)
	  _rm
	  exit;;
	create)
	  _create
	  exit;;
	test)
	  _test
	  exit;;
	*)
	  log error "Invalid option"
	  exit;;
esac
