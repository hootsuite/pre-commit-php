#!/bin/bash

# Bash PHP Unit Task Runner
#
# php-unit command is run via composer run command
# so you can for example execute php-unit via a docker container
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
# Arguments
# - : Your custom phpunit command

# Echo Colors
msg_color_magenta='\e[1;35m'
msg_color_yellow='\e[0;33m'
msg_color_none='\e[0m' # No Color

# Check if a custom phpunit command was provided as argument
phpunit_custom_command=$1;

# Loop through the list of paths to run phpunit against
echo -en "${msg_color_yellow}Begin PHP Unit Task Runner ...${msg_color_none} \n"

if [ "$phpunit_custom_command" = "" ]; then
  phpunit_local_exec="phpunit.phar"
  phpunit_command="php $phpunit_local_exec"

  # Check vendor/bin/phpunit
  phpunit_vendor_command="vendor/bin/phpunit"
  phpunit_global_command="phpunit"
  if [ -f "$phpunit_vendor_command" ]; then
    phpunit_command=$phpunit_vendor_command
  else
    if hash phpunit 2>/dev/null; then
      phpunit_command=$phpunit_global_command
    else
      if [ -f "$phpunit_local_exec" ]; then
        phpunit_command=$phpunit_command
      else
        echo "No valid PHP Unit executable found! Please have one available as either $phpunit_vendor_command, $phpunit_global_command or $phpunit_local_exec"
        exit 1
      fi
    fi
  fi
else
  phpunit_command=$phpunit_custom_command
fi

echo "Running command $phpunit_command"
command_result=`eval $phpunit_command`
if [[ $command_result =~ FAILURES ]]
then
  echo "Failures detected in unit tests..."
  echo "$command_result"
  exit 1
fi
exit 0
