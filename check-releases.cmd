@echo off

call .github\build\windows\find-bash.cmd

%BASH% -c "./check-releases.sh"
