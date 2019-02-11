#!/bin/bash

#   Grab the current directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#   ALIASES
#
#   Note:
#       Aliases should be loaded first because some functions may depend
#       on them
echo "Sourcing custom aliases"
source "$SCRIPT_DIR/Aliases/aliases.sh"

#   FUNCTIONS
echo "Sourcing custom functions"
source "$SCRIPT_DIR/Functions/functions.sh"

#   COLORS
echo "Sourcing custom color functions"
source "$SCRIPT_DIR/Colors/colors.sh"