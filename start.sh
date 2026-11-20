#!/bin/sh

PORT="${PORT:-10000}"

sed -i "s/port=\"8080\"/port=\"$PORT\"/" "$CATALINA_HOME/conf/server.xml"

exec catalina.sh run
