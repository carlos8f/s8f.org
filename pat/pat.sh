#!/bin/bash

## Check for uncommitted changes which would be lost in the process.
git diff --exit-code --numstat >/dev/null
if [ $? -eq 1 ]; then
  echo "You have uncommitted changes. Please commit or stash them before running pat.sh."
  exit 1;
fi

## Get the current branch and starting point.
branch=`git branch | grep '*' | awk '{print $2; exit}'`
remote="master"
if [ -z "$1" ]; then
  echo "Usage: pat.sh <patch description> [<versus>]"
  exit 1
fi
if [ $2 ]; then
  remote=$2
fi;
if [ $branch = $remote ]; then
  echo "Cannot diff $branch with itself. Please specify a <versus> different from the current branch."
  exit 1
fi

## Check for differences.
git diff --exit-code --numstat $remote >/dev/null
if [ $? -eq 0 ]; then
  echo "No differences with $remote found. Aborting."
  exit 1
fi

## Create a throwaway branch for merging.
git checkout -q -b pat_tmp $remote >/dev/null
## Squash history into a single commit.
git merge -q --squash $branch >/dev/null
git commit -q -a -m "$1"
## Create the patch.
git format-patch --no-prefix -1 -b -B --inter-hunk-context=20 --stdout
## Return to the original branch and clean up.
git checkout -q $branch
git branch -D pat_tmp >/dev/null