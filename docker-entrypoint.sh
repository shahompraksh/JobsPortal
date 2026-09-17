#!/usr/bin/env bash
set -e

# Dynamically bind Tomcat HTTP port to $PORT assigned by cloud providers (Railway, Render, etc.)
if [ -n "$PORT" ] && [ "$PORT" != "8080" ]; then
    echo "[Entrypoint] Configuring Tomcat to listen on port ${PORT}..."
    sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml
fi

echo "[Entrypoint] Starting Apache Tomcat 11..."
exec catalina.sh run
