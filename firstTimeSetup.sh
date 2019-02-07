
#   This function will ask a user where they want to source a custom
#   .bash_profile file from
readCustomBashProfileLink() {

    echo "Where should the .bash_profile be sourced from?"
    
    read SOURCING_BASH_FILE

    #   Make sure that the given file actually exists
    if [ ! -f "$SOURCING_BASH_FILE" ]; then
        echo "The file ($SOURCING_BASH_FILE) that you are trying to source the .bash_profile from does not exist!"
        echo "Quitting now"
        return 1
    fi

    #   Make sure that the given file can be written to
    if [ ! -w "$SOURCING_BASH_FILE" ]; then
        echo "The file ($SOURCING_BASH_FILE) cannot be written to!"
        echo "Quitting now"
        return 2
    fi

    #   Just a sanity check but need to make sure that the 'DEFAULT_BASH_PROFILE_PATH'
    #   is set. Its setting is dependent on the order of calls in the main script so
    #   there is a slight chance it could not get called.
    if [ -z "$DEFAULT_BASH_PROFILE_PATH" ]; then
        echo "The default bash profile path has not been set. Something went wrong (╯°□°）╯︵ ( . 0 .)"
        echo "Quitting now"
        return 3
    fi

    #   Create the .bash_profile if the file does not already exist.
    #   NOTE:
    #       In the context of this script this really shouldn't happen
    #       because the only way to get here is if the .bash_profile does
    #       not exist.
    if [ -f $DEFAULT_BASH_PROFILE_PATH ]; then
        touch $DEFAULT_BASH_PROFILE_PATH
    fi

    #   Now we're going to actually write the sourcing command to the the sourcing
    #   bash file that was given by the user
    printf "\n\n" >> $SOURCING_BASH_FILE
    printf "if [ -f $DEFAULT_BASH_PROFILE_PATH ]; then" >> $SOURCING_BASH_FILE
    printf "\n\tsource $DEFAULT_BASH_PROFILE_PATH" >> $SOURCING_BASH_FILE
    printf "\nfi" >> $SOURCING_BASH_FILE
}

#   Let's make sure there is a .bash_profile already there
BASH_PROFILE_NAME=".bash_profile"
DEFAULT_BASH_PROFILE_PATH="$HOME/$BASH_PROFILE_NAME"

#   Let's see if the .bash_profile exists. If it does not we will have
#   to create it and ask the user where they wish to source it from
if [ ! -f $DEFAULT_BASH_PROFILE_PATH ]; then
    #   The file does not exist. Let's ask the user a question...
    readCustomBashProfileLink
fi

#   At this point we should have a .bash_profile that exists and is
#   pointed to by the $DEFAULT_BASH_PROFILE_PATH var

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#   We will be sourcing by referencing the 'grouped.sh' script in this directory
GROUPED_PATH="$SCRIPT_DIR/grouped.sh"

CURR_DATE=$(date)

printf "\n#\tHelper functions file linked on $CURR_DATE" >> $DEFAULT_BASH_PROFILE_PATH
printf "\nif [ -f $GROUPED_PATH ]; then" >> $DEFAULT_BASH_PROFILE_PATH
printf "\n\tsource $GROUPED_PATH" >> $DEFAULT_BASH_PROFILE_PATH
printf "\nfi\n" >> $DEFAULT_BASH_PROFILE_PATH

source $GROUPED_PATH

bashreload