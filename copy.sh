#! /bin/bash
source ./log.sh

function _create() {
	cp ~/.bashrc ~/.bashrc.bak

	mkdir -p ~/.var/app/io.neovim.nvim/config/nvim
	ln -s ~/Documents/dotfiles/configs/nvim/init.lua ~/.var/app/io.neovim.nvim/config/nvim/init.lua

	ln -sf ~/Documents/dotfiles/configs/bash/.bashrc ~/.bashrc
	ln -s ~/Documents/dotfiles/configs/bin ~/bin
}

function _rm () {
	rm ~/.var/app/io.neovim.nvim/config/nvim/init.lua
	rm ~/.bashrc
	cp ~/.bashrc.bak ~/.bashrc
	rm ~/bin
}

function cksum_bytes() {
	cksum $1 | awk '{ print $1 }'
}

function _test() {
	_create

	ls ~/.bashrc.bak &> /dev/null
	if [ $? -eq 0 ]; then
		log success "create OK - bashrc bkp" 
	else
		log error "create FAIL - basck bkp" 
	fi

	if [[  ($(cksum_bytes ~/.config/nvim/init.lua)  ==  $(cksum_bytes ~/Documents/dotfiles/configs/nvim/init.lua)) && ($(cksum_bytes ~/.bashrc)  ==  $(cksum_bytes ~/Documents/dotfiles/configs/bash/.bashrc)) && ($(cksum_bytes ~/Documents/dotfiles/bin) && $(cksum_bytes ~/bin)) ]]; then
	    log success "create OK - symlinks match checksum" 
	else
	    log error "create FAIL - symlinks do not match checksum" 
	fi

	_rm
	ls ~/.var/app/io.neovim.nvim/config/init.lua &> /dev/null

	if [ $? -eq 0 ]; then
	    log error "rm FAIL - init.lua is still in place" 
	else
	    log success "rm OK - init.lua was removed" 
	fi

	if [ $(cksum_bytes ~/.bashrc)  -eq  $(cksum_bytes ~/.bashrc.bak) ]; then
	    log success "rm OK - bashrc restored" 
	else
	    log error "rm FAIL - bashrc not restored" 
	fi

	ls ~/bin &> /dev/null
	if [ $? -eq 0 ]; then
	    log error "rm FAIL - bin is still in place" 
	else
	    log success "rm OK - bin was removed" 
	fi
}

function help() {
   echo 
   echo "Syntax: copy [option]"
   echo "options:"
   echo "help (h)   Print this Help"
   echo "create     Copy configs as symlinks"
   echo "rm         Delete symlks"
   echo
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
