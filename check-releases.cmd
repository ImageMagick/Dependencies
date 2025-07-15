@echo off

call .github\build\windows\find-bash.cmd

set LC_ALL=en_US.utf8
%BASH% -c "./check-releases.sh"
