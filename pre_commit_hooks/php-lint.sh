#!/bin/bash

# Bash PHP Linter for Pre-commits
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
# Arguments
# -s : When to stop checking for errors
#      all   : Default. Will check ALL given files until there isn't anymore
#      first : Will stop checking when it encounters the first file that has an error
#
#      Example
#      -s first
#      -s all

# Check Flags - denotes if we should check all files or stop at the first error file
check_args_flag_all='all'
check_args_flag_first='first'
check_all=true

# Echo Colors
msg_color_magenta='\e[1;35m'
msg_color_yellow='\e[0;33m'
msg_color_none='\e[0m' # No Color

# Where to stop looking for file paths in the argument list
arg_lookup_start=1

# Flag to denote if a PHP error was found
php_errors_found=false

# Figure out if options were passed
while getopts ":s:" optname
  do
    case "$optname" in
      "s")
        arg_lookup_start=2
        if [ $OPTARG == $check_args_flag_first ]; then
            check_all=false
        elif [ $OPTARG == $check_args_flag_all ]; then
            check_all=true
        else
            check_all=true
        fi
        ;;
    esac
  done

# Loop through the list of paths to run php lint against
echo -en "${msg_color_yellow}Begin PHP Linter ...${msg_color_none} \n"

parse_error_count=0
for path in ${*:$arg_lookup_start}
do
    php -l "$path" 1> /dev/null
    if [ $? -ne 0 ]; then
#        echo "PHP Parse errors were detected" >&2
        parse_error_count=$[$parse_error_count +1]
        php_errors_found=true
        if [ "$check_all" = false ]; then
            echo "Stopping at the first file with PHP Parse errors"
            exit 1
        fi
    fi
done;

if [ "$php_errors_found" = true ]; then
    echo -en "${msg_color_magenta}$parse_error_count${msg_color_none} ${msg_color_yellow}PHP Parse error(s) were found!${msg_color_none} \n"
    exit 1
fi

exit 0