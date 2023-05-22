#!/bin/bash

# ================
# Script structure
# ================

# Show usage via commandline arguments
usage() {
		echo "~~~~~~~~~~~"
		echo " U S A G E"
		echo "~~~~~~~~~~~"
		echo "Usage: ./setenv.sh ENV_TYPE"
		echo "Required:"
		echo "    - ENV_TYPE: set environment to qa or prod"
		echo ""
		exit
}



# ===================
# Main
# ===================

# If no arguments provided, display usage information
[[ $# -eq 0 ]] && usage

if [[ $# -eq 1 ]]; then
	export ENV_TYPE=$1
	ROOT_PATH="$(pwd)"
	FILE="$ROOT_PATH/.$ENV_TYPE.env"
	echo "Environment file:"
	echo "    - /path/to/file: $FILE"

	if [ -f $FILE ]; then
		unamestr=$(uname)
		if [ "$unamestr" = 'Linux' ]; then
			export $(grep -v '^#' $FILE | xargs -d '\n')
		elif [ "$unamestr" = 'FreeBSD' ]; then
			export $(grep -v '^#' $FILE | xargs -0)
		else
			echo "Unssupported"
			# unset variables 
			unset $(grep -v '^#' $FILE | sed -E 's/(.*)=.*/\1/' | xargs)
			exit 0
		fi
	else
		echo "$1 file not found"
		exit 0
	fi
else
		usage
		exit 0
fi