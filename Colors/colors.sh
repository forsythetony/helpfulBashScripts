
#
#	Author:
#		Jeff Schaller
#
#	Creation Date:
#		02-04-2018
#
#	Purpose:
#		Will create a header that will be used for a color display
#		chart 
#	Sample:
#		mode2header
#
#	Credit:
#		This function was created by user Jeff Schaller on StackOverflow
#		https://unix.stackexchange.com/a/269085
mode2header(){
    #### For 16 Million colors use \e[0;38;2;R;G;Bm each RGB is {0..255}
    printf '\e[mR\n' # reset the colors.
    printf '\n\e[m%59s\n' "Some samples of colors for r;g;b. Each one may be 000..255"
    printf '\e[m%59s\n'   "for the ansi option: \e[0;38;2;r;g;bm or \e[0;48;2;r;g;bm :"
}

#
#	Author:
#		Jeff Schaller
#
#	Creation Date:
#		02-04-2018
#
#	Purpose:
#		Will actually create the chart that is used. Without a header
#
#	Sample:
#		mode2colors 3
#
#	Credit:
#		This function was created by user Jeff Schaller on StackOverflow
#		https://unix.stackexchange.com/a/269085
mode2colors(){
    # foreground or background (only 3 or 4 are accepted)
    local fb="$1"
    [[ $fb != 3 ]] && fb=4
    local samples=(0 63 127 191 255)
    for         r in "${samples[@]}"; do
        for     g in "${samples[@]}"; do
            for b in "${samples[@]}"; do
                printf '\e[0;%s8;2;%s;%s;%sm%03d;%03d;%03d ' "$fb" "$r" "$g" "$b" "$r" "$g" "$b"
            done; printf '\e[m\n'
        done; printf '\e[m'
    done; printf '\e[mReset\n'
}

#
#	Author:
#		Anthony Forsythe
#
#	Creation Date:
#		02-06-2019
#
#	Purpose:
#		Displays the full color chart for the current system.
#       Will print a chart for both the foreground and the
#       background
#
#	Sample:
#       printFullColorChart		
#
printFullColorChart() {
    mode2header
    mode2colors 3
    mode2colors 4
}

#
#	Author:
#		Jeff Schaller
#
#	Creation Date:
#		02-04-2018
#
#	Purpose:
#		Will convert a given hex value to the nearest terminal supported
#       color. Is usually used with the `tput setaf` command in the form
#       `tput setaf $(fromHex ffffff)`
#
#	Sample:
#		fromHex 3
#       BLUE_COLOR=$(tput setaf $(fromHex 0000FF))
#
#	Credit:
#		This function was created by user Jeff Schaller on StackOverflow
#		https://unix.stackexchange.com/a/269085
fromHex(){
    hex=${1#"#"}
    r=$(printf '0x%0.2s' "$hex")
    g=$(printf '0x%0.2s' ${hex#??})
    b=$(printf '0x%0.2s' ${hex#????})
    printf '%03d' "$(( (r<75?0:(r-35)/40)*6*6 + 
                       (g<75?0:(g-35)/40)*6   +
                       (b<75?0:(b-35)/40)     + 16 ))"
}

#
#	Author:
#		Anthony Forsythe
#
#	Creation Date:
#		02-07-2019
#
#	Purpose:
#		When provided with the RGB components of a color this function
#       will print out the string necessary to change a printout to that
#       color for the foreground text
#
#	Arguments:
#       $1: The color's red component (value 0-255)
#       
#       $2: The color's blue component (value 0-255)
#
#       $3: The color's green component (value 0-255)
#
#	Sample:
#       foregroundColorFromRGB 43 100 255       		
#
#   Credit:
#       The 'printf' component of this function was created by user
#       Jeff Schaller on StackOverflow
#       https://unix.stackexchange.com/a/269085
#
foregroundColorFromRGB() {

    #   Make sure that we have exactly three arguments. The
    #   R G B components of the color
    if [ "$#" -ne 3 ]; then
        echo "You didn't pass enough arguments!"
        return
    fi

    RED=$1
    BLUE=$2
    GREEN=$3

    echo "\e[0;38;2;${RED};${BLUE};${GREEN}m"
}

#
#	Author:
#		Anthony Forsythe
#
#	Creation Date:
#		02-06-2019
#
#	Purpose:
#		This should serve as a list that will export colors to
#       global variables that can be used wherever.
#
#	Sample:
#		exportAllColors
#   
exportAllColors() {

    export COLOR_NORMAL=$(tput sgr0)
    eCOLOR_BLUE=$(tput setaf $(fromHex 0000ff))
}


#   When this script is sourced make sure to export all the colors
#   that we have set
exportAllColors


