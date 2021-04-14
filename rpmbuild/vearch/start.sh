#!/bin/bash

SERVER_TYPE=all

mkdir -p /var/log/vearch
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/etc/vearch/lib
nohup /etc/vearch/bin/vearch -conf /etc/vearch/conf/config.toml $SERVER_TYPE $1>/var/log/vearch/vearch.log 2>&1 &
echo $! > /etc/vearch/pid
exit 0
