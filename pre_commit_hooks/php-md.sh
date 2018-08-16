#!/bin/bash
################################################################################
#
# Bash PHP Mess Detector
#
# This will prevent a commit if the tool has detected violations of the
# rulesets specified
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
################################################################################

# Plugin title
title="PHP Mess Detector"

# Possible command names of this tool
local_command="phpmd.phar"
vendor_command="vendor/bin/phpmd"
global_command="phpmd"

# Print a welcome and locate the exec for this tool
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/helpers/colors.sh
source $DIR/helpers/formatters.sh
source $DIR/helpers/welcome.sh
source $DIR/helpers/locate.sh

# Build our list of files, and our list of args by testing if the argument is
# a valid path
args=""
files=()
for arg in ${*}
do
    if [ -e $arg ]; then
        files+=("$arg")
    else
        args+=" $arg"
    fi
done;

# Run the command on each file
echo -e "${txtgrn}  $exec_command${args}${txtrst}"
php_errors_found=false
error_message=""
for path in "${files[@]}"
do
    OUTPUT="$(${exec_command} ${path} text ${args})"
    RETURN=$?
    if [ $RETURN -eq 1 ]; then
        # Return 1 means that PHPMD crashed
        error_message+="  - ${bldred}PHPMD failed to evaluate ${path}${txtrst}"
        error_message+="${OUTPUT}\n\n"
        php_errors_found=true
    elif [ $RETURN -eq 2 ]; then
        # Return 2 means it ran successfully, but found issues.
        # Using perl regex to clean up PHPMD output, trimming out full file
        # paths that are included in each line
        error_message+="  - ${txtylw}${path}${txtrst}"
        error_message+="$(echo $OUTPUT | perl -pe "s/(\/.*?${path}:)/\n    line /gm")"
        error_message+="\n\n"
        php_errors_found=true
    fi
done;

if [ "$php_errors_found" = true ]; then
    echo -en "\n${txtylw}${title} found issues in the following files:${txtrst}\n\n"
    echo -en "${error_message}"
    echo -en "${bldred}Please review and commit.${txtrst}\n"
    exit 1
fi

exit 0
