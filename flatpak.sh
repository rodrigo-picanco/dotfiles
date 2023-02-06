#! /bin/bash
source ./log.sh

flathub_packages=( "com.bitwarden.desktop" "io.neovim.nvim" "com.google.Chrome" )


function help() {
   echo 
   echo "Syntax: ./flatpak.sh [option]"
   echo "options:"
   echo "help (h)   Print this Help"
   echo "create     Install flathub and flatpaks"
   echo "rm         Remove flathub and flatpaks"
   echo
}

function _create() {
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak remote-modify --enable flathub
        flatpak install flathub "${flathub_packages[@]}"

}
function _rm() {
	flatpak remote-delete flathub
}

function _test() {
	_create 
	if flatpak remotes | grep -q "flathub"; then
		log success "create OK - flathub added"

		for item in "${flathub_packages[@]}"
		do
		        if flatpak list | grep -q $item; then
				log success "create OK - ${item} insatlled"
			else
				log error "create FAIL - ${item} not installed"
				exit
			fi
		done
	else
		log error "create FAIL - flathub not added"
		exit
	fi

	_rm
	if flatpak remotes | grep -q "flathub"; then
		log error "rm FAIL - flathub not removed"
	else
		log success "rm OK - flathub removed"
		exit
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
