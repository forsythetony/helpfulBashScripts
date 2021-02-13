#!/bin/bash

#   Grab the current directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#   ALIASES
#
#   Note:
#       Aliases should be loaded first because some functions may depend
#       on them
echo "Sourcing custom aliases"
source "$CURRENT_DIR/Aliases/aliases.sh"

#   FUNCTIONS
echo "Sourcing custom functions"
source "$CURRENT_DIR/Functions/functions.sh"

#   COLORS
echo "Sourcing custom color functions"
source "$CURRENT_DIR/Colors/colors.sh"