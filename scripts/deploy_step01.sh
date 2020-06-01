#!/bin/bash

REPOSITORY=/home/ubuntu/app/step1
PROJECT_NAME=springboot_on_aws_with_travisCI
PROPERTIES_PATH=$REPOSITORY/..
REAL_PROPERTIES=$PROPERTIES_PATH/application-real.properties
OAUTH_PROPERTIES=$PROPERTIES_PATH/application-oauth.properties
REAL_DB_PROPERTIES=$PROPERTIES_PATH/application-real-db.properties
ALL_PROPERTIES=classpath:/application.properties,$REAL_PROPERTIES,$OAUTH_PROPERTIES,$REAL_DB_PROPERTIES


cd $REPOSITORY/$PROJECT_NAME/

echo "> Git Pull"
git pull

echo "> 프로젝트 build 시작"
./gradlew build

echo "> step01 디렉토리로 이동"
cd $REPOSITORY

echo "> Build 파일 복사"
cp $REPOSITORY/$PROJECT_NAME/build/libs/*.jar $REPOSITORY/

echo "> 현재 구동중인 애플리케이션 pid 확인"

JAR_NAME=$(ls -tr $REPOSITORY | grep *.jar | tail -n 1)
CURRENT_PID=$(pgrep -f $JAR_NAME)

echo "> 현재 구동중인 애플리케이션 pid : $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
	echo "> 현재 구동중인 애플리케이션이 없으므로 중지하지 않습니다."
else
	echo "> kill -15 $CURERNT_PID"
	kill -15 $CURRENT_PID
	sleep 5
fi

echo "> 새 애플리케이션 배포"

echo "> JAR Name: $JAR_NAME"

JAVA_JAR_RUN="java -jar -Dspring.config.location=$ALL_PROPERTIES -Dspring.profile.active=real $REPOSITORY/$JAR_NAME"
echo "> $JAVA_JAR_RUN"
nohup $JAVA_JAR_RUN 2>&1 &
