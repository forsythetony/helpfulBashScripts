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

function cs() {
	
	cd "$@" && ll;
}

function clearl()
{
	clear && ll
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