#!/bin/bash
set -ex
SERVICE_NAME="TestService"
PACKAGE_PATH="target"
PACKAGE_NAME="test-service-0.0.1-SNAPSHOT.jar"
DEPLOY_PATH=".github/workflows/deploy"

echo "Release is ${isRelease}"
# 判断当前构建是否为版本构建，以及定义构建变量(包版本,包服务名称,包编译存放路径,包类型,包编译名称,包打包名称)
if [ "${isRelease}"x = "false"x ]; then
  SERVICE_VERSION='0.0.1-SNAPSHOT'
  # 版本号+时间戳+build随机数写入buildInfo.properties
  # echo "buildVersion=${SERVICE_VERSION}.$buildNumber" > buildInfo.properties
  # sed -i 's/VERSION/'${SERVICE_VERSION}.${buildNumber}'/g' ${DEPLOY_PATH}/appspec.yml
  # 压缩包名称
  # PACKAGE_TAR_PATH="${SERVICE_NAME}_${SERVICE_VERSION}.${buildNumber}"

  # 用于获取当前脚本所在的绝对路径
  workdir=$(
    # $0 输出bash后面的第一个参数，即脚本名称，如 bash /opt/test/test.sh即输出 /opt/test/test.sh; bash test.sh 即输出 test.sh
    # dirname命令用于去除文件路径名中的最后一个斜杠（/）及其之后的所有字符，从而获取文件所在的目录路径
    # $(dirname $0) 输出的是当前目录到脚本的相对路径（比如 bash /opt/test/test.sh 输出的就是 /opt/test; bash test.sh 输出的就是.）
    # 所以cd $(dirname $0) 切换到脚本所在目录
    cd $(dirname $0)
    # 然后输出当前目录的绝对路径
    pwd
  )
  # 此时相对路径在 .github/workflows/build 的上一层目录 .github/workflows
  cd $workdir/..
  # maven打包命令
  mvn clean deploy --settings https_settings.xml -Dmaven.test.skip=true -DfinalName=${PACKAGE_NAME}
elif [ "${isRelease}"x = "true"x ]; then
  SERVICE_VERSION=${releaseVersion}
  # 版本号+时间戳+build随机数写入buildInfo.properties
  echo "buildVersion=${SERVICE_VERSION}" >buildInfo.properties
  sed -i 's/VERSION/'${SERVICE_VERSION}'/g' ${DEPLOY_PATH}/appspec.yml
  # 压缩包名称
  PACKAGE_TAR_PATH="${SERVICE_NAME}_${SERVICE_VERSION}"
  # 执行工程编译
  workdir=$(
    cd $(dirname $0)
    pwd
  )
  cd $workdir/..
  # maven打包并发布到私仓
  mvn clean package --settings .github/workflows/https_settings.xml -Dmaven.test.skip=true -U -Dmaven.wagon.http.ssl.insecure=true
fi

# 压缩目标包
# mkdir -p ${PACKAGE_TAR_PATH}/packages
# mv ${PACKAGE_PATH}/${PACKAGE_NAME} ${PACKAGE_TAR_PATH}/packages
# mv ${DEPLOY_PATH}/* ${PACKAGE_TAR_PATH}
# tar -zcf ${PACKAGE_PATH}/${PACKAGE_TAR_PATH}.tar.gz ${PACKAGE_TAR_PATH}/*
