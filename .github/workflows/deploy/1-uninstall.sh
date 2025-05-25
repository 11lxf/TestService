#!/bin/bash

echo "0.删除对应文件..."
find /opt/apps/TestService/ \( -name '*.jar' -o -name 'maven-metadata.xml' \) -delete