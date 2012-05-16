#!/bin/bash

# Prevent annoying sounds during boot.
sleep 30

DOWN=0
while true; do
  # Ping something every 5 seconds
  if ! ping -w 5 208.67.222.222 >/dev/null; then
    # Freak out!
    if [ "$DOWN" -eq "0" ]; then
      # Play sound if not already playing.
      DISPLAY=:0 notify-send 'Internet down!' 'You hear eerie whistling...'
      play -q /home/carlos8f/projects/s8f.org/scripts/xfiles.wav repeat 10 &
    else
      DISPLAY=:0  notify-send 'Internet down!' 'Time to get some coffee...'
    fi
    logger 'Internet down!'
    DOWN=1
  elif [ $DOWN -eq 1 ]; then
    # Stop playing if we are still playing.
    killall play
    DOWN=0
  fi
  sleep 5
done
