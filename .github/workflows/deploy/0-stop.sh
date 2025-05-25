#!/bin/bash

echo "0.停止相关进程..."
PID=$(ps -ef | grep $ARTIFACT_ID-$VERSION.jar | grep -v grep | awk '{ print $2 }')
if [ -n "$PID" ]; then
    echo "Killing process with PID $PID"
    kill -9 $PID
fi