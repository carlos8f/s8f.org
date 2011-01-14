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

from=""
message=""
capture_from=0
capture_message=0
diff_opts="--no-prefix"
command_index=0
commit="HEAD"
diff_upto="..working copy"
log_upto="..HEAD"

## Settable options
show_args=0
show_from=1
show_email=0
show_log=1
show_stat=1
pad_top=1
attribution=1

## Support functions

show_help() {
  echo
  echo "patch.sh -- a patch creation script for git."
  echo "(c) 2011 Carlos Rodriguez <carlos8f>, MIT License"
  echo "http://s8f.org/software"
  echo
  echo "Usage: patch.sh [-m <message>] [<options>] [<commit>] [<up to commit>]"
  echo
  echo "    -m|--subject|--message  Include a Subject: line in the header."
  echo "          --no-attribution  Skip attribution line at the end."
  echo "             --banner=file  Display a banner in the patch header."
  echo "              -v|--verbose  Show Patch: line with diff targets."
  echo "              -f|-F|--from  Specify From: line."
  echo "              --show-email  Show email in From: line."
  echo "                 --no-from  Hide From: line."
  echo "                 --no-stat  Hide diffstat."
  echo "                  --no-log  Hide commit log."
  echo "                  --no-pad  Don't pad the patch top with a newline."
  echo
  echo "You may also specify any option that git-diff takes."
  echo
  exit
}

## Parse arguments.
for arg in "$@"
do
  if [[ "$arg" == -* ]]; then
    case $arg in
      --help|-h)
        show_help
        ;;
      -m)
        capture_message=1
        ;;
      --subject=*|--message=*)
        message=${arg:10}
        ;;
      -v|--verbose)
        show_args=1
        ;;
      --from=*)
        from=${arg:7}
        ;;
      -f|-F)
        capture_from=1
        ;;
      --no-from)
        show_from=0
        ;;
      --no-email)
        show_email=0
        ;;
      --show-email)
        show_email=1
        ;;
      --no-log)
        show_log=0
        ;;
      --no-stat)
        show_stat=0
        ;;
      --no-pad)
        pad_top=0
        ;;
      --no-attribution)
        attribution=0
        ;;
      --banner=*)
        banner="${arg:9}"
        if [ ! -f "$banner" ]; then
          echo "Banner file not found: $banner"
          exit 1
        fi
        ;;
      *)
        diff_opts="$diff_opts $arg"
        ;;
    esac
  elif [ $capture_message -eq 1 ]; then
    message=$arg
    capture_message=0
  elif [ $capture_from -eq 1 ]; then
    from="$arg"
    capture_from=0
  else
    if [ $command_index -eq 0 ]; then
      commit=$arg
    else
      diff_upto="..$arg"
      log_upto="..$arg"
    fi
    let "command_index+=1"
  fi
done

if [ $pad_top -eq 1 ]; then
  ## Pad the top.
  echo
fi

if [ -n "$banner" ]; then
  cat $banner | sed -e 's/^/ /g'
  echo
fi

if [ $show_args -eq 1 ]; then
  ## Output targets.
  echo -e " Patch:    $commit$diff_upto\n"
fi
## Make target machine-readable again.
if [ "$diff_upto" = "..working copy" ]; then
  diff_upto=""
fi

if [ $show_from -eq 1 ]; then
  ## Output "From:" line.
  if [ -z "$from" ]; then
    user_name=`git config --get user.name`
    email=`git config --get user.email`
    if [ -n "$user_name" ]; then
      from="$user_name"
      if [ $show_email -eq 1 -a -n "$email" ]; then
        from="$from <$email>"
      fi
    fi
  fi
  if [ -n "$from" ]; then
    echo -e " From:     $from\n"
  fi
fi

if [ -n "$message" ]; then
  echo -n " Subject:  "
  echo "$message" | head -n 1
  echo "$message" | sed 1d | sed -e 's/^/           /g'
  echo
fi

if [ $show_log -eq 1 ]; then
  ## Output cute commit log.
  commits=`git log --oneline --abbrev $commit$log_upto`
  if [ -n "$commits" ]; then
    echo -n " Log:      "
    echo "$commits" | head -n 1
    echo "$commits" | sed 1d | sed -e 's/^/           /g'
    echo
  fi
fi

if [ $show_stat -eq 1 ]; then
  diff_opts="$diff_opts --patch-with-stat"
fi

## Output the patch, finally.
git diff $commit$diff_upto $diff_opts

if [ $attribution -eq 1 ]; then
  ## Output attribution.
  echo -e "---\nGenerated with http://s8f.org/patch.sh"
fi
