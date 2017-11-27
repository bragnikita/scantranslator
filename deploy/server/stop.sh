#!/usr/bin/env bash
RED=$( tput setaf 1 )
GREEN=$( tput setaf 2 )
RESET=$( tput sgr0 )

BASE='/home/ec2-user/service-app'
APP="$BASE/current"
SHARED="$BASE/shared"
PID_FILE="$SHARED/tmp/pids/puma.pid"
if [ -e "$PID_FILE" ]; then
    PUMA_PID=$( cat "$PID_FILE" )
    echo "Stopping Puma with pid $PUMA_PID"
    kill ${PUMA_PID}

    while true
    do
        sleep 1
        ps aux | grep puma | grep -v grep > /dev/null
        [ ! $? = "0" ] && break
    done
else
    echo "$RED pid file was not found in $SHARED/tmp/pids/puma.pid $RESET"
fi

echo "Checking whether puma is running"
ps aux | grep puma | grep -v grep > /dev/null
if [ $? = "0" ]
then
    echo "$RED Could not stop puma $RESET"
    ps aux | grep puma | grep -v grep
    exit 1
else
    echo "$GREEN Puma has been successfully finished $RESET"
    exit 0
fi