#! /bin/bash

function help() {
   echo 
   echo "Syntax: install [option]"
   echo "options:"
   echo "help (h)   Print this Help"
   echo "install     Install configurations"
   echo "uninstall   Delete development toolbox"
   echo
}

scripts=( "./auth.sh" "./copy.sh" "./flatpak.sh" "./toolbox.sh" )

function _uninstall() {
	for script in "${scripts[@]}"
	do
		$script rm
	done
}

function _install() {
	for script in "${scripts[@]}"
	do
		$script create
	done
}

function _test() {
	for script in "${scripts[@]}"
	do
		$script test
	done
}

case $1 in
	help)
	   help
	   exit;;
	h)
	   help
	   exit;;
	uninstall)
	  ./banner.sh
	  _uninstall
	  exit;;
	install)
	  ./banner.sh
	  _install
	  exit;;
	test)
	  _test
	  exit;;
	*)
	  log error "Invalid option"
	  exit;;
esac
