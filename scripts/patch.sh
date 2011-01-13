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

## Parse arguments.
versus="master"
m_flag=
while getopts 'm:' OPTION
do
  case $OPTION in
  m)  m_flag=1
      message="$OPTARG"
        ;;
  ?)  printf "Usage: %s: [-m message] [<versus>]\n" $(basename $0) >&2
        exit 2
        ;;
  esac
done
shift $((OPTIND - 1))
if [ "$1" ]; then
  versus=$1;
fi

## Check for uncommitted changes which would be lost in the process.
git diff --exit-code --numstat > /dev/null
if [ $? -eq 1 ]; then
  echo "You have uncommitted changes. Please commit or stash them first."
  exit 1;
fi

## Get the current branch.
branch=`git branch | grep '*' | awk '{print $2; exit}'`
if [ $branch = $versus ]; then
  echo "Cannot diff $branch with itself. Please specify a <versus> different from the current branch."
  exit 1
fi

## Check for differences.
git diff --exit-code --numstat $versus > /dev/null
if [ $? -eq 0 ]; then
  echo "No differences with $versus found. Aborting."
  exit 1
fi

## Create a throwaway branch for merging.
git checkout -q -b patch_tmp $versus > /dev/null
## Squash history into a single commit.
git merge -q --squash $branch > /dev/null
if [ "$m_flag" ]; then
  git commit -q -a -m "$message"
else
  git commit -q -a
fi

## Create the patch.
git format-patch --no-prefix -1 -b -B --inter-hunk-context=20 --stdout
## Return to the original branch and clean up.
git checkout -q $branch
git branch -D patch_tmp > /dev/null
