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
diff_opts="--no-prefix --patch-with-stat"
command_index=0
commit="HEAD"
diff_upto="..working copy"
log_upto="..HEAD"

## Parse arguments.
for arg in "$@"
do
  if [[ "$arg" == -* ]]; then
    if [ "$arg" = "-m" ]; then
      capture_message=1
    else
      diff_opts="$diff_opts $arg"
    fi
  elif [ $capture_message -eq 1 ]; then
    message=$arg
    capture_message=0
  else
    if [ $command_index -eq 0 ]; then
      commit=$arg
    else
      diff_upto="..$arg"
      log_upto="..$arg"
    fi
    let "command_index+=1"
  fi
  shift
done

echo

## Output and clean up targets
echo -e " Patch:    $commit$diff_upto\n"
if [ "$diff_upto" = "..working copy" ]; then
  diff_upto=""
fi

## Output From: line
user_name=`git config --get user.name`
user_email=`git config --get user.email`
if [ -n "$user_name" ]; then
  echo -n " From:     $user_name"
  if [ -n "$user_email" ]; then
    echo -n " <$user_email>"
  fi
  echo -e "\n"
fi

if [ -n "$message" ]; then
  echo -n " Subject:  "
  echo "$message" | head -n 1
  echo "$message" | sed 1d | sed -e 's/^/           /g'
  echo
fi

## Output cute commit log
commits=`git log --oneline --abbrev $commit$log_upto`
if [ -n "$commits" ]; then
  echo -n " Log:      "
  echo "$commits" | head -n 1
  echo "$commits" | sed 1d | sed -e 's/^/           /g'
  echo
fi



git diff $commit$diff_upto $diff_opts
