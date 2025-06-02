# 使用官方的 openjdk:21-jdk-slim 镜像作为基础镜像
FROM openjdk:21-jdk-slim

# 设置工作目录
WORKDIR /app

# 使用 ARG 指定构建时的环境变量
ARG ARTIFACT_ID
ARG VERSION

# 定义环境变量，用于ENTRYPOINT启动命令变量
ENV ARTIFACT_ID=${ARTIFACT_ID}
ENV VERSION=${VERSION}

# 将构建好的 JAR 文件复制到镜像中
COPY target/$ARTIFACT_ID-$VERSION.jar /app/$ARTIFACT_ID-$VERSION.jar

# 默认暴露应用的端口
EXPOSE 8080

# 定义启动命令，使用了 exec 格式，不会自动解析变量
# ENTRYPOINT ["java", "-jar", "${ARTIFACT_ID}-${VERSION}.jar"]

# 定义启动命令，需要使用 shell 脚本显式执行，才会解析变量的方式
ENTRYPOINT ["/bin/sh", "-c", "java -jar ${ARTIFACT_ID}-${VERSION}.jar"]