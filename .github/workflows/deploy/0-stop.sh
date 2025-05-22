#!/bin/bash

# 停止相关进程
#app_alive=`ss -lanput |grep -w LISTEN |grep -w $SERVER_PORT |wc -l`
#pid_exist=`ss -lanput |grep -w LISTEN |grep -w $SERVER_PORT |grep 'pid=' |wc -l`
#if [ $app_alive -ne 0 ] && [ $pid_exist -eq 0 ];then
#  pid=`ss -lanput |grep -w LISTEN |grep -w $SERVER_PORT |awk -F',' '{print $2}'`
#  kill -9 $pid
#elif [ $app_alive -ne 0 ] && [ $pid_exist -ne 0 ];then
#  pid=`ss -lanput |grep -w LISTEN |grep -w $SERVER_PORT |awk -F'[,=]+' '{print $3}'`
#  kill -9 $pid
#fi