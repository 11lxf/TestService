#!/bin/bash

echo "0.启动程序..."
${JAVA_HOME}/bin/java -jar $DEPLOY_PATH/$SERVICE_NAME/$ARTIFACT_ID-$VERSION.jar \
--spring.profiles.active=uat > $DEPLOY_PATH/$SERVICE_NAME/java.log &
#chown -R appuser:appuser "$app_dir"/
#su appuser -c "${JAVA_HOME}/bin/java \
#-Dcustom.authentication.private-secret-key=${AUTH_PRIVATE_SECRET_KEY} \
#-Djasypt.encryptor.password=${JASYPT_ENCRYPTOR_PASSWORD} -jar $app_dir/${PACKAGE_NAME} \
#--server.port=${SERVER_PORT} --spring.profiles.active=${PROFILES_ACTIVE} >> ${app_dir}/java.log & "