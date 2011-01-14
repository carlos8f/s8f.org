#!/usr/bin/env bash
#
# patch.sh -- a patch creation script for git.
#
# description: Creates a single patch of the changes between the
# current branch and <versus>, with a pretty header and diffstat,
# and sends it to the standard output.
#
# author: Carlos Rodriguez <carlos@s8f.org>
# url: http://s8f.org/software
# license: MIT

message=""
capture_message=0
diff_opts=""
log_opts=""

## Parse arguments.
for arg in "$@"
do
  if [[ $arg == -* ]]; then
    if [ $arg = "-m" ]; then
      capture_message=1
    else
      diff_opts="$diff_opts $arg"
    fi
  elif [ $capture_message -eq 1 ]; then
    message=$arg
    capture_message=0
  else
    log_opts="$log_opts $arg"
  fi
  shift
done

git log --pretty=oneline $log_opts
