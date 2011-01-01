#!/bin/bash
# 
# title:        Supertight firewall
# author:       (c) 2010 Carlos Rodriguez <carlos@s8f.org>
# url:          http://s8f.org/software
# license:      LGPL
# 
# Sets up a restrictive firewall that only allows ssh and outgoing www/https,
# DNS to the nameserver, and log and drop all other traffic. This provides
# a good starting point for you to create a secure environment that prevents
# your server from being compromised, especially due to a reverse TCP
# connection.
#
# TESTED ONLY ON CentOS 5.x. May/not work on your version of Linux.
# Also MUST BE RUN AS ROOT.
#
# To log dropped traffic, put this at the end of your /etc/syslog.conf:
# 
# kern.=debug						/var/log/firewall
# 
# ..and restart your syslogd.
#
# Enjoy!

IPTABLES=`whereis iptables | awk '{print $2; exit}'`
if [ -z "$IPTABLES" ]; then
  echo "iptables not found on your system! Exiting."
  exit;
fi

LOGLIMIT="2/s"
LOGLIMITBURST="10"
NAMESERVER=`cat /etc/resolv.conf | grep -i nameserver | awk '{print $2; exit}'`
DROPCUSTOM=`$IPTABLES --list | grep INLOGDROP | wc -l`

$IPTABLES -P INPUT ACCEPT
$IPTABLES -F INPUT
$IPTABLES -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -A INPUT -s localhost -j ACCEPT
$IPTABLES -A INPUT -p tcp --dport ssh -j ACCEPT
$IPTABLES -P INPUT DROP

if [ "$DROPCUSTOM" -gt "0" ]; then
  $IPTABLES -F INLOGDROP
  $IPTABLES -X INLOGDROP
fi
$IPTABLES -N INLOGDROP
$IPTABLES -A INLOGDROP -p tcp -m limit --limit $LOGLIMIT --limit-burst $LOGLIMITBURST -j LOG --log-level 7 --log-prefix "TCP DROP INPUT: "
$IPTABLES -A INLOGDROP -p udp -m limit --limit $LOGLIMIT --limit-burst $LOGLIMITBURST -j LOG --log-level 7 --log-prefix "UDP DROP INPUT: "
$IPTABLES -A INLOGDROP -p icmp -m limit --limit $LOGLIMIT --limit-burst $LOGLIMITBURST -j LOG --log-level 7 --log-prefix "ICMP DROP INPUT: "
$IPTABLES -A INLOGDROP -f -m limit --limit $LOGLIMIT --limit-burst $LOGLIMITBURST -j LOG --log-level 7 --log-prefix "FRAGMENT DROP INPUT: "
$IPTABLES -A INLOGDROP -j DROP
$IPTABLES -A INPUT -p icmp -j INLOGDROP
$IPTABLES -A INPUT -p tcp -j INLOGDROP
$IPTABLES -A INPUT -p udp -j INLOGDROP

$IPTABLES -F FORWARD
$IPTABLES -P FORWARD DROP

$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -F OUTPUT
$IPTABLES -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -A OUTPUT -d localhost -j ACCEPT
$IPTABLES -P OUTPUT DROP
$IPTABLES -A OUTPUT -p tcp --dport 80 -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 443 -j ACCEPT
if [ -n "$NAMESERVER" ]; then
  $IPTABLES -A OUTPUT -p udp --dport 53 -d $NAMESERVER -j ACCEPT
fi

if [ "$DROPCUSTOM" -gt "0" ]; then
  $IPTABLES -F OUTLOGDROP
  $IPTABLES -X OUTLOGDROP
fi
$IPTABLES -N OUTLOGDROP
$IPTABLES -A OUTLOGDROP -p tcp -m limit --limit $LOGLIMIT --limit-burst $LOGLIMITBURST -j LOG --log-level 7 --log-prefix "TCP DROP OUTPUT: "
$IPTABLES -A OUTLOGDROP -p udp -m limit --limit $LOGLIMIT --limit-burst $LOGLIMITBURST -j LOG --log-level 7 --log-prefix "UDP DROP OUTPUT: "
$IPTABLES -A OUTLOGDROP -p icmp -m limit --limit $LOGLIMIT --limit-burst $LOGLIMITBURST -j LOG --log-level 7 --log-prefix "ICMP DROP OUTPUT: "
$IPTABLES -A OUTLOGDROP -f -m limit --limit $LOGLIMIT --limit-burst $LOGLIMITBURST -j LOG --log-level 7 --log-prefix "FRAGMENT DROP OUTPUT: "
$IPTABLES -A OUTLOGDROP -j DROP

$IPTABLES -A OUTPUT -p icmp -j OUTLOGDROP
$IPTABLES -A OUTPUT -p tcp -j OUTLOGDROP
$IPTABLES -A OUTPUT -p udp -j OUTLOGDROP

/sbin/service iptables save

# Done.
