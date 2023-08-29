#!/bin/bash

LOG_LEVEL="0"
APP_NAME="app-test22"
TEST_TAG="[TEST SETUPTAG]"
TEST_MESSAGE="Testando a mensagem"


if [ ! -f shellkit.conf ];then
    echo "SYSLOG_LOGLEVEL=0" > shellkit.conf
else
    LOG_LEVEL=$(cat shellkit.conf|grep -i SYSLOG_LOGLEVEL=|cut -d'=' -f2)
    if [ "$LOG_LEVEL" -lt 7 ];then
        cat  shellkit.conf | sed "s/SYSLOG_LOGLEVEL=$LOG_LEVEL/SYSLOG_LOGLEVEL=$(expr $LOG_LEVEL + 1)/" > shellkit.conf
        LOG_LEVEL=$( expr $LOG_LEVEL + 1)
    else
        echo "max level"
        exit 1
    fi
fi

echo "local$LOG_LEVEL.* /var/log/$APP_NAME.log" > /etc/rsyslog.d/$APP_NAME.conf

systemctl restart rsyslog
logger -p local1.info -t $TEST_TAG $TEST_MESSAGE
sleep 3
if [ $(tail -n1 /var/log/$APP_NAME.log | grep "$TEST_TAG" | wc -l ) -gt 0 ];then
    echo "LOG LEVEL:$LOG_LEVEL initialized "
    echo "" > /var/log/$APP_NAME.log
    exit 0
else
    echo ""
fi