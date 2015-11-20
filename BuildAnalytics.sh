#!/bin/bash

# This script collect build info and sends it to my server
# Copyright (C) 2015 Jacob McSwain
#
# This file is part of BuildAnalytics.
#
# BuildAnalytics is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation.
#
# BuildAnalytics is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with BuildAnalytics. If not, see <http://www.gnu.org/licenses/>.


PROC_MODEL=$(cmd /proc/cpuinfo | grep "model name" | awk -F':' '{print $}' | head -n 1 | xargs)
NUMBER_OF_PROCS=$(cmd /proc/cpuinfo | grep "physical id" | sort -u | wc -l)

DISTRO="Unix-like"

if [ -f /etc/lsb-release ]; then
    # shellcheck disable=SC1091
    . /etc/lsb-release
    DISTRO=$DISTRIB_ID
elif [ -f /etc/debian_version ]; then
    DISTRO="Debian"
elif [ -f /etc/redhat-release ]; then
    DISTRO="Red Hat"
else
    DISTRO=$(uname -s)
fi

BUILD_USING_CCACHE=$USE_CCACHE
CCACHE_SIZE=$(ccache -s | grep "max cache size" | awk -F' ' '{print $4 " " $5}')
DISK_INFO=$(lsblk -d -o name,rota)
NUM_DISKS=$(lsblk -d -o name,rota | wc -l)

SSD_DISKS=""
HDD_DISKS=""

COUNTER=0
while [ $COUNTER -lt $((NUM_DISKS-1)) ]; do
            TMPDISKINFO=$(echo "$DISK_INFO" | sed -n "$COUNTER p")
            if [[ "$TMPDISKINFO" == *0 ]]
                then
                    SSD_DISKS=$SSD_DISKS,$(echo "$TMPDISKINFO" | awk -F' ' '{print $1}')
                else
                    HDD_DISKS=$HDD_DISKS,$(echo "$TMPDISKINFO" | awk -F' ' '{print $1}')
            fi
            let COUNTER=COUNTER+1 
        done
        
OUT_VOLUME=$(df "$OUT_DIR_COMMON_BASE" | sed -n "2p" | awk -F' ' '{print $1}')

BASEURL="http://mcswainsoftware.com/regAndroidBuild.php?"
FULLURL=$BASEURL"cpu=$PROC_MODEL&numprocs=$NUMBER_OF_PROCS&distro=$DISTRO&using_ccache=$BUILD_USING_CCACHE&ccache_size=$CCACHE_SIZE&ssds=$SSD_DISKS&hdds=$HDD_DISKS&outvolume=$OUT_VOLUME"
echo -e "$FULLURL"
curl "$FULLURL"
