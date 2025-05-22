#!/bin/bash

NEXUS_HOST="https://nexus.shawf.me"
GROUP_ID="me.shawf"
ARTIFACT_ID="test-service"

#  检查部署目录是否存在，不存在则创建
if [ ! -d "$DEPLOY_PATH/$SERVICE_NAME" ]; then
    echo "部署目录不存在，正在创建: $DEPLOY_PATH/$SERVICE_NAME"
    mkdir -p "$DEPLOY_PATH/$SERVICE_NAME"
else
    echo "部署目录已存在: $DEPLOY_PATH/$SERVICE_NAME"
fi

## 进入部署目录
cd "$DEPLOY_PATH/$SERVICE_NAME" || { echo "无法进入部署目录"; exit 1; }

# 从私有仓库拉取安装包
echo "1.下载maven-metadata.xml..."
METADATA_URL="$NEXUS_HOST/repository/maven-snapshots/$GROUP_ID/$ARTIFACT_ID/$SERVICE_VERSION/maven-metadata.xml"
if wget --user=$MAVEN_USERNAME --password=$MAVEN_PASSWORD "$METADATA_URL" -O maven-metadata.xml; then
      echo "maven-metadata.xml拉取成功: maven-metadata.xml"
  else
      echo "maven-metadata.xml拉取失败"
      exit 1
  fi
echo "2.正在从maven-metadata.xml解析出snapshotVersion字段并拼接安装包下载URL..."
SNAPSHOT_VERSION=$(grep '<value>' maven-metadata.xml | sed 's/<[^>]*>//g' | head -n1)
DOWNLOAD_URL="$NEXUS_HOST/repository/maven-snapshots/$GROUP_ID/$ARTIFACT_ID/$SERVICE_VERSION/$ARTIFACT_ID-$SNAPSHOT_VERSION.jar"

echo "3.正在从私有仓库拉取安装包..."
if wget "$DOWNLOAD_URL" -O "$ARTIFACT_ID-$SERVICE_VERSION.jar"; then
    echo "安装包拉取成功: $ARTIFACT_ID-$SERVICE_VERSION.jar"
else
    echo "安装包拉取失败"
    exit 1
fi

# 解压安装包（如果需要）
# tar -xzvf "$PACKAGE_NAME"

echo "安装完成"
