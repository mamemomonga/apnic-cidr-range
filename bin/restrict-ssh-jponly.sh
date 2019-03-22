#!/bin/bash
set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
IPTABLES="iptables"

$IPTABLES -t filter -P INPUT    DROP
$IPTABLES -t filter -P OUTPUT   ACCEPT
$IPTABLES -t filter -P FORWARD  DROP
$IPTABLES -t nat -P PREROUTING  ACCEPT
$IPTABLES -t nat -P POSTROUTING ACCEPT
$IPTABLES -t nat -P OUTPUT      ACCEPT

$IPTABLES -A INPUT   -i lo -j ACCEPT
$IPTABLES -A FORWARD -i lo -j ACCEPT

$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

$IPTABLES -D COUNTRY > /dev/null 2>&1
$IPTABLES -N COUNTRY
$BASEDIR/bin/apply-iptables.pl JP eth0 COUNTRY
$IPTABLES -A COUNTRY -p tcp --dport 22 --syn -j ACCEPT

