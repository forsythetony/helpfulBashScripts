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
	ls -al
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

#
#   Author:
#       Anthony Forsythe
#
#   Creation Date:
#       1/28/2019
#
#   Purpose:
#       A quick little shortcut to list out the users that belong
#       to a specific group
#
#   Arguments:
#       $1:     The name of the group whose users you want to
#               list out
#
#   Sample:
#       listGroupUsers wheel
#       
#   Credit:
#       The main command for this was provided by user 'ARG' here
#       https://unix.stackexchange.com/a/241216
#
listGroupUsers() {

    if [[ "$#" -ne 1 ]]; then
        printf "
    You must provide arguments in the form of...
    \$1: Name of group
"
        return
    fi

    grep "^$1:" /etc/group
}