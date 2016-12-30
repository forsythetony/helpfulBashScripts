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
function cs() {
	
	cd "$@" && ll;
}

function cdl()
{
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

function mcd()
{
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

function up()
{
	cd ..
	ll;
}

function gitp()
{
	if [ "$#" -eq 0 ]; then
		:
	else
		if [ -f ~/git_directories.json ]; then
			
			if hash jq 2>/dev/null; then
				$path="~"
				$jqExp=""
				
				echo $1
				
			else
				echo "JQ is not installed"
				return
			fi
			
		else
			echo "You don't have the git directories json file..."
			return
		fi
	fi
}


function gits()
{
	if git status; then
		:
	else
		echo "Git was not installed"
	fi
}

function oip()
{
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


oi()
{
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

aliasHere()
{
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