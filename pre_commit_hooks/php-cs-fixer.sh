#!/usr/bin/env bash
################################################################################
#
# Bash PHP Coding Standards Fixer
#
# This will prevent a commit if the tool has made changes to the files. This
# allows a develop to look at the diff and make changes before doing the
# commit.
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
# Arguments
# - None
#
################################################################################

# Plugin title
title="PHP Code Fixer"

# Possible command names of this tool
local_command="php-cs-fixer.phar"
vendor_command="vendor/bin/php-cs-fixer"
global_command="php-cs-fixer"

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
echo -e "${txtgrn}  $exec_command fix${args}${txtrst}"
php_errors_found=false
error_message=""
for path in "${files[@]}"
do
    ${exec_command} fix${args} ${path} 1> /dev/null
    if [ $? -ne 0 ]; then
        error_message+="  - ${txtylw}${path}${txtrst}\n"
        php_errors_found=true
    fi
done;

# There is currently debate about exit codes in php-cs-fixer
# https://github.com/FriendsOfPHP/PHP-CS-Fixer/issues/1211
if [ "$php_errors_found" = true ]; then
    echo -en "\n${txtylw}${title} updated the following files:${txtrst}\n"
    echo -en "${error_message}"
    echo -en "\n${bldred}Please review and commit.${txtrst}\n"
    exit 1
fi

exit 0
