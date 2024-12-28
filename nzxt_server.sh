#!/bin/bash

# server script to run liquidctl commands via a pair of named pipes,
# to allow communication between a docker container and its host.

scriptFolder=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

# Pipes were created via mkfifo and setting appropriate rights

inpipe=$scriptFolder/nzxt
outpipe=$scriptFolder/nzxt-out

while true
do
    if read line < "$inpipe"; then
        # clean out anything that's not alphanumeric, a space, or an underscore
        cleanLine=${line//[^a-zA-Z0-9_ ]/}
        # lowercase with TR
        cleanLine=`echo -n $cleanLine | tr A-Z a-z`
        /usr/bin/liquidctl --match NZXT ${cleanLine} > /tmp/nzxt-output.log 2>&1
        errorCode=$?
        result=$(</tmp/nzxt-output.log)
        if [ "$errorCode" -eq 0 ] && ! [ -n "$result" ]; then
            result="OK"
        fi
        if [ "$result" != "OK" ]; then
            result="[#$errorCode] $result"
            echo "request: $cleanLine"
            echo "response: $result"
        fi
        echo "$result" > "$outpipe"
    fi
done
