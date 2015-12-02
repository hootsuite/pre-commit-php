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

# Echo Colors
msg_color_magenta='\e[1;35m'
msg_color_yellow='\e[0;33m'
msg_color_none='\e[0m' # No Color

# Loop through the list of paths to run PHP Code Beautifier and Fixer against
echo -en "${msg_color_yellow}Begin PHP Code Beautifier and Fixer ...${msg_color_none} \n"
phpcbf_local_exec="phpcbf.phar"
phpcbf_command="php $phpcbf_local_exec"

# Check vendor/bin/phpunit
phpcbf_vendor_command="vendor/bin/phpcbf"
phpcbf_global_command="phpcbf"
if [ -f "$phpcbf_vendor_command" ]; then
	phpcbf_command=$phpcbf_vendor_command
else
    if hash phpcbf 2>/dev/null; then
        phpcbf_command=$phpcbf_global_command
    else
        if [ -f "$phpcbf_local_exec" ]; then
            phpcbf_command=$phpcbf_command
        else
            echo "No valid PHP Code Beautifier and Fixer executable found! Please have one available as either $phpcbf_vendor_command, $phpcbf_global_command or $phpcbf_local_exec"
            exit 1
        fi
    fi
fi

phpcbf_files_to_check="${@:2}"
phpcbf_args=$1
# Without this escape field, the parameters would break if there was a comma in it
phpcbf_command="$phpcbf_command $phpcbf_args $phpcbf_files_to_check"

echo "Running command $phpcbf_command"
command_result=`eval $phpcbf_command`
if [[ $command_result =~ ERROR ]]
then
    echo -en "${msg_color_magenta}Errors detected by PHP Code Beautifier and Fixer ... ${msg_color_none} \n"
    echo "$command_result"
    exit 1
fi

exit 0
