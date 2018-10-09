#!/bin/bash

set -x

# Outout format:
# nr_concurr_msgs,...
# throughput (Mops),...
# ...

PROJECT_ROOT=~/workspace/rdma-tutorial
APP_BIN=rdma-tutorial
MSG_SIZE=(8 32 128 512 2048 4096)
NR_CONCURR_MSG=(4 8 16 32 64 128 512 1024 2048 4096)
S=r0
C=r1

test -f $APP_BIN || make

function start_server
{
    local msg_size=$1
    local nr_concurr_msgs=$2
    local port=$3

    ssh $S "mkdir -p $PROJECT_ROOT"

    ssh $S "pkill rdma-tutorial"
    scp $APP_BIN $S:$PROJECT_ROOT/
    echo "./$APP_BIN $msg_size $nr_concurr_msgs $port >stdout.log 2>&1 &" | \
        ssh $S "cd $PROJECT_ROOT && cat > run_server.sh && sh run_server.sh"
}

function start_client
{
    local msg_size=$1
    local nr_concurr_msgs=$2
    local port=$3

    ./$APP_BIN $S $msg_size $nr_concurr_msgs $port
}

# Clear
printf > output.csv
for msg_size in ${MSG_SIZE[@]}; do
    printf "nr_concurr_msgs ($msg_size),throughput (Mops)\n" >> output.csv
    for nr_concurr_msgs in ${NR_CONCURR_MSG[@]}; do
        printf "Start ./$APP_BIN $S $msg_size $nr_concurr_msgs $port\n"
        printf "${nr_concurr_msgs}" >> output.csv
        start_server $msg_size $nr_concurr_msgs 10000
        start_client $msg_size $nr_concurr_msgs 10000 && \
            cat client.log | grep throughput | awk '{ print ","$4 }' >> output.csv
        printf "Done!\n"
    done
done

ssh $S "pkill rdma-tutorial"

