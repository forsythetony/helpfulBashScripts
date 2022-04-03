#/bin/bash

function rEcho() {

	if [[ "$#" < 1 ]]; then
		return 1
	fi

	echo "🤖: $@"
}

function gitupdate() {

	#	First let's make sure we're on the 'main' branch
	CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
	
	if [[ "$#" == 1 ]]; then
		
		if [[ "$1" == "master" ]]; then
			rEcho "I see you're overriding things. Will integrate master into this branch."
			git fetch upstream && git rebase upstream/master
			return 0
		fi
		
		rEcho "You've given me something I don't know how to handle. Exiting..."
		return 2
	fi

	if [[ "$CURRENT_BRANCH" != "main" ]]; then
		rEcho "You're not on the main branch!"
		rEcho "Going to quit before I mess something up..."
		return 1
	fi

	rEcho "Beep Boop Bop ... Integrating upstream changes into main"
	
	git fetch upstream && git rebase upstream/main
}
function bashreload() {
	if [ -f ~/.zshrc ]; then
		echo "Found a .bash_profile to source!"
		source ~/.zshrc
	else
		if [ -f ~/.bashrc ]; then
			echo "Found a .bashrc to source!"
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

#
#	Author:
#		Anthony Forsythe
#
#	Creation Date:
#		02-06-2019
#
#	Purpose:
#		Will show the diff for a particular file when given an
#		expression. The expression will be surrounded by wildcards.
#
#	Arguments:
#		$1:	The search term (will be surrouned by wildcards)
#
#	Sample:
#		gitd hello	
#	
function gitd() {

	if [ $# -ne 1 ]; then
		echo "You must provide a search term!"
		return 1
	fi
	
	git diff *$1*
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

#
#	Author:
#		Anthony Forsythe (https://github.com/forsythetony)
#
#	Date Created:
#		02-28-2020
#
#	Purpose:
#		Will add a symbolic link to the directly you are currently in, essentially 
#		bookmarking it. Incredibly useful when paired with the `favoritesJump` 
#		command to quickly jump between "bookmarked" directories.
#
#	Note:
#		You must export the `FAVORITES_DIR` environment variable in your 
#		`.bash_profile`. It can just be an (initially) empty command.
#
#	Parameters:
#		$1 (optional):	The name for the symbolic link
#
#	Example:
#		addFavorite iosProjectFiles
#
function addFavorite() {

	if [[ -z "$FAVORITES_DIR" ]]; then
		rEcho "The FAVORITES_DIR variable is not set in the shell"
		rEcho "Exiting"
		return 1
	fi
	
	
	FAVORITE_NAME=`basename $PWD`

	if [ "$#" -ge 1 ]; then
    	FAVORITE_NAME="$1"
	fi

	rEcho "Creating a favorite with name $FAVORITE_NAME -> $PWD"
	
	FAVROITE_ROOT_PATH="$FAVORITES_DIR/"

	SYM_LINK_PATH="$FAVROITE_ROOT_PATH$FAVORITE_NAME"

	ln -s $PWD $SYM_LINK_PATH
}

function removeFavorite() {

	red=$'\e[1;31m'
	NC='\033[0m' # No Color

	if [[ -z "$FAVORITES_DIR" ]]; then
		echo "🤖: The FAVORITES_DIR variable is not set in the shell"
		echo "🤖: Exiting"
		return 1
	fi
	
	
	SELECTED_FAVORITE=`ls -d $FAVORITES_DIR/* | fzf`

	FAVORITE_BASENAME=`basename $SELECTED_FAVORITE`
	echo "🤖: Are you sure you want to delete -> $red$FAVORITE_BASENAME$NC ... (yes/no)"
	read DELETION_CONFIRMATION

	DELETION_CONFIRMATION=`echo "$DELETION_CONFIRMATION" | tr '[:upper:]' '[:lower:]'`

	if [[ "$DELETION_CONFIRMATION" == "y" ]] || [[ "$DELETION_CONFIRMATION" == "yes" ]]; then
		echo "🤖: Deleting favorite $FAVORITE_BASENAME"
		rm $SELECTED_FAVORITE
		return 0
	elif [[ "$DELETION_CONFIRMATION" == "n" ]] || [[ "$DELETION_CONFIRMATION" == "no" ]]; then
		echo "🤖: Will not delete $FAVORITE_BASENAME"
		return 0;
	else
		echo "🤖: I *ptthhhh* cant *ptthhhh* understand *pttthhhhh* your *pthhhhh* accent"
	fi
}

#
#	Author:
#		Anthony Forsythe
#
#	Date Created:
#		02-28-2020
#
#	Purpose:
#		Will retrieve a list of all modified files according to
#		git
#
#	Parameters:
#
#	Example:
#		getModFiles
#
function getModFiles() {
	if [[ "$#" -eq 1 ]]; then
		git status | rg modified | rg "$1" | cut -d$' ' -f 4
	else
		git status | rg modified | cut -d$' ' -f 4
	fi
}

function fuzzyModFiles() {
	getModFiles | fzf
}

function getModBothFiles() {
	git status | rg both | cut -d$' ' -f 5
}

function getNewFiles() {
	git status | rg new | cut -d$' ' -f 5
}

function addMod {

	FILE_NAME=`getModFiles | fzf`

	if [[ -z "$FILE_NAME" ]]; then
		echo "No file found. Exiting."
		return 1
	fi

    git add "$FILE_NAME"
}

function checkoutMod {

	FILE_NAME=`getModFiles | fzf`

	if [[ -z "$FILE_NAME" ]]; then
		echo "No file found. Exiting."
		return 1
	fi

    git checkout -- "$FILE_NAME"
}

function addModBoth {
    git add `getModBothFiles | fzf`
}

function diffMod {

	if [[ "$#" -eq 1 ]]; then
		FILE_NAME=`getModFiles $1 | fzf`
	else
		FILE_NAME=`getModFiles | fzf`
	fi

	if [[ -z "$FILE_NAME" ]]; then
		echo "No file found. Exiting."
		return 1
	fi

    git diff "$FILE_NAME"

	echo "$FILE_NAME" | tr '\n' ' ' | pbcopy
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

#
#   Author:
#       Anthony Forsythe
#
#   Creation Date:
#       Unknown
#
#   Modification Date:
#       02/06/2019
#
#   Purpose:
#       Will create an alias with the provided name that will change
#		into the directory your are currently in and list the contents
#
#	Notes:
#		This function will create a file in your home directory called
#		.custom_bash_aliases.sh the first time that it is run. A source
#		command for this file will be added to your .bash_profile. All
#		aliases created from this function will be stored there.
#
#   Arguments:
#       $1:     The name you want to give to the alias
#
#   Sample:
#       aliasHere scriptsFolder
#       
function aliasHere() {

	if [ $# -ne 1 ]; then
		echo "You didn't enter the correct number of arguments"
		return
	fi

	#	Make sure that the file path for '.custom_bash_aliases'
	#	exists. If it does not then make sure to go out and create
	#	if and add it to your bash profile
	CUSTOM_ALIASES_FILE_PATH="$HOME/.custom_bash_aliases.sh"
	BASH_PROFILE_PATH="$HOME/.zshrc"

	if [ ! -f "$CUSTOM_ALIASES_FILE_PATH" ]; then
		touch "$CUSTOM_ALIASES_FILE_PATH"
		printf "\n\nif [ -f $CUSTOM_ALIASES_FILE_PATH ]; then" >> $BASH_PROFILE_PATH
		printf "\tsource $CUSTOM_ALIASES_FILE_PATH" >> $BASH_PROFILE_PATH
		printf "\nfi" >> $BASH_PROFILE_PATH
	fi

	#	Let's get the current path as well as the current date so
	#	that we can add it to our .custom_bash_aliases.sh file
	#	with a little note
	CURR_PATH=$(pwd)
	CURR_DATE=$(date)

	#	Add the alias to the .custom_bash_aliases.sh file
	if [ -f $CUSTOM_ALIASES_FILE_PATH ]; then
		echo "#		" >> $CUSTOM_ALIASES_FILE_PATH
		echo "#		New alias named $1 added on $CURR_DATE" >> $CUSTOM_ALIASES_FILE_PATH
		echo "#		" >> $CUSTOM_ALIASES_FILE_PATH
		echo "alias $1='cs ${CURR_PATH// /\ }'" >> $CUSTOM_ALIASES_FILE_PATH
		echo " " >> $CUSTOM_ALIASES_FILE_PATH
		echo " " >> $CUSTOM_ALIASES_FILE_PATH
	else
		echo "No file"
	fi

	#	Reload everything so that changes are reflected
	bashreload
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
#		$4: (OPTIONAL) The name of the file
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

	if [[ "$#" -lt 2 ]]; then
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

	if [ -n "$4" ]; then
		printf "\nYou have provided the file name. Setting accordingly...\n"
		FILE_NAME=$4
	else
		printf "\nYou have not provided the size. Setting a default...\n"
		FILE_NAME="dummy_file"
	fi


	FILE_NAME="$FILE_NAME.$2"

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

#
#	Author:
#		Anthony Forsythe
#
#	Creation Date:
#		04-25-2019
#
#	Purpose:
#		To find the process ID that is currently blocking a
#		a port. Will echo the process ID blocking that port
#
#	Arguments:
#		$1: 	The port whose blocking process ID you want to
#				find
#	Sample:
#		findBlockingProcessID 8000		
#
findBlockingProcessID() {
	if [[ $# -ne 1 ]]; then
		echo ""
		return
	fi

	netstat -vanp tcp | grep $1 | head -n 1 | awk '{ print $9 }'
}

#   Author:
#       Anthony Forsythe
#
#   Date Created:
#       01-31-2019
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
	\$1:	The port to be unblocked\n"
		return
	fi

	blockedPort=$(findBlockingProcessID $1)

	if [[ -z "$blockedPort" ]]; then
		echo "Was unable to find a process blocking port $1"
		return
	fi

	echo "Killing the process with ID -> $blockedPort blocking port $1"
	kill -9 $blockedPort
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

chooseDirectory() {
	ls -d */ | fzf
}

gradleRunDir() {

	if [[ "$#" -ne 1 ]]; then
		
		CHOSEN_DIRECTORY=`chooseDirectory`
		COMMAND_TO_EXEC="./gradlew -p $CHOSEN_DIRECTORY clean build"

		eval $COMMAND_TO_EXEC
		
		#	Let's add this command to the history so we can do a quick ↑ to
		#	get back to it
		print -s $COMMAND_TO_EXEC
		
        return
    fi

	./gradlew -p "$1" clean build
}

gradleTestDir() {

	if [[ "$#" -ne 1 ]]; then
        ./gradlew -p `ls -d */ | fzf` clean test
        return
    fi

	./gradlew -p "$1" clean test
}

gitAddOleUpstream() {

	currentRemotes=$(git remote -v)

	currentRemotes=$( $currentRemotes )

	echo "Array count is ${currentRemotes[1]}"
	
	for i in "${currentRemotes[@]}"
	do
		echo "$i"
	done
}


#
#	Author:
#		Anthony Forsythe
#
#	Creation Date:
#		02-21-2019
#
#	Purpose:
#		To add a remote upstream to the file
#
#	Arguments:
#       $1: This is the URL of the upstream to be added. Do
#           not surround with quotes.
#	Sample:
#		gitur git@git.target.com:ole/inventory.git
#
function gitur() {

    if [ "$#" -ne 1 ]; then
        echo "You failed to provide enough arguments"
        return
    fi

    git remote add upstream "$@"
}

#
#	Author:
#		Anthony Forsythe
#
#	Creation Date:
#		04-25-2019
#
#	Purpose:
#		To throw away all code that is currently being worked on in a git repository.
#
#	Sample:
#		yeetCode
#
function yeetCode() {

	printf "                                                                                                                                 
                            ',,,,,,,,,,     ',,,,,,,,,. ,,,,,,,,,,,,,,,,,,.   ,,,,,,,,,,,,,,,,,,..,,,,,,,,,,,,,,,,,,,,,,,.                            
                            '@########W     +#########i n#################*   x#################ii#######################*                            
                             z#########.    n#########. n#################*   x#################ii#######################*                            
                             i#########;    W########x  n#################*   x#################ii#######################*                            
                             '#########+   .#########*  n#################*   x#################ii#######################*                            
                              x########n   ;#########,  n#################*   x#################ii#######################*                            
                              *########M   #########M   n#################*   x#################ii#######################*                            
                              ,########@'  x########+   n#################*   x#################ii#######################*                            
                               M########: '@########,   n##########xxxxxxx;   x##########xxxxxxx;;xxxxxx###########xxxxxx;                            
                               #########i ,########W    n##########:          x##########,              @#########@'                                  
                               :######### i#########    n##########,          x##########,              @#########@                                   
                               'W#######x #########:    n##########,          x##########,              @#########@                                   
                                z#######W x#######@'    n##########,          x##########,              @#########@                                   
                                ;########.@#######z     n##########,          x##########,              @#########@                                   
                                '@#######;########;     n##########,          x##########,              @#########@                                   
                                 x#######z#######@'     n##########,          x##########,              @#########@                                   
                                 *#######@#######n      n##########nzzzzzz'   x##########nzzzzzz        @#########@                                   
                                 .###############i      n################@'   x################@        @#########@                                   
                                  M#############@.      n################@'   x################@        @#########@                                   
                                  +#############x       n################@'   x################@        @#########@                                   
                                  :#############*       n################@'   x################@        @#########@                                   
                                  'W############.       n################@'   x################@        @#########@                                   
                                   z###########M        n################@'   x################@        @#########@                                   
                                   ;###########+        n##########@@@@@@W'   x##########@@@@@@W        @#########@                                   
                                   '@##########,        n##########:''''''    x##########,''''''        @#########@                                   
                                    n#########W         n##########,          x##########,              @#########@                                   
                                    +#########z         n##########,          x##########,              @#########@                                   
                                    +#########z         n##########,          x##########,              @#########@                                   
                                    +#########z         n##########,          x##########,              @#########@                                   
                                    +#########z         n##########,          x##########,              @#########@                                   
                                    +#########z         n##########,          x##########,              @#########@                                   
                                    +#########z         n##########,          x##########,              @#########@                                   
                                    +#########z         n##########i:::::::'  x##########;:::::::'      @#########@                                   
                                    +#########z         n##################,  x##################,      @#########@                                   
                                    +#########z         n##################,  x##################,      @#########@                                   
                                    +#########z         n##################,  x##################,      @#########@                                   
                                    +#########z         n##################,  x##################,      @#########@                                   
                                    +#########z         n##################,  x##################,      @#########@                                   
                                    +#########z         n##################,  x##################,      @#########@                                   
                                    +#########z         n##################,  x##################,      @#########@                                   
                                    innnnnnnnn*         +nnnnnnnnnnnnnnnnnn,  +nnnnnnnnnnnnnnnnnn.      znnnnnnnnnn                                   
	\n"

	git checkout -- .
}

#	Custom Jump Commands
#
#	Author:
#		Anthony Forsythe
#
#	Creation Date:
#		08-07-2020
#
#	Purpose:
#		Leverages `fzf` to help the user select a folder in the path provided to quickly jump to
#
#	Arguments:
#		1:	The directory container that directories that you want to list and jump into
#		2:	(optional) If this argument is `true` then the items in the list will only be
#			their basenames
#
#	Sample:
#		jump ~/favorite_folders
#		jump ~/favorite_folders true
#
jump() {

	if [[ "$#" = 2 && "$2" = true ]]; then
		JUMP_PATH_BASENAME=`ls -d $1/* | xargs basename | fzf`

		cs "$1/$JUMP_PATH_BASENAME"

		return
	fi

    JUMP_PATH=`ls -d $1/* | fzf`

    if [[ -z "$JUMP_PATH" ]]; then
		echo "No jump path found. Exiting."
		return 1
	fi

    cs "$JUMP_PATH"
}

oleJump🍊() {
    
	if [[ -z "$OLE_REPOS_DIRECTORY" ]]; then
			echo "The OLE_REPOS_DIRECTORY variable is not set!"
			echo "Exiting"
			return 1
	fi
	
	jump "$OLE_REPOS_DIRECTORY" true
}

favoritesJump() {

	if [[ -z "$FAVORITES_DIR" ]]; then
		echo "The FAVORITE_DIRECTORIES_LOCATION variable is not set!"
		echo "Exiting"
		return 1
	fi

	jump "$FAVORITES_DIR" true
}

#
#	Author:
#		Anthony Forsythe
#
#	Date Created:
#		04-02-2022
#
#	Purpose:
#	    Searches through command history using fzf and executes selction. Selection
#	    is then placed in the history for easy access with the up arrow key.
#
#	Example:
#	   historySearchAndRun 
#
historySearchAndRun() {

    #   First step is to find the command we want to run
    #   again
    COMMAND=$(history -n | fzf)

    echo "The command you want me to run -> ${COMMAND}"

    if [[ -z "$COMMAND" ]]; then
        echo "You did not select a command to re-run...exiting..."
        return
    fi

    #   Store the command in the history so we can do a quick
    #   ⬆ on the keyboard
    print -s $COMMAND
    eval $COMMAND
}

#
#	Author:
#		Anthony Forsythe
#
#	Date Created:
#		02-25-2020
#
#	Purpose:
#		Displays a selectable list of spec files to run using
#		`yarn test <SPEC FILE>`
#
#	Parameters:
#		$1 (Optional):
#			Pass anything (not including spaces) here to run all
#			tests
#
#	Example:
#		yarnTest
#		yarnTest literallyAnthing
#
yarnTest() {
	#	If the user passes in a single argument then
	#	run all tests
	if [[ "$#" -eq 1 ]]; then
		
		if [[ "$1" == "all" ]]; then
			echo "Will run all tests!"
			yarn test
			return 0
		fi

		TEST_TO_RUN=`fd $1 -espec.ts -espec.tsx | fzf`
		
	else
		TEST_TO_RUN=`fd -espec.ts -espec.tsx | fzf`
	fi

	if [[ -z "$TEST_TO_RUN" ]]; then
		echo "No spec file selected"
		echo "Quitting..."
		return 1
	fi

	yarn test $TEST_TO_RUN

	BASE_SHELL=`basename $SHELL`

	if [[ "$BASE_SHELL" == "zsh" ]]; then
		echo "Entering this command in your history for quick access"
		echo "Command -> yarn test $TEST_TO_RUN"
		print -s yarn test $TEST_TO_RUN
		return 0
	fi
}
