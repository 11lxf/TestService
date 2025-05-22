#!/bin/bash
set -ex
SERVICE_NAME="TestService"
#PACKAGE_PATH="target"
PACKAGE_NAME="test-service-1.0.0-SNAPSHOT.jar"
DEPLOY_PATH=".github/workflows/deploy"

# github action工作目录是项目根目录

echo "Release is ${isRelease}"
# 判断当前构建是否为版本构建，以及定义构建变量(包版本,包服务名称,包编译存放路径,包类型,包编译名称,包打包名称)
if [ "${isRelease}"x = "false"x ]; then
  SERVICE_VERSION='1.0.0-SNAPSHOT'
  # 生成时间戳（精确到秒）
  TIMESTAMP=$(date +'%Y%m%d%H%M%S')
  # 版本号写入部署配置文件appspec.yml
  sed -i 's/VERSION/'${SERVICE_VERSION}.${TIMESTAMP}'/g' ${DEPLOY_PATH}/appspec.yml
  # 压缩包名称
  PACKAGE_NAME="${SERVICE_NAME}_${SERVICE_VERSION}.${TIMESTAMP}.jar"
  # maven打包并发布到私仓
  mvn clean deploy --settings .github/workflows/https_settings.xml -DfinalName=${PACKAGE_NAME}
elif [ "${isRelease}"x = "true"x ]; then
  SERVICE_VERSION=${releaseVersion}
  # 版本号+时间戳+build随机数写入buildInfo.properties
  echo "buildVersion=${SERVICE_VERSION}" >buildInfo.properties
  sed -i 's/VERSION/'${SERVICE_VERSION}'/g' ${DEPLOY_PATH}/appspec.yml
  # 压缩包名称
  PACKAGE_TAR_PATH="${SERVICE_NAME}_${SERVICE_VERSION}"
  # maven打包并发布到私仓, 主仓合入代码前必须保证所有测试通过，所以发布正式环境时跳过单元测试
  mvn clean deploy --settings .github/workflows/https_settings.xml -Dmaven.test.skip=true -U -Dmaven.wagon.http.ssl.insecure=true
fi

# 压缩目标包
# mkdir -p ${PACKAGE_TAR_PATH}/packages
# mv ${PACKAGE_PATH}/${PACKAGE_NAME} ${PACKAGE_TAR_PATH}/packages
# mv ${DEPLOY_PATH}/* ${PACKAGE_TAR_PATH}
# tar -zcf ${PACKAGE_PATH}/${PACKAGE_TAR_PATH}.tar.gz ${PACKAGE_TAR_PATH}/*
