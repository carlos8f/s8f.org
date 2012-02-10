#!/bin/bash
DOWN=0
while true; do
  if ! ping -w 5 208.67.222.222 >/dev/null; then
    if [ $DOWN -eq 0 ]; then
      play -q /home/carlos8f/projects/s8f.org/scripts/xfiles.wav repeat 10 &
    fi
    logger 'Internet down!'
    DOWN=1
  elif [ $DOWN -eq 1 ]; then
    killall play
    DOWN=0
  fi
  sleep 5
done
