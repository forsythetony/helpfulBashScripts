#/bin/bash

cdl()
{
	if [ "$#" -ne 1 ]; then
		
		echo "Illegal number of parameters"
		
		exit
		
	fi
	
	if [[ "$1" == *"."* ]]; then
	
		echo "Illegal character in folder name"
		
		exit
		
	fi
		
	cd "$1"
	
	target="./"
	
	if test "$(ls -A "$target")"; then
	    ll
	else
	    echo The directory $target is empty '(or non-existent)'
	fi
}

mcd()
{
	if [ $# -ne 1 ]; then
		exit
	fi
	
	if [[ ! "$1" =~ [^0-9a-z-] ]] ; then  
	    echo "Valid String"; 
	else 
		echo "String not valid";
		exit
	fi
	
	mkdir -p "$1"
	
	if [ $? -ne 0 ] ; then
	    echo "Directory not created.";
	    exit
	else
	
		echo "Directory created";
		cd "$1";
		pwd;
		ll;
	fi
}

up()
{
	cd ..
	ll;
}


oi()
{
	if [ $# -ne 1 ]; then
		exit
	fi
	
	if [[ "$1" =~ ^".*"$ ]]; then
		git commit -am "$1"
	else
		exit
	fi
	
	


}