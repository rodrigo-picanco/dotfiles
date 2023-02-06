#! /bin/bash
source ./log.sh

function help() {
   echo 
   echo "Syntax: auth [option]"
   echo "options:"
   echo "help (h)   Print this Help"
   echo "create     Generate auth"
   echo "rm         Delete auth"
   echo
}

function check_existing_ssh_key() {
	ls $HOME/.ssh  2>/dev/null | grep -q id_ed25519
	return $?
}

function _rm() {
	rm -rf $HOME/.ssh
}

function _test() {
	_create &>/dev/null

	check_existing_ssh_key
	existing_ssh=$?
	if [[ $existing_ssh -ne 0 ]]; then
	    log error "create FAIL - keys not created"
	else
	    log success "create OK - keys created"
	fi

	_rm
	check_existing_ssh_key
	existing_ssh=$?
	if [[ $existing_ssh -ne 0 ]]; then
		log success "rm OK - keys deleted"
	else
		log error "rm FAIL - keys not deleted"
	fi
}



function _create() {
	email="rodrigopicancotavares@gmail.com"
	username="rodrigo-picanco"

	check_existing_ssh_key
	existing_ssh=$?
	ssh-keygen -t ed25519 -C $email -f $HOME/.ssh/id_ed25519 -q -N ""

	log info "there is your ssh key: $(cat $HOME/.ssh/id_ed25519.pub)\n copy and paste on https://github.com/settings/ssh/new"
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
	  log success "Deleted SSH key from this mahcine, now delete the key also on https://github.com/settings/ssh"
	  exit;;
	create)
	  _create
	  log success "SSH key created"
	  exit;;
	test)
	  _test
	  exit;;
	*)
	  log error "Invalid option"
	  exit;;
esac
