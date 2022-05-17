#!/bin/bash

# Installation:
#
# 1.   nano /etc/ssh/sshd_config
#      PrintMotd no
#
# 2.   nano /etc/profile
#      /usr/bin/dynmotd # Place at the bottom
#
# 3.   Then of course drop this file at
#      /usr/bin/dynmotd
#
# 4.   Enter here your temperature device:
#       an example it is for me "cpu_thermal-virtual-0"
#

# config
sensor="cpu_thermal-virtual-0"


USER=`whoami`
HOSTNAME=`uname -n`
ROOT=`df -Ph / | grep / | awk '{print $4}' | tr -d '\n'`
HOME=`df -Ph | grep home | awk '{print $4}' | tr -d '\n'`
BACKUP=`df -Ph | grep backup | awk '{print $4}' | tr -d '\n'`
MNT=`df -Ph | grep mnt | awk '{print $4}' | tr -d '\n'`
TEMPERATURE=`sensors $sensor | tail -n +3 | cut -d' ' -f2- | xargs`  # please look line 19


MEMORY1=`free -t -m | grep "Mem" | awk '{print $3" MB";}'`
MEMORY2=`free -t -m | grep "Mem" | awk '{print $2" MB";}'`
PSA=`ps -Afl | wc -l`

# time of day
HOUR=$(date +"%H")
if [ $HOUR -lt 12  -a $HOUR -ge 0 ]
then    TIME="morning"
elif [ $HOUR -lt 17 -a $HOUR -ge 12 ]
then    TIME="afternoon"
else
    TIME="evening"
fi

#System uptime
uptime=`cat /proc/uptime | cut -f1 -d.`
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))

#System load
LOAD1=`cat /proc/loadavg | awk {'print $1'}`
LOAD5=`cat /proc/loadavg | awk {'print $2'}`
LOAD15=`cat /proc/loadavg | awk {'print $3'}`

#Return message
[ -z "$ROOT" ] && ROOT="root partition not available" || ROOT="$ROOT remaining"
[ -z "$HOME" ] && HOME="home partition not available" || HOME="$HOME remaining"
[ -z "$BACKUP" ] && BACKUP="backup partition not available" || BACKUP="$BACKUP remaining"
[ -z "$MNT" ] && MNT="usb partition not available" || MNT="$MNT remaining"
[ -z "$TEMPERATURE" ] && TEMPERATURE="not available"
[ -x "$(command -v sensors)" ] || TEMPERATURE="lm_sensors not found"

echo -e "
\e[92m
 ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
 ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
 ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ 
 ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ 
 ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
 ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
\e[0m
Good $TIME $USER"

echo "
===========================================================================
 - Hostname............: $HOSTNAME
 - Release.............: `cat /etc/redhat-release`
 - Users...............: Currently `users | wc -w` user(s) logged on
===========================================================================
 - Current user........: $USER
 - CPU usage...........: $LOAD1, $LOAD5, $LOAD15 (1, 5, 15 min)
 - Memory used.........: $MEMORY1 / $MEMORY2
 - Swap in use.........: `free -m | tail -n 1 | awk '{print $3}'` MB
 - Processes...........: $PSA running
 - System uptime.......: $upDays days $upHours hours $upMins minutes $upSecs seconds
 - Disk space ROOT.....: $ROOT
 - Disk space HOME.....: $HOME
 - Disk space BACK.....: $BACKUP
 - Disk space USB......: $MNT
 - Temperature.........: $TEMPERATURE
===========================================================================
"

