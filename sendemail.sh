#!/bin/bash
VARS="SMTP_SERVER SMTP_USER SMTP_PORT SMTP_PASSWORD"
SUBJECT="Tste configuração email"
MESSAGE="<p>$(date +%Y%m%d%H%M)</p><p>A jornada de mil milhas começa com um único passo.  - Laozi</p>"
TO="wojehaj502@stypedia.com"

sendemail --version

if [ ! $? -eq 0 ];then
    echo "instalar"
    apt install sendemail -y
fi

set_value(){
    if [ "$1" == "SMTP_SERVER" ];then
            SMTP_SERVER=$2
        elif [ "$1" == "SMTP_USER" ];then
            SMTP_USER=$2
        elif [ "$1" == "SMTP_PORT" ];then
            SMTP_PORT=$2
        elif [ "$1" == "SMTP_PASSWORD" ];then
            SMTP_PASSWORD=$2
        fi
}

for var in $VARS; do
    VAR_EXIST=$(cat shellkit.conf|grep -i $var=|cut -d'=' -f2)
    if [ -z "$VAR_EXIST" ];then
        read -p "$var=" VALUE
        echo "$var=$VALUE" >> shellkit.conf
        set_value $var $VALUE
    else
        set_value $var $VAR_EXIST
    fi
done
sendemail -f $SMTP_USER -t $TO -u "$SUBJECT" -m "$MESSAGE" -s $SMTP_SERVER:$SMTP_PORT -o tls=yes -xu $SMTP_USER -xp $SMTP_PASSWORD -o message-content-type=html