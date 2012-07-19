#!/usr/bin/env bash

AGENT_KEY=$1
if [ -z "$AGENT_KEY" ]
then
  echo "usage: sudo $0 agent_key [sd_url]"
  exit 1
fi
SD_URL="http://terraeclipse.serverdensity.com"
if [ -n "$2" ]
then
  SD_URL="$2"
fi
SD_URL=`echo "$SD_URL" | sed -e 's/\([[\\/.*]\\|\\]\\)/\\\\&/g'`

wget -q https://www.serverdensity.com/downloads/boxedice-public.key -O- | sudo apt-key add -
echo "deb http://www.serverdensity.com/downloads/linux/deb all main" > /etc/apt/sources.list.d/sd-agent.list
apt-get update
apt-get install sd-agent -y
sudo sed -e "s/sd_url:.*/sd_url: $SD_URL" -e "s/agent_key:.*/agent_key: $AGENT_KEY/" -i.backup /etc/sd-agent/config.cfg
service sd-agent restart