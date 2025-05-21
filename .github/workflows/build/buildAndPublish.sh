#!/bin/bash
set -ex
SERVICE_NAME="TestService"
PACKAGE_PATH="target"
PACKAGE_NAME="test-service-0.0.1-SNAPSHOT.jar"
DEPLOY_PATH=".github/workflows/deploy"

# github action工作目录是项目根目录

echo "Release is ${isRelease}"
# 判断当前构建是否为版本构建，以及定义构建变量(包版本,包服务名称,包编译存放路径,包类型,包编译名称,包打包名称)
if [ "${isRelease}"x = "false"x ]; then
  SERVICE_VERSION='0.0.1-SNAPSHOT'
  # 版本号+时间戳+build随机数写入buildInfo.properties
  # echo "buildVersion=${SERVICE_VERSION}.$buildNumber" > buildInfo.properties
  # sed -i 's/VERSION/'${SERVICE_VERSION}.${buildNumber}'/g' ${DEPLOY_PATH}/appspec.yml
  # 压缩包名称
  # PACKAGE_TAR_PATH="${SERVICE_NAME}_${SERVICE_VERSION}.${buildNumber}"

  # maven打包并发布到私仓
  mvn clean deploy --settings .github/workflows/https_settings.xml -Dmaven.test.skip=true -DfinalName=${PACKAGE_NAME}
elif [ "${isRelease}"x = "true"x ]; then
  SERVICE_VERSION=${releaseVersion}
  # 版本号+时间戳+build随机数写入buildInfo.properties
  echo "buildVersion=${SERVICE_VERSION}" >buildInfo.properties
  sed -i 's/VERSION/'${SERVICE_VERSION}'/g' ${DEPLOY_PATH}/appspec.yml
  # 压缩包名称
  PACKAGE_TAR_PATH="${SERVICE_NAME}_${SERVICE_VERSION}"
  # maven打包并发布到私仓
  mvn clean deploy --settings .github/workflows/https_settings.xml -Dmaven.test.skip=true -U -Dmaven.wagon.http.ssl.insecure=true
fi

# 压缩目标包
# mkdir -p ${PACKAGE_TAR_PATH}/packages
# mv ${PACKAGE_PATH}/${PACKAGE_NAME} ${PACKAGE_TAR_PATH}/packages
# mv ${DEPLOY_PATH}/* ${PACKAGE_TAR_PATH}
# tar -zcf ${PACKAGE_PATH}/${PACKAGE_TAR_PATH}.tar.gz ${PACKAGE_TAR_PATH}/*
