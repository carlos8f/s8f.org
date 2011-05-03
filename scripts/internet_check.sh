#!/bin/bash
while true; do
  if ! ping -c 1 -q 208.67.222.222 >/dev/null; then
    play -q alert.wav
  fi
  sleep 15
done
