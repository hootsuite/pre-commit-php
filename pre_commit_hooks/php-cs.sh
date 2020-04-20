#!/bin/bash

# Bash PHP Codesniffer Hook
# This script fails if the PHP Codesniffer output has the word "ERROR" in it.
# Does not support failing on WARNING AND ERROR at the same time.
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
# Arguments
# - None

# Plugin title
title="PHP Codesniffer"

# Possible command names of this tool
local_command="phpcs.phar"
vendor_command="vendor/bin/phpcs"
global_command="phpcs"

# Print a welcome and locate the exec for this tool
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/helpers/colors.sh
source $DIR/helpers/formatters.sh
source $DIR/helpers/welcome.sh
source $DIR/helpers/locate.sh

phpcs_files_to_check="${@:2}"
phpcs_args=$1
phpcs_command="${exec_command} ${phpcs_args} ${phpcs_files_to_check}"

echo -e "${bldwht}Running command ${txtgrn}$phpcs_command${txtrst}"
command_result=`eval $phpcs_command`
if [[ $command_result =~ ERROR ]]
then
    hr
    echo -en "${bldmag}Errors detected by PHP CodeSniffer ... ${txtrst} \n"
    hr
    echo "$command_result"
    exit 1
fi

exit 0
