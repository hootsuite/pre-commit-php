#!/bin/bash
################################################################################
#
# Bash PHP Copy Paste Detector
#
# This will prevent a commit if the tool has detected duplicate code
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
################################################################################

# Plugin title
title="PHP Copy Paste Detector"

# Possible command names of this tool
local_command="phpcpd.phar"
vendor_command="vendor/bin/phpcpd"
global_command="phpcpd"

# Print a welcome and locate the exec for this tool
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/helpers/colors.sh
source $DIR/helpers/formatters.sh
source $DIR/helpers/welcome.sh
source $DIR/helpers/locate.sh

# Build our list of files, and our list of args by testing if the argument is
# a valid path
args=""
files=""
for arg in ${*}
do
    if [ -e $arg ]; then
        files+=" $arg"
    else
        args+=" $arg"
    fi
done;

# Run the command with the full list of files
echo -e "${txtgrn}  $exec_command --no-interaction --ansi${args}${files}${txtrst}"
OUTPUT="$($exec_command${args}${files})"
RETURN=$?
if [ $RETURN -ne 0 ]; then
    echo -en "\n${txtylw}${title} found copied lines in the following files:${txtrst}\n  "
    echo -en "$OUTPUT" | awk -v m=3 -v n=2 'NR<=m{next};NR>n+m{print line[NR%n]};{line[NR%n]=$0}'
    echo -en "\n${bldred}Please review and commit.${txtrst}\n"
    exit 1
fi
exit 0
