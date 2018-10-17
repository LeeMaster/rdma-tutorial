#!/bin/bash

set -x

PROJECT_ROOT=/home/rh/workspace/rdma-tutorial
APP_BIN=rdma-tutorial

ssh r0 "pkill rdma-tutorial"
scp $APP_BIN r0:$PROJECT_ROOT/
echo "./$APP_BIN 1 1 10000 >stdout.log 2>&1 &" | \
    ssh r0 "cd $PROJECT_ROOT && cat > run_server.sh && sh run_server.sh"
./$APP_BIN r0 1 1 10000
ssh r0 "pkill rdma-tutorial"
