#!/bin/bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh
source ~/.bashrc

REPOSITORY=/home/ubuntu/app/step3
PROJECT_NAME=springboot_on_aws_with_travisCI
PROPERTIES_PATH=$REPOSITORY/..
REAL_PROPERTIES=$PROPERTIES_PATH/application-real.properties
OAUTH_PROPERTIES=$PROPERTIES_PATH/application-oauth.properties
REAL_DB_PROPERTIES=$PROPERTIES_PATH/application-real-db.properties

echo "> Build 파일 복사"
echo "> cp $REPOSITORY/zip/*.jar $REPOSITORY/"

cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> 새 어플리케이션 배포"
JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

IDLE_PROFILE=$(find_idle_profile)
IDLE_PROPERTIES=classpath:/application-$IDLE_PROFILE.properties
ALL_PROPERTIES=classpath:/application.properties,$IDLE_PROPERTIES,$REAL_PROPERTIES,$OAUTH_PROPERTIES,$REAL_DB_PROPERTIES

echo "> $JAR_NAME 를 profile=$IDLE_PROFILE 로 실행합니다."
#nohup java -jar \
#    -Dspring.config.location=classpath:/application.properties,classpath:/application-$IDLE_PROFILE.properties,$PROPERTIES_PATH/application-oauth.properties,$PROPERTIES_PATH/application-real-db.properties \
#    -Dspring.profiles.active=$IDLE_PROFILE \
#    $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &

JAVA_JAR_RUN="/home/ubuntu/.sdkman/candidates/java/current/bin/java -jar -Dspring.config.location=$ALL_PROPERTIES -Dspring.profile.active=$IDLE_PROFILE $JAR_NAME "
echo "> $JAVA_JAR_RUN"
nohup $JAVA_JAR_RUN  > $REPOSITORY/nohup 2>&1 &
