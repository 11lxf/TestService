#!/bin/bash
set -ex
# 生成时间戳（精确到秒）
#TIMESTAMP=$(date +'%Y%m%d%H%M%S')
# github action工作目录是项目根目录

echo "Release is ${IS_RELEASE}"
# 判断当前构建是否为版本构建，以及定义构建变量(包版本,包服务名称,包编译存放路径,包类型,包编译名称,包打包名称)
if [ "${IS_RELEASE}"x = "false"x ]; then
  # 保存版本变量到输出变量version
  echo "version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)" >> $GITHUB_OUTPUT
  # maven打包并发布到私仓
  mvn clean deploy --settings .github/workflows/https_settings.xml
elif [ "${IS_RELEASE}"x = "true"x ]; then
  # 保存版本变量到输出变量version
  echo "version=${RELEASE_VERSION}" >> $GITHUB_OUTPUT
  # 设定 release 版本, -DgenerateBackupPoms=false 表示不生成备份文件
  mvn versions:set -DnewVersion=${RELEASE_VERSION} -DgenerateBackupPoms=false
  # maven打包并发布到私仓, 主仓合入代码前必须保证所有测试通过，所以发布正式环境时跳过单元测试
  mvn clean deploy --settings .github/workflows/https_settings.xml -Dmaven.test.skip=true
fi
