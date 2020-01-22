#!/bin/bash

#   Grab the current directory

if [[ -z "$CUSTOM_BASH_SCRIPTS_DIR" ]]; then
    echo "You need to set the CUSTOM_BASH_SCRIPTS_DIR variable in the shell"
    echo "Exiting"
    return 1
fi


#   ALIASES
#
#   Note:
#       Aliases should be loaded first because some functions may depend
#       on them
echo "Sourcing custom aliases"
source "$CUSTOM_BASH_SCRIPTS_DIR/Aliases/aliases.sh"

#   FUNCTIONS
echo "Sourcing custom functions"
source "$CUSTOM_BASH_SCRIPTS_DIR/Functions/functions.sh"

#   COLORS
echo "Sourcing custom color functions"
source "$CUSTOM_BASH_SCRIPTS_DIR/Colors/colors.sh"