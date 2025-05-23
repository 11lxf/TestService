#!/bin/bash

echo "0.健康检查..."
# 健康检查
#status_check() {
#	echo `curl -I -m 10 -o /dev/null -s -w %{http_code} "http://localhost:${service_port}/api/v1/test/healthcheck"`
#}
#
## 设置最大尝试次数
#max_attempts=60
#attempts=0
#
#result=$(status_check)
#until [ "200"x = "$result"x ] || [ $attempts -ge $max_attempts ]
#do
#	result=$(status_check)
#	((attempts++))
#	sleep 2
#done
#
## 检查是否达到最大尝试次数
#if [ $attempts -ge $max_attempts ]; then
#    echo "Timeout reached, status is not 200"
#    exit 1 # 返回错误状态码
#else
#    echo "Status is 200"
#    exit 0 # 返回成功状态码
#fi