#! /bin/bash

CYAN="\u001b[36m"
GREEN="\u001b[32m"
MAGENTA="\u001b[35m"
RED="\033[0;31m"
RESET="\033[0m"
YELLOW="\033[33m"

declare -A log_levels_map=( ["info"]="$CYAN" ["error"]="$RED" ["action"]="$MAGENTA" ["ask"]="$YELLOW" ["success"]="$GREEN" )

function upper() {
   echo $1 | tr '[:lower:]' '[:upper:]'
}

function log() {
   log_level=$1
   shift
   
   if [[ $QUIETABLE == true ]] && [[ ${options[quiet]} == true ]] && [[ $log_level != "error" ]]; then
      return 125 # operation canceled code
   fi

   display_level=$(upper $log_level)

   printf "${log_levels_map[$log_level]}[$display_level]$RESET $@\n"
}
