#!/bin/bash

scriptFolder=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

echo "called client with $@" >> $scriptFolder/client.log
inpipe=$scriptFolder/nzxt
outpipe=$scriptFolder/nzxt-out

echo "$@" > $inpipe
cat < $outpipe
