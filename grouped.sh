#!/bin/bash

#   Grab the current directory
CURRENT_DIR=`dirname "$0"`

DEBUG=false

#   ALIASES
#
#   Note:
#       Aliases should be loaded first because some functions may depend
#       on them
if $DEBUG; then echo "Sourcing custom aliases"; fi
source "$CURRENT_DIR/Aliases/aliases.sh"

#   FUNCTIONS
if $DEBUG; then echo "Sourcing custom functions"; fi
source "$CURRENT_DIR/Functions/functions.sh"

#   COLORS
if $DEBUG; then echo "Sourcing custom color functions"; fi
source "$CURRENT_DIR/Colors/colors.sh"

if $DEBUG; then echo "Done source all helpers from helpfulBashScripts"; fi