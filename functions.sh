#/bin/bash


function bashreload() {
	if [ -f ~/.bash_profile ]; then
		source ~/.bash_profile
	else
		if [ -f ~/.bashrc ]; then
			source ~/.bashrc
		fi
	fi
}

function gitn() {

	#	First check to make sure the user provided exactly one argument
	if [ "$#" -ne 1 ]; then
		echo "\nIllegal number of parameters\n"
		return 1
	fi

	git checkout -b "$@"
}

function gitIgnoreEdit() {

	if [ -f ./.gitignore ];then
		atom ./.gitignore
	fi

}

function gitIgnore() {

	if [ ! -f ./.gitignore ];then

		echo "\nThe .gitignore file does not exist"

		if [ -d "./.git" ];then
			echo "\nNo .gitignore. Creating now..."
			touch .gitignore
		else
			echo "\nThis isn't even a repo..."
			return 2
		fi

	fi

	if [ "$#" -eq 0 ];then
		echo "\nYou didn't give me a file to ignore..."
		return 1
	fi

	for var in "$@";do
		if [ -f "$@" ];then
			echo "Saving $@ to .gitignore"
			echo "$@" >> .gitignore
		else
			echo "That wasn't a file"
		fi

	done

}

function openXcodeProject() {

	workspaceCount=`ls -1 *.xcworkspace 2>/dev/null | wc -l`

	if [ $workspaceCount != 0 ];then
		open *.xcworkspace
		return 0
	fi

	projectCount=`ls -1 *.xcodeproj 2>/dev/null | wc -l`

	if [ $projectCount != 0 ];then
		open *.xcodeproj
		return 0
	fi

	echo "There isn't an xcode workspace or project file in this directory..."
	return 1

}

function cs() {

	cd "$@"
	ll
}

function clearl() {
	clear && ll
}

function cdl() {
	if [ "$#" -ne 1 ]; then

		echo "Illegal number of parameters"

		return

	fi

	if [[ "$1" == *"."* ]]; then

		echo "Illegal character in folder name"

		return

	fi

	cd "$1"

	target="./"

	if test "$(ls -A "$target")"; then
	    ll
	else
	    echo The directory $target is empty '(or non-existent)'
	fi
}

function mcd() {
	if [ $# -ne 1 ]; then
		return
	fi

	if [[ ! "$1" =~ [^0-9a-z-] ]] ; then
	    echo "Valid String";
	else
		echo "String not valid";
		return
	fi

	if mkdir -p "$1"; then
		echo "Directory created"
		cd "$1"
		pwd
		ll
	else
		echo "Could not create directory"
	fi
}

function up() {
	cd ..
	ll;
}

function gitp() {
	if [ "$#" -eq 1 ]; then
		if [ ! -f ~/git_repositories.json ]; then
			echo "The repos file doesn't exist"
			return
		fi

		if ! hash jq 2>/dev/null; then
			echo "JQ does not exist "
			return
		fi

		repoPathIndex="0"
		jqFinderString=""

		gitPath=( $( cat ~/git_repositories.json | jq ".[$1].path | @sh" | tr -d '"' | tr -d "'") )

		echo $gitPath

		cd $gitPath && git pull && cd -


	else
		if git pull; then
			:
		else
			echo "Git was not properly installed"
		fi
	fi


}

function gits() {
	if git status; then
		:
	else
		echo "Git was not installed"
	fi
}

function oip() {
	if [ $# -lt 1 ]; then
		return
	fi

	git_string=""
	i=0

	for var in "$@"
	do
		if [ $i -eq 0 ]; then
			git_string="$var"
		else
			git_string="$git_string $var"
		fi
		i=$((i+1))
	done

	git_string="\"$git_string\""

	if git commit -am "$git_string"; then
		:
	else
		echo "Git is not installed properly"
		return
	fi

	git push
}


function oi() {
	if [ $# -lt 1 ]; then
		return
	fi

	git_string=""
	i=0

	for var in "$@"
	do
		if [ $i -eq 0 ]; then
			git_string="$var"
		else
			git_string="$git_string $var"
		fi
		i=$((i+1))
	done

	git_string="\"$git_string\""

	if git commit -am "$git_string"; then
		:
	else
		echo "Git is not installed properly"
	fi

}
function aliasHere() {
	if [ $# -lt 1 ]; then
		echo "You didn't enter the correct number of arguments"
		return
	fi


	#	First get the current path
	currPath=$(pwd)
	currDate=$(date)

	filePath="$HOME/.custom_bash_aliases"

	if [ -f $filePath ]; then
		echo "#		" >> $filePath
		echo "#		New alias named $1 added on $currDate" >> $filePath
		echo "#		" >> $filePath
		echo "alias $1='cs ${currPath// /\ }'" >> $filePath
		echo " " >> $filePath
		echo " " >> $filePath
	else
		echo "No file"
	fi
}

openProjectFile()
{
	FILES=./*

	for f in $FILES
	do
		if [[ $f == *.xcworkspace ]]; then
			open $f
			return
		fi
	done

	for f in $FILES
	do
		if [[ $f == *.xcproject ]]; then
			open $f
			return
		fi
	done
}

function parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function git_update(){
  git checkout master && git pull && git checkout - && git rebase master
}

#   Author:
#       Anthony Forsythe
#
#   Date Created:
#       1/25/2019
#
#   Purpose:
#       Will dummy file of size 500kb and type specified
#
#   Parameters:
#       $1:	The folder the file will be created in
#		$2:	The type of file that you wish to create (do not add the period)
#		$3: (OPTIONAL) The size in kilobytes of the file you wish to create
#
#	Note:
#		This utility does not _actually_ create the types of files you specify.
#		It will just fill their contents with junk data. Attempting to open 
#		the file will most likely result in the opening program saying
#		the file is corrupt and cannot be opened.
#
#	Example:
#		createDummyFile ~/sample_files/ txt
#
createDummyFile() {

	if [[ "$#" -ne 2 ]]; then
		printf "\nYou need to pass exactly two file arguments:
	\$1:\tParent folder path
	\$2:\tFile type to be created\n"
		return
	fi

	if ! [[ -d $1 ]]; then
		printf "\nThe path '$1' is not a directory!\n"
		return
	fi


	if [ -n "$3" ]; then
		printf "\nYou have provided the size. Setting accordingly...\n"
		NUM_KILOBYTES=$3
	else
		printf "\nYou have not provided the size. Setting a default...\n"
		NUM_KILOBYTES=500
	fi

	FILE_NAME="dummy_file.$2"

	FULL_FILE_PATH="$1/$FILE_NAME"

	dd if=/dev/zero of="$FULL_FILE_PATH" bs=1k  count=$NUM_KILOBYTES
}

#   Author:
#       Anthony Forsythe
#
#   Date Created:
#       1/25/2019
#
#   Purpose:
#       Will create a set of dummy files of the types specified
#
#   Parameters:
#       $1:		The folder the file will be created in
#		$2...n:	The file types you wish to create
#
#	Example:
#		createDummyFilesOfTypes ~/sample_files/ txt pdf mp4 
#
createDummyFilesOfTypes() {

	if [[ "$#" -lt 2 ]]; then
		printf "\nYou did not provide enough arguments.\nMust provide then following
	\$1:	The location where you want the generated files to reside
	\$2-n:	The names of the file types you wish to create\n"
		return
	fi

	DUMMY_FILE_LOCATION=$1
	if ! [ -n "$DUMMY_FILE_LOCATION" ]; then
		echo "The first parameter mush be a valid file location"
		echo "Quitting..."
		return
	fi

	for fileType in "${@:2}"
	do
		createDummyFile $DUMMY_FILE_LOCATION $fileType
	done
}

#   Author:
#       Anthony Forsythe
#
#   Date Created:
#       1/31/2019
#
#   Purpose:
#       Will close an application that is blocking a port
#
#   Parameters:
#       $1:		The port that you want to free up
#
#	Example:
#		unblockPort 8080
#
unblockPort() {

	if [[ $# -ne 1 ]]; then
		printf "  Must provide the following argument:
	\$1:	The port to be unblocked"
		return
	fi

	PORT="$1"
	GREP_COMMAND="grep 'tcp46.*$PORT'"
	RUN_COMMAND="netstat -vanp tcp | ${GREP_COMMAND} | awk '{ print \$9 }' | sed 's/[^0-9]*//g'"

	PROCESS_ID=$(eval $RUN_COMMAND)
	
	INFO_STRING="Killing process $PROCESS_ID blocking port $PORT"

	echo $INFO_STRING

	kill $PROCESS_ID
}