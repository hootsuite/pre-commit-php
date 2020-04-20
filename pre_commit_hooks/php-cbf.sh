#!/bin/bash

# Bash PHP Code Beautifier and Fixer Hook
# This script fails if the PHP Code Beautifier and Fixer output has the word "ERROR" in it.
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
title="PHP Code Beautifier and Fixer"

# Possible command names of this tool
local_command="phpcbf.phar"
vendor_command="vendor/bin/phpcbf"
global_command="phpcbf"

# Print a welcome and locate the exec for this tool
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/helpers/colors.sh
source $DIR/helpers/formatters.sh
source $DIR/helpers/welcome.sh
source $DIR/helpers/locate.sh

# Loop through the list of paths to run PHP Code Beautifier and Fixer against

phpcbf_files_to_check="${@:2}"
phpcbf_args=$1
# Without this escape field, the parameters would break if there was a comma in it
phpcbf_command="${exec_command} ${phpcbf_args} ${phpcbf_files_to_check}"

echo -e "${bldwht}Running command ${txtgrn} $phpcbf_command${txtrst}"
command_result=`eval $phpcbf_command`
if [[ $command_result =~ ERROR ]]
then
    hr
    echo -en "${bldmag}Errors detected by PHP Code Beautifier and Fixer ... ${txtrst} \n"
    hr
    echo "$command_result"
    exit 1
fi

exit 0
