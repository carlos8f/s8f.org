#!/bin/bash
while true; do
  if ! ping -w 5 208.67.222.222 >/dev/null; then
    play -q /home/carlos8f/projects/s8f.org/scripts/alert.wav
    logger 'Internet down!'
  fi
  sleep 5
done
